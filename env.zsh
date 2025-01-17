#
# Defines environment variables to be available in shell scripts and the user's prompt.
# 
# This file is part of zuwu - a general-purpose zsh initialization and utility framework.
#
# Authors:
#   memdmp <https://mem.estrogen.zone/>
#

# Currently, we just ensure your environment is sensible - e.g. we ensure your LANG is well-defined, etc...
if [[ "$VALIDATE_LANG" != "false" ]]; then
  if [[ "$LANG" == "" ]] || [[ "$LANG" == "C" ]]; then
    # Modern systems will have UTF-8 everywhere outside of a TTY.
    # Login Shells are the only shell likely to be a TTY (although theoretically other shells could also be login shells, but like idc if 1% of thigns break).
    if [[ "$-" == *l* ]]; then
      export LANG="C.UTF-8"
    else
      export LANG="C"
    fi
  fi
  if [[ "$LC_ALL" == "" ]] || [[ "$LC_ALL" == "C" ]]; then
    export LC_ALL="$LANG"
  fi
fi
