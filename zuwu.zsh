#
# The zuwu microframework primary entrypoint.
# 
# This file is part of zuwu - a general-purpose zsh initialization and utility framework.
#
# Authors:
#   memdmp <https://mem.estrogen.zone/>
#

#
# Copyright (c) 2025 the above listed authors
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

export _ZUWU_INSTALLED=1;

if [[ "$_ZUWU_DEBUG" == "1" ]]; then set -ax; fi

# Completion Handling
eval_append() {
  <<<"$2" >> "$1"
  eval "$2"
}
if ! test compinit >/dev/null 2>/dev/null; then
  eval_append ~/.zshrc "$(<<EOF
# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*' '' '' ''
zstyle ':compinstall' filename "\$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

EOF
)"
fi

# ZSH Env Setup
if ! [[ -f "$HOME/.zshenv" ]]; then
  # we want the user to have a .zshenv file, so we create it
  # right now we dont provide an env.zsh, however this is useful for future use.
  eval_append "$HOME/.zshenv" "$(<<EOF
#
# Defines environment variables, functions and aliases to be available in your shell scripts and your prompt.
# Things that only apply to your prompt should be put into your .zshrc instead!
#
# Authors:
#   memdmp <https://mem.estrogen.zone/>
#

#
# This file was generated by zuwu. You can modify it as you please.
# Changes will only be reverted if the file is removed.
# We recommend, for the sake of readability, removing this generated comment when changing this file for the first time.
#

# Remove the following line if you do not want zuwu's environment.
for d in /usr/share/zsh/plugins/zuwu /usr/local/share/zsh/plugins/zuwu "\${XDG_DATA_HOME:-"\$HOME/.local/share"}/zsh/plugins/zuwu"; do
  if [[ -f "\$d/env.zsh" ]]; then
    source "\$d/env.zsh"
    break
  fi
done

# Put your custom environment variables below this line.
EOF
)";
fi

# -
noop() {}

# Ensure ~/.local/bin is in the PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# Ensure ~/.local/bin exists
if ! [[ -d "$HOME/.local/bin" ]]; then
  mkdir "$HOME/.local/bin" || echo "Failed to create '$HOME/.local/bin' for your sanity's sake. For your own sanity, please make this directory."
fi

