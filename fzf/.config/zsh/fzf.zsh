# fzf shell integration
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS=" \
  --reverse \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi \
  --tmux 80%"

alias f="fzf --preview 'bat --plain --color=always --tabs=2 {}'"

[[ $PATH =~ "$HOME/.fzf" ]] || PATH="$HOME/.fzf:$PATH"

rf() (
  RELOAD='reload:rg --hidden --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
      nvim {1} +{2}
    else
      nvim +cw -q {+f}
    fi'
  fzf \
    --disabled \
    --ansi \
    --bind "start:$RELOAD" \
    --bind "change:$RELOAD" \
    --bind "enter:become:$OPENER" \
    --bind "ctrl-o:execute:$OPENER" \
    --delimiter : \
    --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
    --preview-window '~4,+{2}+4/3,<80(up)' \
    --query "$*"
)

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
    nvim) fzf "$@" \
      --walker file,follow,hidden
      --prompt 'nvim > ' \
      --preview 'if [ -d {} ]; \
        then eza --tree --all --icons --color=always {}; \
        elif [ -f {} ]; \
        then bat --plain --color=always --tabs=2 {}; \
        else echo "Preview not available."; \
        fi' ;;
    *) fzf "$@" ;;
  esac
}

_fzf_complete_pnpm() {
  _fzf_complete --delimiter '\s\s+' --accept-nth=1 -- "$@" < <(
    jq -r ".scripts | to_entries[] | [.key, .value] | @tsv" ./package.json | column -t -s $'\t' 
  )
}
