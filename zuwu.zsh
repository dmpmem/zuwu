# zuwu: cute lil zsh microframework thingy
# ~ memdmp

export _ZUWU_INSTALLED=1;

if [[ "$_ZUWU_DEBUG" == "1" ]]; then set -ax; fi

# Completion Handling
if ! grep '# The following lines were added by compinstall' ~/.zshrc >/dev/null 2>/dev/null && ! grep 'compinit' ~/.zshrc >/dev/null 2>/dev/null; then
  <<EOF >> ~/.zshrc
# Note: Do not remove the 'The following lines were...' comment!
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
fi
# History Size Determination
if ! grep 'HISTSIZE' ~/.zshrc >/dev/null 2>/dev/null; then
  <<EOF >>~/.zshrc
# Lines configured by zsh-newuser-install
HISTFILE="~/.histfile"
HISTSIZE="10000"
SAVEHIST="10000"
# End of lines configured by zsh-newuser-install

# Overwrite histfile with zuwu implementation, using HISTDIR and HISTID - if you don't want this implementation, comment out the next line.
__sethist
EOF
fi

# -
noop() {}

# Ensure ~/.local/bin is in the PATH - note that this will "match" if something like `.*$HOME/.local/bin.*`, i don't care
if ! grep "$HOME/.local/bin" <<< "$PATH" >/dev/null 2>/dev/null; then
  echo -n 'if ! grep "$HOME/.local/bin" <<< "$PATH" >/dev/null 2>/dev/null; then
  export PATH="$PATH:$HOME/.local/bin"
fi
' >> "$HOME/.zshenv"
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
    if ! [[ -d "$HOME/.config" ]]; then
      mkdir "$HOME/.config"
    fi
    mv "$HOME/.zshconf" "$HOME/.config/zuwu.conf"
  fi
  if [[ -f "$HOME/.config/zuwu.conf" ]]; then
    source "$HOME/.config/zuwu.conf"
  fi
  
  __bindkey() {
    if [[ "$1" != "" ]]; then
      bindkey "$1" "$2"
    fi
  }

  noop "${WILL_SHARE_HISTORY:=false}"
  noop "${KEYBIND_FORWARD_WORD:="^[[1;5C"}"
  noop "${KEYBIND_BACKWARD_WORD:="^[[1;5D"}"
  noop "${DO_AUTOCD:=true}"
  noop "${DO_ERR_BEEP:=false}"
  noop "${DO_EXTENDED_BLOB:=true}"
  noop "${LINE_OR_BEGIN_SEARCH_KEY:=true}"
  noop "${DELETE_CHAR:=true}"
  noop "${INSEND_MOVE_KEY:=true}"
  noop "${BINDKEY_KIND:=e}"

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
if [[ -d "$HOME/.zgen" ]]; then
  source "$HOME/.zgen/zgen.zsh"
  ZGEN=true
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
if [[ -f ~/.config/starship.toml ]]; then
  eval "$(starship init zsh)"
else
  _SYS_USER_COLOUR="%F{22}"
  _SYS_SYSTEM_COLOUR="%B%F{green}"
  if [[ "$(whoami)" == "root" ]]; then
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

# For some reason, 30 tends to be a common "default" setting for this when not manually specified on shitty systems
if [[ "$HISTSIZE" == "30" ]]; then
  HISTSIZE="10000"
fi
if [[ "$SAVEHIST" == "30" ]]; then
  SAVEHIST="10000"
fi

if [[ "$_ZUWU_DEBUG" == "1" ]]; then set +ax; fi
