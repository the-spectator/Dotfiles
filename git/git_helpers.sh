#!/bin/zsh

# Helper extracted from oh-my-zsh
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Convert the parameters or STDIN to lowercase.
lc () {
	if [ $# -eq 0 ]; then
		tr '[:upper:]' '[:lower:]';
	else
		tr '[:upper:]' '[:lower:]' <<< "$@";
	fi;
}
# Convert the parameters or STDIN to uppercase.
uc () {
	if [ $# -eq 0 ]; then
		tr '[:lower:]' '[:upper:]';
	else
		tr '[:lower:]' '[:upper:]' <<< "$@";
	fi;
}
