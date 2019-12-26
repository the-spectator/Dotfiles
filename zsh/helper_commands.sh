# No arguments: `git status`
# With arguments: acts like `git`
function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

function mktouch() {
  file_path="$@"
  file=${file_path##*/}
  dir_path="${file_path/%$file}"
  mkdir -p "${dir_path}" && touch "$file_path"
}
