#!/bin/bash
source "$HOME/colours.sh"

# Array containing all checks/tasks we want to run in hook
hooks=(
  rubocop
)

# Function corresponding to check/task in hooks array
function rubocop_hook() {
  local files status length

  # Get all the staged files except deleted files
  files=$(git diff --name-only --cached --diff-filter=d)

  # Get word-length of files
  length=${#files}

  # Run rubocop hook only when length is "not equal" to 0
  if [[ length -ne 0 ]]; then
    echo $files | xargs bundle exec rubocop --extra-details --parallel --force-exclusion
  fi

  # Get exit status of command executed
  status=$?

  # Status is 0 when command exit status when successfully executed
  if [[ status -eq 0 ]]
  then
    printf "\n${cyan}Check ${bold}Rubocop${nc} ................................ ${nc}${green}${bold}Passed ✓${nc}\n"
    return 0
  else
    printf "\n${cyan}Check ${bold}Rubocop${nc}................................ ${nc}${red}${bold}Failed ✗${nc}\n"
    return 1
  fi
}

# Run hooks only when SKIP environment variable is not set
if [[ -z "$SKIP" ]]
then
  printf "\n${cyan}${bold}Running pre-commit hooks${nc}\n"

  for hook in "${hooks[@]}"; do
    ${hook}_hook
  done
else
  printf "\n${red}${bold}⚠  Skipping pre-commit hooks${nc}\n"
fi
printf "\n\n"
