# fzf shell integration
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--layout=reverse \
--multi \
--tmux 50%"

alias f="fzf --preview 'bat --plain --color=always --tabs=2 {}'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf "$@" --walker dir,follow,hidden --preview 'eza --tree --all --color=always {}' ;;
    rm) fzf "$@" --walker file,dir,follow,hidden --preview 'if [ -d {} ]; \
        then eza --tree --all --icons --color=always {}; \
        elif [ -f {} ]; \
        then bat --plain --color=always --tabs=2 {}; \
        else echo "Preview not available."; \
        fi' ;;
    nvim) fzf "$@" --walker file,follow,hidden --preview 'if [ -d {} ]; \
        then eza --tree --all --icons --color=always {}; \
        elif [ -f {} ]; \
        then bat --plain --color=always --tabs=2 {}; \
        else echo "Preview not available."; \
        fi' ;;
    *) fzf "$@" ;;
  esac
}

_fzf_complete_pnpm() {
  _fzf_complete -- "$@" < <(
    jq -r ".scripts | to_entries[] | [.key, .value] | @tsv" ./package.json \
    | column -t -s $'\t' \
  )
}

_fzf_complete_pnpm_post() {
  awk '{print $1}'
}
