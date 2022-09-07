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

function window() {
  # Must not have trailing semicolon, for iTerm compatibility
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_macos_get_frontmost_app)


  if [[ "$the_app" == 'iTerm2' ]]; then
    osascript <<EOF
      tell application "iTerm2"
        tell current window
          set newWindow to (create window with default profile)
          tell current session to write text "${command}"
        end tell
      end tell
EOF
  else
    echo "$0: unsupported terminal app: $the_app" >&2
    return 1
  fi
}

