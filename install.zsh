#!/usr/bin/env zsh
set -e
__filename="$(realpath "$0")"
__dirname="$(dirname "$__filename")"

if [[ "$TARGET" != "" ]]; then
  # no-op
elif [[ "$SYSROOT_PREFIX" != "" ]]; then
  TARGET="$SYSROOT_PREFIX/usr/share/zsh/plugins/zuwu"
elif [[ "$PREFIX" != "" ]]; then
  TARGET="$PREFIX/share/zsh/plugins/zuwu"
elif [[ "$(whoami)" == "root" ]]; then
  TARGET="/usr/local/share/zsh/plugins/zuwu"
else
  TARGET="$HOME/.local/share/zsh/plugins/zuwu"
fi
mkdir -p "$TARGET"

if [[ "$(basename "$__filename")" == "zsh" ]]; then
  curl -fsSLo "$TARGET/zuwu.zsh" https://git.estrogen.zone/zuwu.git/plain/zuwu.zsh
else
  cp -r "$__dirname/zuwu.zsh" "$TARGET/zuwu.zsh"
fi
<<EOF2 > "$TARGET/setup.zsh"
#!/usr/bin/env zsh
if [[ -f "\$HOME/.zshrc" ]]; then
  local NEWZSHRC="\$HOME/.zshrc.\$(date -u +%Y-%m-%dT%H:%M:%S%Z)"
  echo -e "\x1b[0;33mExitsing zshrc found, moving to \x1b[0;34m\$NEWZSHRC\x1b[0m"
  mv "\$HOME/.zshrc" "\$NEWZSHRC"
fi
<<EOF > "\$HOME/.zshrc"
for d in /usr/share/zsh/plugins/zuwu /usr/local/share/zsh/plugins/zuwu \\\$HOME/.local/share/zsh/plugins/zuwu; do
  if [[ -d "\\\$d" ]]; then
    source "\\\$d/zuwu.zsh"
  fi
done
EOF
echo -e "\x1b[0;32mPlease run \x1b[0;34msource \$HOME/.zshrc\x1b[0;32m to finish installing zuwu.\x1b[0m"
EOF2
chmod +x "$TARGET/setup.zsh"
if [[ "$_ZUWU_INSTALLED" != "1" ]]; then
  echo -e "\x1b[0;32mPlease run \x1b[0;34m$TARGET/setup.zsh\x1b[0;32m to install zuwu for the current user.\x1b[0m"
else
  echo -e "\x1b[0;32mPlease run \x1b[0;34msource $HOME/.zshrc\x1b[0;32m to finish updating zuwu.\x1b[0m"
fi
