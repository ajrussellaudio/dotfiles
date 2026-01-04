function this_or_that() {
  local this=$1
  shift
  local that=$1
  shift
  (( $+commands[$this] )) && $this "$@" || $that "$@"
}

alias -s json='this_or_that jless bat'
alias -s md='this_or_that glow bat'
alias -s txt=bat
alias -s log=bat
alias -s js='$EDITOR'
alias -s jsx='$EDITOR'
alias -s cjs='$EDITOR'
alias -s mjs='$EDITOR'
alias -s ts='$EDITOR'
alias -s tsx='$EDITOR'
alias -s mts='$EDITOR'
alias -s html='this_or_that xdg-open open'
