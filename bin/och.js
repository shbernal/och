#!/usr/bin/env node
'use strict';

const { spawn } = require('child_process');
const { existsSync } = require('fs');
const path = require('path');

const scriptPath = path.resolve(__dirname, '..', 'och');

if (!existsSync(scriptPath)) {
  console.error(`och: packaged shell script not found: ${scriptPath}`);
  process.exit(1);
}

const child = spawn('bash', [scriptPath, ...process.argv.slice(2)], {
  stdio: 'inherit',
});

child.on('error', (error) => {
  if (error.code === 'ENOENT') {
    console.error('och: required command not found: bash');
    process.exit(127);
  }

  console.error(`och: failed to start shell wrapper: ${error.message}`);
  process.exit(1);
});

child.on('exit', (code, signal) => {
  if (signal) {
    const signalNumbers = {
      SIGHUP: 1,
      SIGINT: 2,
      SIGQUIT: 3,
      SIGTERM: 15,
    };
    process.exit(128 + (signalNumbers[signal] || 0));
  }

  process.exit(code === null ? 1 : code);
});
