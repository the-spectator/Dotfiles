#!/bin/bash
source ~/colours.sh

if [[ -z "$SKIP" ]]
then
  printf "\n${cyan}${bold}Running pre-commit hooks${nc}\n"
  files=$(git status -s | grep -E 'A|M' | awk '{print $2}')
  files="$files $(git status -s | grep -E 'R' | awk '{print $4}')"
  echo $files | xargs rubocop --extra-details --parallel --force-exclusion
  status=$?
  if [ $status -eq 0 ]
  then
    printf "\n${cyan}Check Rubocop................................${nc}${green}${bold}Passed ✓${nc}\n"
    exit 0
  else
    printf "\n${cyan}Check Rubocop................................${nc}${red}${bold}Failed ✗${nc}\n"
    exit 1
  fi
else
  printf "\n${red}${bold}⚠  Skipping pre-commit hooks${nc}\n"
fi
printf "\n\n"
