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

That installs:

- `och` to `~/.local/bin/och`
- Bash completion to `~/.local/share/bash-completion/completions/och`

## Usage

```bash
och help
```

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
och list-sessions --agent <TAB>
och delete-session <TAB>
och get-agent-skill <TAB>
```
