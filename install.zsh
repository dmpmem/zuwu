#!/usr/bin/env zsh

#
# Installs the zuwu microframework onto the user's device.
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

set -e

if [[ "$ZSH_NAME" == "" ]]; then
  echo -e "\x1b[0;31mThe installer expects ZSH to be the executing shell, lmao.\x1b[0m"
  exit 1
fi

__filename="$(realpath "$0")"
__dirname="$(dirname "$__filename")"

if [[ "$TARGET" != "" ]]; then
  true; # no-op
elif [[ "$SYSROOT_PREFIX" != "" ]]; then
  TARGET="$SYSROOT_PREFIX/usr/share/zsh/plugins/zuwu"
elif [[ "$PREFIX" != "" ]]; then
  TARGET="$PREFIX/share/zsh/plugins/zuwu"
elif [[ "$(whoami)" == "root" ]]; then
  TARGET="/usr/local/share/zsh/plugins/zuwu"
else
  TARGET="${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/plugins/zuwu"
fi
mkdir -p "$TARGET"

installFile() {
  mkdir -p "$(dirname "$TARGET/$1")"
  if [[ "$(basename "$__filename")" == "zsh" ]]; then
    (curl -fsSLo "$TARGET/$1" "https://git.estrogen.zone/zuwu.git/plain/$1?h=${REF:-master}" && ! grep 'Repository seems to be empty' "$TARGET/$1") || curl -fsSLo "$TARGET/$1" "https://raw.githubusercontent.com/dmpmem/zuwu/${REF:-"master"}/$1"
  else
    cp -r "$__dirname/$1" "$TARGET/$1"
  fi
}
installFile COPYING
installFile zuwu.zsh
installFile env.zsh

<<EOF_SETUPSCRIPT > "$TARGET/setup.zsh"
#!/usr/bin/env zsh
set -e
if [[ -f "\$HOME/.zshrc" ]]; then
  local NEWZSHRC="\$HOME/.zshrc.\$(date -u +%Y-%m-%dT%H:%M:%S%Z)"
  echo -e "\x1b[0;33mExitsing zshrc found, moving to \x1b[0;34m\$NEWZSHRC\x1b[0m"
  mv "\$HOME/.zshrc" "\$NEWZSHRC"
fi
<<EOF_ZSHRC > "\$HOME/.zshrc"
# Loading Order Priority:
# - distribution packaging target
# - local system-wide installation target
# - local per-user installation target
for d in /usr/share/zsh/plugins/zuwu /usr/local/share/zsh/plugins/zuwu "\\\${XDG_DATA_HOME:-"\\\$HOME/.local/share"}/zsh/plugins/zuwu"; do
  if [[ -d "\\\$d" ]]; then
    source "\\\$d/zuwu.zsh"
    # For debugging, calling _ZUWU_DETECTED_INSTALL_PATH=/dev/null zsh -c 'source ~/.zshrc && echo "\\\$_ZUWU_DETECTED_INSTALL_PATH"' may be useful
    if [[ "\\\$_ZUWU_DETECTED_INSTALL_PATH" != "" ]]; then
      _ZUWU_DETECTED_INSTALL_PATH="\\\$d"
    fi
    break
  fi
done
EOF_ZSHRC
echo -e "\x1b[0;32mPlease run \x1b[0;34msource \$HOME/.zshrc\x1b[0;32m to load zuwu into the current shell.\x1b[0m"
EOF_SETUPSCRIPT
chmod +x "$TARGET/setup.zsh"
if [[ "$_ZUWU_INSTALLED" != "1" ]] || ! [[ -f "$HOME/.zshrc" ]]; then
  echo -e "\x1b[0;32mPlease run \x1b[0;34m$TARGET/setup.zsh\x1b[0;32m to install zuwu for the current user.\x1b[0m"
else
  echo -e "\x1b[0;32mPlease run \x1b[0;34msource $HOME/.zshrc\x1b[0;32m to finish updating zuwu.\x1b[0m"
fi
