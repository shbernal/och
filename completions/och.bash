_och_commands() {
  printf '%s\n' \
    session \
    workspace \
    tui \
    skill \
    memory \
    heartbeat \
    identity \
    soul \
    tools \
    user-file \
    agent-file \
    help
}

_och_agents() {
  local dir
  shopt -s nullglob
  for dir in "$HOME"/.openclaw/agents/* "$HOME"/.openclaw/workspace/*; do
    [[ -d "$dir" ]] && basename "$dir"
  done | sort -u
  shopt -u nullglob
}

_och_session_targets() {
  local file
  shopt -s nullglob
  for file in "$HOME"/.openclaw/agents/*/sessions/sessions.json; do
    jq -r '
      to_entries[]
      | .key,
        (if .value.displayName == null or .value.displayName == "" then empty else .value.displayName end)
    ' "$file" 2>/dev/null
  done | awk '!seen[$0]++'
  shopt -u nullglob
}

_och_unescape_cur() {
  local value="$1"
  value="${value//\\ / }"
  value="${value//\\\\/\\}"
  printf '%s\n' "$value"
}

_och_complete_session_target() {
  local prefix candidate escaped
  prefix="$(_och_unescape_cur "$cur")"
  COMPREPLY=()
  while IFS= read -r candidate; do
    [[ "$candidate" == "$prefix"* ]] || continue
    printf -v escaped '%q' "$candidate"
    COMPREPLY+=("$escaped")
  done < <(_och_session_targets)
  if declare -F __ltrim_colon_completions >/dev/null 2>&1; then
    __ltrim_colon_completions "$cur"
  fi
  compopt -o nospace 2>/dev/null
}

_och_skills() {
  local dir
  shopt -s nullglob
  for dir in "$HOME"/.openclaw/skills/*; do
    [[ -d "$dir" ]] && basename "$dir"
  done
  for dir in "$HOME"/.openclaw/workspace/*/skills/*; do
    [[ -d "$dir" ]] && basename "$dir"
  done
  shopt -u nullglob
}

_och_memory_notes() {
  local agent="$1"
  local file
  [[ -n "$agent" ]] || return
  shopt -s nullglob
  for file in "$HOME"/.openclaw/workspace/"$agent"/memory/*.md; do
    [[ -f "$file" ]] && basename "$file"
  done
  shopt -u nullglob
}

_och_common_agent_files() {
  printf '%s\n' AGENTS.md SOUL.md TOOLS.md IDENTITY.md USER.md HEARTBEAT.md MEMORY.md
}

_och_contains_word() {
  local needle="$1"
  shift
  local word
  for word in "$@"; do
    [[ "$word" == "$needle" ]] && return 0
  done
  return 1
}

_och() {
  local cur prev words cword
  COMPREPLY=()

  if declare -F _get_comp_words_by_ref >/dev/null 2>&1; then
    _get_comp_words_by_ref -n : cur prev words cword
  elif declare -F _init_completion >/dev/null 2>&1; then
    _init_completion -n : || return
  else
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev=""
    if (( COMP_CWORD > 0 )); then
      prev="${COMP_WORDS[COMP_CWORD - 1]}"
    fi
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD
  fi

  if (( cword == 1 )); then
    COMPREPLY=( $(compgen -W "$(_och_commands)" -- "$cur") )
    return
  fi

  case "${words[1]}" in
    session)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "list delete name help" -- "$cur") )
          ;;
        *)
          case "${words[2]}" in
            list)
              if [[ "$prev" == "--agent" ]]; then
                COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
              elif [[ "$cur" == --* || -z "$cur" ]]; then
                COMPREPLY=( $(compgen -W "--agent" -- "$cur") )
              fi
              ;;
            delete)
              if (( cword == 3 )); then
                _och_complete_session_target
              fi
              ;;
            name)
              if [[ "$prev" == "--agent" ]]; then
                COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
              elif _och_contains_word --all "${words[@]}"; then
                COMPREPLY=( $(compgen -W "--agent" -- "$cur") )
              elif (( cword == 3 )); then
                COMPREPLY=( $(compgen -W "--all" -- "$cur") )
                _och_complete_session_target
              fi
              ;;
          esac
          ;;
      esac
      ;;
    workspace)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "status help" -- "$cur") )
          ;;
        *)
          case "${words[2]}" in
            status)
              if [[ "$prev" == "--agent" ]]; then
                COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
              elif [[ "$cur" == --* || -z "$cur" ]]; then
                COMPREPLY=( $(compgen -W "--agent" -- "$cur") )
              fi
              ;;
          esac
          ;;
      esac
      ;;
    tui)
      if (( cword == 2 )); then
        _och_complete_session_target
        return
      fi
      case "$prev" in
        --url|--token|--password|--thinking|--message|--timeout-ms|--history-limit)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--url --token --password --deliver --thinking --message --timeout-ms --history-limit -h --help" -- "$cur") )
      ;;
    skill)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "list open print help" -- "$cur") )
          ;;
        3)
          case "${words[2]}" in
            list)
              COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
              ;;
            open|print)
              COMPREPLY=( $(compgen -W "$(_och_skills)" -- "$cur") )
              ;;
          esac
          ;;
      esac
      ;;
    memory)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "list open print help" -- "$cur") )
          ;;
        3)
          COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
          ;;
        *)
          case "${words[2]}" in
            open|print)
              if [[ "$prev" == "--note" ]]; then
                COMPREPLY=( $(compgen -W "$(_och_memory_notes "${words[3]}")" -- "$cur") )
              elif [[ "$cur" == --* || -z "$cur" ]]; then
                COMPREPLY=( $(compgen -W "--note" -- "$cur") )
              fi
              ;;
          esac
          ;;
      esac
      ;;
    heartbeat|identity|soul|tools|user-file)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "open print help" -- "$cur") )
          ;;
        3)
          COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
          ;;
      esac
      ;;
    agent-file)
      case "$cword" in
        2)
          COMPREPLY=( $(compgen -W "open print help" -- "$cur") )
          ;;
        3)
          COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
          ;;
        4)
          COMPREPLY=( $(compgen -W "$(_och_common_agent_files)" -- "$cur") )
          ;;
      esac
      ;;
    help|-h|--help)
      ;;
  esac
}

complete -F _och och
