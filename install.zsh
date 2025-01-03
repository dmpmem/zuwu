#!/usr/bin/env zsh
#
# Enhanced Zsh plugin install script for 'zuwu.zsh'.
# Installs the plugin into an appropriate directory and generates a setup script.

set -euo pipefail

################################################################################
# UTILITY: Colors & Logging
################################################################################

# Basic ANSI color codes for more readable output
COLOR_GREEN='\x1b[0;32m'
COLOR_BLUE='\x1b[0;34m'
COLOR_YELLOW='\x1b[0;33m'
COLOR_RESET='\x1b[0m'

info() {
  # Print normal informational messages in green
  echo -e "${COLOR_GREEN}$*${COLOR_RESET}"
}

warn() {
  # Print warnings in yellow
  echo -e "${COLOR_YELLOW}$*${COLOR_RESET}"
}

error() {
  # Print error messages in red & exit
  echo -e "\x1b[0;31mERROR:\x1b[0m $*" >&2
  exit 1
}

################################################################################
# GLOBALS & DEFAULTS
################################################################################

readonly __filename="$(realpath "$0")"
readonly __dirname="$(dirname "$__filename")"

# Decide the target directory.
# If $TARGET is provided, we use that; otherwise we figure out a best guess:
if [[ -n "${TARGET:-}" ]]; then
  INSTALL_DIR="$TARGET"
elif [[ -n "${SYSROOT_PREFIX:-}" ]]; then
  INSTALL_DIR="${SYSROOT_PREFIX}/usr/share/zsh/plugins/zuwu"
elif [[ -n "${PREFIX:-}" ]]; then
  INSTALL_DIR="${PREFIX}/share/zsh/plugins/zuwu"
elif [[ "$(whoami)" == "root" ]]; then
  INSTALL_DIR="/usr/local/share/zsh/plugins/zuwu"
else
  INSTALL_DIR="${HOME}/.local/share/zsh/plugins/zuwu"
fi

################################################################################
# FUNCTIONS
################################################################################

installFile() {
  local src="$1"
  local dst="${INSTALL_DIR}/${1}"

  mkdir -p "$(dirname "${dst}")"

  # If the script was invoked with a base name of 'zsh', we attempt to curl from
  # the repository. Otherwise, we just copy from local.
  # (This logic is inherited from the original script.)
  if [[ "$(basename "$__filename")" == "zsh" ]]; then
    # Attempt to fetch the file from the URL.
    # We'll try the first URL, and if it fails or if it leads to an empty repo,
    # we fallback to the second URL.
    curl -fsSLo "${dst}" "https://git.estrogen.zone/zuwu.git/plain/${src}" \
      && ! grep 'Repository seems to be empty' "${dst}" \
      || curl -fsSLo "${dst}" "https://raw.githubusercontent.com/dmpmem/zuwu/refs/heads/master/${src}"
  else
    # Local copy from the script directory
    cp -r "${__dirname}/${src}" "${dst}"
  fi
}

################################################################################
# MAIN
################################################################################

mkdir -p "${INSTALL_DIR}"

# Install the core plugin file
installFile "zuwu.zsh"

# Generate the setup script inside $INSTALL_DIR/setup.zsh
# This script will rename an existing ~/.zshrc (if present),
# create a new ~/.zshrc that sources the installed plugin,
# and instruct the user to source it.
cat <<'EOF_SETUPSCRIPT' > "${INSTALL_DIR}/setup.zsh"
#!/usr/bin/env zsh
set -euo pipefail

# The logic here renames the existing .zshrc, then creates a new one
# that loads the plugin from the known possible directories.
if [[ -f "$HOME/.zshrc" ]]; then
  local NEWZSHRC="$HOME/.zshrc.$(date -u +%Y-%m-%dT%H:%M:%S%Z)"
  echo -e "\x1b[0;33mExisting .zshrc found, moving it to \x1b[0;34m$NEWZSHRC\x1b[0m"
  mv "$HOME/.zshrc" "$NEWZSHRC"
fi

cat <<EOF_ZSHRC > "$HOME/.zshrc"
for d in /usr/share/zsh/plugins/zuwu /usr/local/share/zsh/plugins/zuwu "\$HOME/.local/share/zsh/plugins/zuwu"; do
  if [[ -d "\$d" ]]; then
    source "\$d/zuwu.zsh"
  fi
done
EOF_ZSHRC

echo -e "\x1b[0;32mA new ~/.zshrc has been created.\x1b[0m"
echo -e "\x1b[0;32mPlease run \x1b[0;34msource \$HOME/.zshrc\x1b[0;32m to load zuwu.\x1b[0m"
EOF_SETUPSCRIPT

chmod +x "${INSTALL_DIR}/setup.zsh"

# Based on whether the script is run for the first time or as an update:
if [[ "${_ZUWU_INSTALLED:-}" != "1" ]]; then
  info "Installation complete. Please run ${COLOR_BLUE}${INSTALL_DIR}/setup.zsh${COLOR_GREEN} to install Zuwu for your user."
else
  info "Update complete. Please run ${COLOR_BLUE}source \$HOME/.zshrc${COLOR_GREEN} to finish updating Zuwu."
fi
