#
# Defines environment variables to be available in shell scripts and the user's prompt.
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

# Currently, we just ensure your environment is sensible - e.g. we ensure your LANG is well-defined, etc...

# Validate $LANG is set correctly
if [[ "$VALIDATE_LANG" != "false" ]]; then
  if [[ "$LANG" == "" ]] || [[ "$LANG" == "C" ]]; then
    # Modern systems will have UTF-8 everywhere outside of a TTY.
    # Login Shells are the only shell likely to be a TTY (although theoretically other shells could also be login shells, but like idc if 1% of thigns break).
    if [[ "$-" != *l* ]]; then
      export LANG="C.UTF-8"
    else
      export LANG="C"
    fi
  fi
  if [[ "$LC_ALL" == "" ]] || [[ "$LC_ALL" == "C" ]]; then
    export LC_ALL="$LANG"
  fi
fi

# Ensure ~/.local/bin is in the PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$PATH:$HOME/.local/bin"
fi
