# Open Claw Helper

Small OpenClaw helper CLI for session management, skill browsing, workspace files, and TUI launch shortcuts.

## Commands

```bash
och session list [--agent <agent>]
och session delete <session-key>
och session name <session-key> [name]
och session name --all [--agent <agent>]

och workspace status [--agent <agent>]
och workspace open <agent>

och tui <session-key> [openclaw-tui-args...]

och skill list [agent]
och skill open <skill-name>
och skill print <skill-name>

och memory list <agent>
och memory open <agent> [--note <note>]
och memory print <agent> [--note <note>]

och agentsmd open <agent>
och agentsmd print <agent>
och heartbeat open <agent>
och heartbeat print <agent>
och identity open <agent>
och identity print <agent>
och soul open <agent>
och soul print <agent>
och tools open <agent>
och tools print <agent>
och usermd open <agent>
och usermd print <agent>

och file open <agent> <relative-path>
och file print <agent> <relative-path>
```

## Notes

- `open` uses `$EDITOR`.
- `print` uses `glow` when available, then `bat`, then `less -R` for TTY output, then `cat`.
- `memory --note` accepts a full filename, a filename without `.md`, or an unambiguous date/name prefix.
- `workspace status` prints `git status --short --branch` for each Git workspace under `~/.openclaw/workspace/`.
- `workspace open` opens the editor in `~/.openclaw/workspace/<agent>/`.
- `file` only accepts safe relative paths under the agent workspace.
- Session files live under `~/.openclaw/agents/<agent>/sessions/sessions.json`.
- Agent workspace files live under `~/.openclaw/workspace/<agent>/`.

## Dependencies

- `bash`
- `jq`
- `moreutils` (`sponge`)

Optional:

- `glow` for Markdown rendering
- `bat` for print fallback

## Install

```bash
make install-user
```

That installs:

- `och` to `~/.local/bin/och`
- Bash completion to `~/.local/share/bash-completion/completions/och`

For npm-based installs:

```bash
npm install -g @shbernal/och
```

The npm package installs a small Node wrapper that runs the bundled Bash CLI.
System dependencies still need to be available on `PATH`: `bash`, `jq`, and
`sponge` from `moreutils`.

## Bash Completion

If your shell loads `bash-completion`, `make install-user` is enough for the `och` symlink in `~/.local/bin` to pick up completions automatically.

For a repo-local test without installing:

```bash
source /usr/share/bash-completion/bash_completion
source ./completions/och.bash
complete -p och
```

Then try:

```bash
och <TAB>
och session <TAB>
och session list --agent <TAB>
och skill open <TAB>
och memory print amalia --note <TAB>
och heartbeat open <TAB>
och file print <TAB>
```

For session-taking commands, completion offers both raw session keys and named sessions. After installation, reload completion or start a new shell before testing.

## Release Guard

Before creating a release tag, verify that the intended version matches
`package.json.version`:

```bash
make check-release VERSION=0.1.7
git tag v0.1.7
```

After creating the tag, the same target can verify that `HEAD` is exactly tagged
with the matching version:

```bash
make check-release
```

The guard checks that the working tree is clean and that the release version
matches `package.json`.