# Load some shit that you will need
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# Keybinds and all that jazz
reloadopt() {
  if [[ -f "$HOME/.zshconf" ]]; then
    no-op "${XDG_CONFIG_HOME:="$HOME/.config"}";
    if ! [[ -d "$XDG_CONFIG_HOME" ]]; then
      mkdir "$XDG_CONFIG_HOME"
    fi
    mv "$HOME/.zshconf" "$XDG_CONFIG_HOME}/zuwu.conf"
  fi
  if [[ -f "$XDG_CONFIG_HOME.conf" ]]; then
    source "$XDG_CONFIG_HOME.conf"
  fi
  
  __bindkey() {
    if [[ "$1" != "" ]]; then
      bindkey "$1" "$2"
    fi
  }

  noop "${WILL_SHARE_HISTORY:=true}"
  noop "${KEYBIND_FORWARD_WORD:="^[[1;5C"}"
  noop "${KEYBIND_BACKWARD_WORD:="^[[1;5D"}"
  noop "${DO_AUTOCD:=true}"
  noop "${DO_ERR_BEEP:=false}"
  noop "${DO_EXTENDED_BLOB:=true}"
  noop "${LINE_OR_BEGIN_SEARCH_KEY:=true}"
  noop "${DELETE_CHAR:=true}"
  noop "${INSEND_MOVE_KEY:=true}"
  noop "${BINDKEY_KIND:=e}"
  noop "${USE_COLOURED_LS_GREP:=true}"

  __opt() {
    if "$1"; then
      setopt "$2"
    else
      unsetopt "$2"
    fi
  }

  if [[ "$BINDKEY_KIND" == "e" ]] || [[ "$BINDKEY_KIND" == "v" ]]; then
    bindkey -"$BINDKEY_KIND"
  fi
  
  __opt "$WILL_SHARE_HISTORY" SHARE_HISTORY
  __bindkey "$KEYBIND_FORWARD_WORD" forward-word
  __bindkey "$KEYBIND_BACKWARD_WORD" backward-word
  __opt "$DO_AUTOCD" autocd
  __opt "$DO_ERR_BEEP" beep
  __opt "$DO_EXTENDED_BLOB" extendedglob
  if "$USE_COLOURED_LS_GREP"; then
    if [[ "$(which ls 2>&1)" != *color=* ]]; then
      alias ls="ls --color=auto";
    fi
    if [[ "$(which grep 2>&1)" != *color=* ]]; then
      alias grep="grep --color=auto"
    fi
  fi
  if "$LINE_OR_BEGIN_SEARCH_KEY"; then
    _bkey() {
      zle -N "$1"
      bindkey "$2" "$1"
    }
    _bkey "up-line-or-beginning-search" "^[[A" # Up
    _bkey "down-line-or-beginning-search" "^[[B" # Down
  else
    bindkey -r "^[[A"
    bindkey -r "^[[B"
  fi
  if "$DELETE_CHAR"; then
    bindkey "^[[3~" delete-char
    bindkey "^[[3;2~" delete-word
  else
    bindkey -r "^[[3~"
    bindkey -r "^[[3;2~"
  fi
  if "$INSEND_MOVE_KEY"; then
    bindkey "^[[H" beginning-of-line
    bindkey "^[[F" end-of-line
  else
    bindkey -r "^[[H"
    bindkey -r "^[[F"
  fi
}
reloadopt

# Fix $HOME path being entirely inlined in zsh completion shit (or any other string at the beginnig thereof)
if grep "\"$HOME" "$HOME/.zshrc" >/dev/null 2>/dev/null; then
  sed -i "s|\"$HOME|\"\$HOME|g" "$HOME/.zshrc"
  zstyle :compinstall filename "$HOME/.zshrc"
fi

# Load zgen, if present
if [[ -f "$HOME/.zgen/zgen.zsh" ]]; then
  source "$HOME/.zgen/zgen.zsh"
  LOADED_ZGEN=true
fi

# Utilities
_each_share_dir() {
  for sdir in /usr/share /usr/local/share "$HOME/.local/share"; do
    for arg in "$@"; do
      echo "$sdir/$arg"
    done
  done
}

# Plugins
# > ZSH Autosuggestions
while IFS= read -r f; do
  if [[ -f "$f" ]]; then
    source "$f"
    break
  fi
done <<< "$(_each_share_dir zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh zsh-autosuggestions/zsh-autosuggestions.zsh)"
# > ZSH Syntax Highlighting
while IFS= read -r f; do
  if [[ -f "$f" ]]; then
    source "$f"
    break
  fi
done <<< "$(_each_share_dir zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh)"

# Cute Prompting
if [[ "$_ZUWU_NO_STARSHIP-$_ZUWU_NO_PROMPT" == "-" ]] && [[ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/starship.toml" ]] && type "starship" >/dev/null; then
  eval "$(starship init zsh)"
elif [[ "$_ZUWU_HYPERFAST-$_ZUWU_NO_PROMPT" == "-" ]]; then
  # unsure of source of function
  hsv2rgb() {
    local h=$1
    local s=$2
    local v=$3
    local s_float=$(echo "$s / 100" | bc -l)
    local v_float=$(echo "$v / 100" | bc -l)
    local r g b
    local i
    local f p q t
    i="$((h / 60))"
    f="$(echo "$h / 60 - $i" | bc -l)"
    p="$(echo "$v_float * (1 - $s_float)" | bc -l)"
    q="$(echo "$v_float * (1 - $f * $s_float)" | bc -l)"
    t="$(echo "$v_float * (1 - (1 - $f) * $s_float)" | bc -l)"
    case $i in
      0) r=$v_float; g=$t; b=$p ;;
      1) r=$q; g=$v_float; b=$p ;;
      2) r=$p; g=$v_float; b=$t ;;
      3) r=$p; g=$q; b=$v_float ;;
      4) r=$t; g=$p; b=$v_float ;;
      5) r=$v_float; g=$p; b=$q ;;
    esac
    r="$(printf "%.0f" $(echo "$r * 255" | bc -l))"
    g="$(printf "%.0f" $(echo "$g * 255" | bc -l))"
    b="$(printf "%.0f" $(echo "$b * 255" | bc -l))"
    echo -n "${r};${g};${b}"
  }
  local _SHORTHOST_HASH="$(sha256sum <<< "${HOST%%.*}")"
  local _SYS_RGB="${SYS_RGB:-"$(hsv2rgb "${SYS_HSV_HUE:-"$((0x${_SHORTHOST_HASH:0:2} * 360 / 256))"}" "${SYS_HSV_SATURATION:-60}" "${SYS_HSV_VALUE:-70}")"}"
  local _USER_RGB="${USER_RGB:-"$_SYS_RGB"}"
  unset -f hsv2rgb

  _SYS_USER_COLOUR="%F{22}$(echo -ne "\x1b[38;2;${_USER_RGB}m")"
  _SYS_SYSTEM_COLOUR="%B%F{green}$(echo -ne "\x1b[38;2;${_SYS_RGB}m")"
  if [[ "$USER" == "root" ]]; then
    _SYS_USER_COLOUR="%F{red}"
  fi

  PROMPT="$(echo -n "${_SYS_USER_COLOUR}%n%f%F{7}@%f${_SYS_SYSTEM_COLOUR}%m%f%b%F{7} in %f%B%F{27}%~%f%b\n%B%F{magenta}%(?..%F{red})❯ %f%b")"
  RPROMPT="%B%F{magenta}%(?..%F{red})%?%f%b"
elif [[ "$_ZUWU_NO_PROMPT" == "" ]]; then
  _SYS_USER_COLOUR="%F{22}"
  _SYS_SYSTEM_COLOUR="%B%F{green}"
  if [[ "$USER" == "root" ]]; then
    _SYS_USER_COLOUR="%F{red}"
  fi

  PROMPT="$(echo -n "${_SYS_USER_COLOUR}%n%f%F{7}@%f${_SYS_SYSTEM_COLOUR}%m%f%b%F{7} in %f%B%F{27}%~%f%b\n%B%F{magenta}%(?..%F{red})❯ %f%b")"
  RPROMPT="%B%F{magenta}%(?..%F{red})%?%f%b"
fi

# Custom History Handling
__sethist() {
  HISTDIR="${HISTDIR:-"$HOME/.zsh_history"}"
  HISTID="${HISTID:-"default"}"
  if [[ -f "$HISTDIR" ]]; then
    mv "$HISTDIR" /tmp/history
    mkdir "$HISTDIR"
    mv /tmp/history "$HISTDIR/$HISTID"
  fi
  HISTFILE="$HISTDIR/$HISTID"
  if [[ "$HISTFILE" == "$HISTDIR/" ]]; then
    HISTID="default"
    HISTFILE="$HISTDIR/default"
  fi;
}

__sethist

# History Size Determination
if ! [ -n "${HISTSIZE+1}" ]; then
  eval_append ~/.zshrc "$(<<EOF
# Lines configured by zsh-newuser-install
HISTFILE="~/.histfile"
HISTSIZE="10000"
SAVEHIST="10000"
# End of lines configured by zsh-newuser-install

# Overwrite histfile with zuwu implementation, using HISTDIR and HISTID - if you don't want this implementation, comment out the next line.
typeset -f __sethist >/dev/null 2>/dev/null && __sethist || true
EOF
)"
fi

# For some reason, 30 tends to be a common "default" setting for this when not manually specified on shitty systems
if [[ "$HISTSIZE" == "30" ]]; then
  HISTSIZE="10000"
fi
if [[ "$SAVEHIST" == "30" ]]; then
  SAVEHIST="10000"
fi

if [[ "$_ZUWU_DEBUG" == "1" ]]; then set +ax; fi
