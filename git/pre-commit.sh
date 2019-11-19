#!/bin/bash
source "$HOME/colours.sh"

#########################################################################################
#                                   HOW to use it
# 1. Copy pre-commit.sh to your projects .git/hooks
# 2. make sure it is executable, else make it by `sudo chmod +x .git/hooks/pre-commit.sh`
# 3. Copy colours.sh to $HOME directory
# 4. Reload the environment
##########################################################################################

# Array containing all checks/tasks we want to run in hook
hooks=(
  rubocop_hook
  reek_hook
)

# Function corresponding to check/task in hooks array
function rubocop_hook() {
  local length rubocop_present

  # Get all the staged files except deleted files
  files="$(commited_files)"

  # Get word-length of files
  length=${#files}
  rubocop_present="$(command_present "rubocop")"

  # Run rubocop hook only when length is "not equal" to 0
  if [[ $rubocop_present -eq 0 ]] && [[ length -ne 0 ]]; then
    echo "$files" | xargs bundle exec rubocop --extra-details --parallel --force-exclusion
  fi
}

function reek_hook() {
  local length reek_present
  files="$(commited_files)"

  # Get word-length of files
  length=${#files}
  reek_present="$(command_present "reek")"

  # Run rubocop hook only when length is "not equal" to 0
  if [[ $reek_present -eq 0 ]] && [[ length -ne 0 ]]; then
    echo $files | xargs reek --force-exclusion
  fi
}

function thanks_hook() {
  echo "Thank YOU"
}

function command_present() {
  command -v "$@" &> /dev/null
  return $?
}

function commited_files() {
  files=$(git diff --name-only --cached --diff-filter=d)
  echo "$files"
}

# Run hooks only when SKIP environment variable is not set
if [[ -z "$SKIP" ]]
then
  printf "\n${cyan}${bold}Running pre-commit hooks${nc}\n"

  for hook in "${hooks[@]}"; do
    ${hook}

    # Get exit status of command executed
    status=$?

    # Status is 0 when command exit status when successfully executed
    if [[ $status -eq 0 ]]
    then
      printf "\n${cyan}Check ${bold}$hook${nc} ................................ ${nc}${green}${bold}Passed ✓${nc}\n"
    else
      printf "\n${cyan}Check ${bold}$hook${nc} ................................ ${nc}${red}${bold}Failed ✗${nc}\n"
      exit 1
    fi
  done
else
  printf "\n${red}${bold}⚠  Skipping pre-commit hooks${nc}\n"
fi
printf "\n\n"
