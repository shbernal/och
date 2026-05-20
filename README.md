# Open Claw Helper

Small OpenClaw helper CLI for session management, skill browsing, workspace files, and TUI launch shortcuts.

## Commands

```bash
och session list [--agent <agent>]
och session delete <session-key>
och session name <session-key> [name]
och session name --all [--agent <agent>]

och workspace status [--agent <agent>]

och tui <session-key> [openclaw-tui-args...]

och skill list [agent]
och skill open <skill-name>
och skill print <skill-name>

och memory list <agent>
och memory open <agent> [--note <note>]
och memory print <agent> [--note <note>]

och heartbeat open <agent>
och heartbeat print <agent>
och identity open <agent>
och identity print <agent>
och soul open <agent>
och soul print <agent>
och tools open <agent>
och tools print <agent>
och user-file open <agent>
och user-file print <agent>

och agent-file open <agent> <relative-path>
och agent-file print <agent> <relative-path>
```

## Notes

- `open` uses `$EDITOR`.
- `print` uses `glow` when available, then `bat`, then `less -R` for TTY output, then `cat`.
- `memory --note` accepts a full filename, a filename without `.md`, or an unambiguous date/name prefix.
- `workspace status` prints `git status --short --branch` for each Git workspace under `~/.openclaw/workspace/`.
- `agent-file` only accepts safe relative paths under the agent workspace.
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
och agent-file print <TAB>
```

For session-taking commands, completion offers both raw session keys and named sessions. After installation, reload completion or start a new shell before testing.
