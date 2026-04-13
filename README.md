# Open Claw Helper

Quick and dirty tool for some features I feel the OpenClaw TUI is missing.

## Features

- `list-sessions`, lists session keys for one agent or all agents
- `get-session-names`, lists session keys together with their `displayName`
- `name-session`, renames a single session
- `name-sessions`, renames all sessions for one agent or all agents using their session key
- `list-agent-skills`, lists workspace skills by agent
- `delete-session`, deletes a session entry by session key

## Dependencies

- `bash`
- `jq`
- `moreutils` (`sponge`)

## Install

```bash
make install-user
```

## Usage

```bash
och help
```
