#compdef claude
# Zsh completions for the Claude Code CLI, derived from `claude --help`.
#
# Why generated instead of hand-written: the Claude Code CLI ships several
# versions a week and its flag surface moves with them. A static completion
# file starts drifting immediately -- offering removed flags, missing new
# ones, and completing stale model IDs. `claude --help` is always exactly in
# sync with the installed binary, so we parse it instead of guessing.
#
# `claude --help` costs ~0.5s, far too slow to run per keystroke, so results
# are cached under $XDG_CACHE_HOME/claude-completion/<fingerprint>/. The
# fingerprint is derived from the binary (resolved path + size + mtime) and
# from this file's own mtime, which means:
#   - upgrading claude invalidates the cache automatically
#   - editing this file invalidates the cache automatically
#   - `touch` on this file forces a rebuild
# Help is parsed lazily per command path, so `claude mcp add <Tab>` only ever
# shells out for `claude mcp add --help`, never the whole command tree.

# Captured at source time: ${(%):-%x} is the file currently being sourced.
_CLAUDE_COMPLETION_SRC=${(%):-%x}

zmodload -F zsh/stat b:zstat 2>/dev/null

# --- Cache addressing ---------------------------------------------------------

# Cheap, subprocess-free identity for "the thing we generated completions from".
_claude_fingerprint() {
  local bin=${commands[claude]}
  [[ -n $bin ]] || return 1
  bin=${bin:A}  # resolve symlinks; mise paths embed the version

  local -A st
  local parts=${bin//\//_}
  if zstat -H st -- $bin 2>/dev/null; then
    parts+="-${st[size]}-${st[mtime]}"
  fi
  if zstat -H st -- $_CLAUDE_COMPLETION_SRC 2>/dev/null; then
    parts+="-${st[mtime]}"
  fi

  print -r -- ${parts: -180}  # keep the filename within sane limits
}

_claude_cache_file() {
  local fp=$1; shift
  local slug=${(j:-:)@}
  [[ -n $slug ]] || slug=_root
  slug=${slug//[^a-zA-Z0-9_-]/_}
  print -r -- "${XDG_CACHE_HOME:-$HOME/.cache}/claude-completion/${fp}/${slug}.zsh"
}

# --- Help text sanitising -----------------------------------------------------

# Descriptions arrive as free prose containing characters that are structural
# in an _arguments spec ( [ ] : \ ' ). Strip rather than escape: these are
# menu labels, so losing punctuation costs nothing and removes a whole class
# of quoting bugs from the generated file.
_claude_sanitize() {
  setopt localoptions extendedglob
  local s=$1
  s=${s//[\[\]\\\':]/}
  s=${s//$'\t'/ }
  while [[ $s == *'  '* ]]; do s=${s//  / }; done
  s=${s##[[:space:]]##}
  s=${s%%[[:space:]]##}
  (( ${#s} > 70 )) && s="${s[1,67]}..."
  print -r -- $s
}

# --- Value completion policy --------------------------------------------------

# Decide how zsh should complete the VALUE of an option.
#
#   $1 = primary option name, e.g. --model, --add-dir, --permission-mode
#   $2 = metavar as written in --help, e.g. "agent", "auto|tokens",
#        "directories..." (the trailing ... marks a repeatable option)
#   $3 = the option's full, unsanitised description from --help
#
# Print a zsh completion action -- the part after the final colon of an
# _arguments spec, such as '(a b c)' or '_files -/'. Print nothing to accept
# any value with no suggestions.
#
# Called at generation time, so the result is baked into the cache.
_claude_value_spec() {
  setopt localoptions extendedglob
  local name=$1 metavar=$2 desc=$3
  local base=${metavar%%...}

  # Unambiguous: help spelled the alternatives out as <a|b|c>.
  if [[ $base == *'|'* ]]; then
    print -r -- "(${base//\|/ })"
    return
  fi

  # Unambiguous: the metavar names a filesystem path.
  case $base in
    dir|dirs|directory|directories) print -r -- '_files -/'; return ;;
    file|files|path|paths)          print -r -- '_files';    return ;;
  esac

  # TODO(alan): the two judgement calls this generator deliberately leaves open.
  #
  # 1. Prose enums. Many options list their values only in the description:
  #      -s, --scope <scope>          Configuration scope (local, user, or project)
  #      -t, --transport <transport>  Transport type (stdio, sse, http). ...
  #      --permission-mode <mode>     ... (acceptEdits, bypassPermissions, ...)
  #    A regex over "(...)" would pick these up -- and would also pick up
  #    "(e.g. -e KEY=value)" and "(default: local)" as if they were values.
  #    Trade-off: a wrong suggestion is worse than none, because zsh will
  #    happily complete a flag value that the CLI then rejects. Decide how
  #    much prose you trust -- e.g. only accept a parenthesised list when
  #    every item is a bare word, there are 2+ items, and it contains no
  #    "e.g."/"default"/"=" -- or skip prose entirely.
  #
  # 2. Overrides for things help can't express. `--model <model>` just says
  #    "Model for the current session"; the useful completions are the
  #    aliases (opus, sonnet, haiku). Hardcoding IDs reintroduces exactly the
  #    staleness this generator avoids, so prefer aliases, or shell out to
  #    something authoritative.
  #
  # Return nothing for now: any value accepted, no suggestions offered.
  return 0
}

# --- Help parsing -------------------------------------------------------------

# Parse `claude <path> --help` and write an _arguments-ready spec file.
_claude_generate() {
  setopt localoptions extendedglob
  local out=$1; shift
  local -a cmdpath=("$@")

  local raw
  raw=$(command claude "${cmdpath[@]}" --help 2>/dev/null) || return 1
  [[ -n $raw ]] || return 1

  # Pass 1: unwrap. Entries start at exactly two spaces of indent; their
  # descriptions wrap onto more deeply indented lines (6 spaces when the spec
  # is long enough to displace the description, ~40 otherwise). Collapse each
  # entry to one "section spec desc" record so pass 2 has no line state.
  local -a records
  local section="" cur_spec="" cur_desc="" line body head

  _claude_push() {
    [[ -n $cur_spec ]] || return 0
    records+=("${section}"$'\t'"${cur_spec}"$'\t'"${cur_desc}")
    cur_spec="" cur_desc=""
  }

  for line in "${(@f)raw}"; do
    case $line in
      Options:*)   _claude_push; section=options;  continue ;;
      Commands:*)  _claude_push; section=commands; continue ;;
      Arguments:*) _claude_push; section=args;     continue ;;
      # Usage/Examples/prose: everything until the next header is noise.
      Usage:*|Examples:*|Description:*) _claude_push; section=""; continue ;;
    esac
    [[ -n $section ]] || continue

    # Some descriptions embed their own indented block -- `claude mcp --help`
    # puts an "Examples:" section inside the Commands list, at the same
    # 2-space indent real entries use. End the current entry but keep the
    # section: switching to "" here would discard every command that follows.
    # Leaving cur_spec empty also makes the block's body fall through the
    # continuation branch below, which is guarded on having a current entry.
    if [[ ${line##[[:space:]]##} == [A-Z][a-zA-Z]##: ]]; then
      _claude_push
      continue
    fi

    if [[ $line == '  '[^[:space:]]* ]]; then
      _claude_push
      body=${line#  }
      # The spec never contains two consecutive spaces, so the first run of
      # 2+ spaces is the column gutter between spec and description.
      head=${body%%  *}
      cur_spec=$head
      if [[ $head != $body ]]; then
        cur_desc=${${body#$head}##[[:space:]]##}
      fi
    elif [[ $line == '   '* && -n $cur_spec ]]; then
      cur_desc="${cur_desc:+$cur_desc }${${line##[[:space:]]##}%%[[:space:]]##}"
    else
      _claude_push
    fi
  done
  _claude_push
  unfunction _claude_push

  # Pass 2: emit specs.
  local -a opt_specs cmd_specs
  local rec desc metavar flags tok prefix excl valpart action mv c
  local -a names

  for rec in "${records[@]}"; do
    local -a f=("${(@s:	:)rec}")
    section=$f[1]; cur_spec=$f[2]; cur_desc=$f[3]
    desc=$(_claude_sanitize "$cur_desc")

    case $section in
      options)
        names=() metavar="" prefix="" excl="" valpart=""

        # Value placeholders appear as <metavar>; a trailing ... means the
        # option may be repeated / takes multiple values.
        [[ $cur_spec == *'<'*'>'* ]] && metavar=${${cur_spec#*<}%%>*}

        # Flag names precede any <...> or [...] placeholder, comma separated.
        flags=${cur_spec%%[<\[]*}
        for tok in ${(s:,:)flags}; do
          tok=${${tok##[[:space:]]##}%%[[:space:]]##}
          [[ $tok == -* ]] && names+=($tok)
        done
        (( ${#names} )) || continue

        if [[ -n $metavar ]]; then
          action=$(_claude_value_spec "${names[-1]}" "$metavar" "$cur_desc")
          mv=${metavar%%...}
          mv=${mv//[^a-zA-Z0-9_-]/ }
          mv=${${mv##[[:space:]]##}%%[[:space:]]##}
          valpart=":${mv:-value}:${action}"
        fi

        # A repeatable option must not exclude itself, so it gets the '*'
        # prefix and no exclusion list. Aliases of a single-use option
        # exclude each other. Each name is emitted as its own spec rather
        # than using brace expansion, which keeps every generated line a
        # plain single-quoted string.
        if [[ $metavar == *'...' ]]; then
          prefix='*'
        elif (( ${#names} > 1 )); then
          excl="(${(j: :)names})"
        fi

        for tok in $names; do
          opt_specs+=("${excl}${prefix}${tok}[${desc}]${valpart}")
        done
        ;;

      commands)
        head=${cur_spec%%[[:space:]]*}
        # `plugin|plugins` declares a command and its alias. Validate the
        # name rather than trusting the layout, so a future help-format
        # surprise degrades into a missing entry instead of a bogus one.
        for c in ${(s:|:)head}; do
          [[ $c == [a-zA-Z0-9][a-zA-Z0-9_.-]# ]] && cmd_specs+=("${c}:${desc}")
        done
        ;;
    esac
  done

  mkdir -p ${out:h} 2>/dev/null || return 1
  {
    print -r -- "# generated from \`claude ${cmdpath[*]} --help\` -- do not edit"
    print -r -- "_claude_opts=("
    for tok in "${opt_specs[@]}"; do print -r -- "  '${tok}'"; done
    print -r -- ")"
    print -r -- "_claude_cmds=("
    for tok in "${cmd_specs[@]}"; do print -r -- "  '${tok}'"; done
    print -r -- ")"
  } >| $out || return 1

  # Drop caches generated from other versions of claude / of this file.
  local sibling
  for sibling in ${out:h:h}/*(N/); do
    [[ $sibling == ${out:h} ]] || rm -rf -- $sibling
  done

  return 0
}

# Populate _claude_opts / _claude_cmds for a command path, generating on miss.
_claude_load() {
  typeset -ga _claude_opts=() _claude_cmds=()

  local fp
  fp=$(_claude_fingerprint) || return 1

  local cache
  cache=$(_claude_cache_file "$fp" "$@")
  if [[ ! -s $cache ]]; then
    _claude_generate "$cache" "$@" || return 1
  fi

  source $cache 2>/dev/null || return 1
  return 0
}

# --- Completion entry point ---------------------------------------------------

_claude_level() {
  local -a cmdpath=("$@")
  _claude_load "${cmdpath[@]}" || { _default; return }

  local -a specs=("${_claude_opts[@]}") cmds=("${_claude_cmds[@]}")
  local state

  if (( ${#cmds} )); then
    specs+=('1: :->claude_cmd' '*:: :->claude_rest')
  else
    specs+=('*:argument:_default')
  fi

  _arguments -s -C $specs

  case $state in
    claude_cmd)
      _describe -t commands 'claude command' cmds
      ;;
    claude_rest)
      # _arguments has shifted words/CURRENT past the subcommand, so
      # $words[1] is the command we just consumed.
      _claude_level "${cmdpath[@]}" "$words[1]"
      ;;
  esac
}

_claude() {
  local curcontext="$curcontext"
  _claude_level
}

if [[ "${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _claude "$@"
else
  compdef _claude claude
fi
