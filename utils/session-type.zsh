#
# A function for detecting information about the current session, entirely using shell builtins and env variables.
# 
# This file is part of the zuwu project - a general-purpose zsh initialization and utility framework.
# It is not used by zuwu at the moment, but rather is provided to shell script developers as a utility function they can integrate into their own codebases
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

function {
  local session_extensions=()
  local session_base="local"

  # Detect Interactivity & Login State
  local is_interactive=false;
  local is_login=false;
  if [[ $- == *i* ]]; then
    is_interactive=true
  fi
  if [[ $- == *l* ]]; then
    is_login=true
  fi
  if [[ "$is_interactive" && "$is_login" ]]; then
    session_extensions+=(
      interactive
      login
    )
  elif [[ "$is_interactive" ]]; then
    session_extensions+=(interactive)
  elif [[ "$is_login" ]]; then
    session_extensions+=(login)
  else
    session_extensions+=(headless)
  fi

  # Detect if local or remote, and the kind
  if [ -n "$SSH_TTY" ]; then
    session_base=remote
    session_extensions+=(
      ssh
      ssh_tty
    )
  elif [ -n "$SSH_CLIENT" ]; then
    session_base=remote
    session_extensions+=(
      ssh
    )
  else
    # Expensive ssh session detection - spawns a `ps` process. You may want this if you need reliable session type detection
    # case $(ps -o comm= -p "$PPID") in
    #   sshd|*/sshd) session_base=remote; session_extensions+=(ssh);;
    # esac
  fi

  # Join together into a final, content-type-alike variable
  SESSION_TYPE="$session_base/${(j.+.)session_extensions}"
}

# Example use:
# [[ "$SESSION_TYPE+" == *(+|/)interactive+* ]] && echo "Is in interactive session"
