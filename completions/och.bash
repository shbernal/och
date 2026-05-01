_och_commands() {
  printf '%s\n' \
    list-sessions \
    get-session-names \
    name-session \
    name-sessions \
    list-agent-skills \
    ls-agent-skills \
    get-agent-skill \
    delete-session \
    launch-tui-session \
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

_och_sessions() {
  local file
  shopt -s nullglob
  for file in "$HOME"/.openclaw/agents/*/sessions/sessions.json; do
    jq -r 'keys[]' "$file" 2>/dev/null
  done
  shopt -u nullglob
}

_och_skills() {
  local dir
  shopt -s nullglob
  for dir in "$HOME"/.openclaw/workspace/*/skills/*; do
    [[ -d "$dir" ]] && basename "$dir"
  done
  shopt -u nullglob
}

_och() {
  local cur prev words cword

  if declare -F _init_completion >/dev/null 2>&1; then
    _init_completion || return
  else
    COMPREPLY=()
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
    list-sessions|get-session-names|name-sessions|list-agent-skills|ls-agent-skills)
      case "$prev" in
        -a|--agent)
          COMPREPLY=( $(compgen -W "$(_och_agents)" -- "$cur") )
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "-a --agent -h --help" -- "$cur") )
      ;;
    name-session|delete-session)
      if (( cword == 2 )); then
        COMPREPLY=( $(compgen -W "$(_och_sessions)" -- "$cur") )
      fi
      ;;
    launch-tui-session)
      if (( cword == 2 )); then
        COMPREPLY=( $(compgen -W "$(_och_sessions)" -- "$cur") )
        return
      fi
      case "$prev" in
        --url|--token|--password|--thinking|--message|--timeout-ms|--history-limit)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--url --token --password --deliver --thinking --message --timeout-ms --history-limit -h --help" -- "$cur") )
      ;;
    get-agent-skill)
      if (( cword == 2 )); then
        COMPREPLY=( $(compgen -W "$(_och_skills)" -- "$cur") )
      fi
      ;;
    help|-h|--help)
      ;;
  esac
}

complete -F _och och
