#!/bin/bash
source "$HOME/colours.sh"

hooks=("rubocop_hook")

function rubocop_hook() {
  files=$(git diff --name-only --cached)
  echo $files | xargs rubocop --extra-details --parallel --force-exclusion

  local status
  status=$?

  if [[ status -eq 0 ]]
  then
    printf "\n${cyan}Check ${bold}Rubocop${nc} ................................ ${nc}${green}${bold}Passed ✓${nc}\n"
    return 0
  else
    printf "\n${cyan}Check ${bold}Rubocop${nc}................................ ${nc}${red}${bold}Failed ✗${nc}\n"
    return 1
  fi
}

if [[ -z "$SKIP" ]]
then
  printf "\n${cyan}${bold}Running pre-commit hooks${nc}\n"

  for hook in "${hooks[@]}"; do
    ${hook}
  done
else
  printf "\n${red}${bold}⚠  Skipping pre-commit hooks${nc}\n"
fi
printf "\n\n"
