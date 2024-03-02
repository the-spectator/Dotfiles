[ -f ~/.fzf.bash ] && source ~/.fzf.zsh

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# Rust Path
# export PATH="$HOME/.cargo/bin:$PATH"

# Go path
# export PATH=$PATH:/usr/local/go/bin

# Add rbenv to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
source "$HOME/.rbenv/completions/rbenv.zsh"

# GOlang defaulth path
export GOPATH=$HOME/personal-projects/go
export PATH=$GOPATH/bin:$PATH

# My env variables
# export DISABLE_SPRING="1"
export sidekiq_user="akshay"
export sidekiq_password="abcd@123"

# Disable auto homebrew update
export HOMEBREW_NO_AUTO_UPDATE=1

# Lazynvm
source $HOME/lazynvm.sh

# alias
alias be="bundle exec"
alias gs="g status"
alias gd="g diff"
alias gdc="g diff --cached"
alias dc="docker-compose"
alias gfo="git fetch origin"
alias vi="nvim"
alias mzsh="arch -arm64 zsh"
alias izsh="arch -x86_64 zsh"
alias correct_me="git status --porcelain | grep -v "^ D" | xargs bundle exec rubocop -a"
alias diary="cd ~/personal-projects/Day_In_Life && code ."
alias kcp="kubectl cp --retries=10"


# Myhelpers
function mktouch() {
  file_path="$@"
  file=${file_path##*/}
  dir_path="${file_path/%$file}"
  mkdir -p "${dir_path}" && touch "$file_path"
}

function cp_edconfig() {
  local editorconfig_path="$HOME/personal-projects/Dotfiles/.editorconfig"
  cp "$editorconfig_path" "$PWD"
}

# tabname
# http://thelucid.com/2012/01/04/naming-your-terminal-tabs-in-osx-lion/
function tn {
  printf "\e]1;${1:-bash}\a"
}

# bundle grep
function bgrep {
  if [ -z "$1" ]; then
    echo "usage: bgrep text-to-search"
    return 1
  fi
  echo "Searching for $1"
  grep -r $1 $(bundle list --paths) .
}

function ff {
  if [ -z "$1" ]; then
    echo "usage: ff name-of-file"
    return 1
  fi
  find ./ -iname "*$1*"
}

function load_project {
  if [ -z "$1" ]; then
    echo "usage: load_project project_path relative to home"
    return 1
  fi
  echo "Opening project $1"

  cd ~/$1 &&
  (
    tab "code ."
    tab "g s"
  )

  if [ -e ./bin/dev ]
  then
    echo "Running bin/dev"
      ./bin/dev
  elif is_rails_project "$@"
  then
    echo "Running rails server"
    bundle exec rails s
  else
    echo "Loaded project $@"
  fi

  return 1
}

function is_rails_project {
  if test -f ~/"$@"/Gemfile && grep rails ~/"$@"/Gemfile > /dev/null
  then
    echo "🚊 Found rails project"
    return 0
  else
    echo "😢 Didn't find rails project"
    return 1
  fi
}

# returns the list of filenames from rspec output format
function rspec_paste() {
  pbpaste | cut -d ' ' -f 2 | sort
}

function respec() {
  rspec_paste | xargs rspec
}

function espec() {
  rspec_paste | cut -d ':' -f 1 | uniq | xargs $EDITOR
}

function klogs() {
  local instance_type=$1
  local instance_number=$2
  local instance_name=""
  local kube_name=""

  case "$instance_type" in
    worker)
      kube_name="mekari-credit-chart-worker"

      case "$instance_number" in
        1)
          instance_name="mekari-credit-staging-worker"
          ;;
        2)
          instance_name="mekari-credit-staging-2-worker"
          ;;
        *)
          echo "Invalid worker number: $instance_number"
          return 1
          ;;
      esac
      ;;
    web)
      kube_name="mekari-credit-chart"

      case "$instance_number" in
        1)
          instance_name="mekari-credit-staging"
          ;;
        2)
          instance_name="mekari-credit-staging-2"
          ;;
        *)
          echo "Invalid web number: $instance_number"
          return 1
          ;;
      esac
      ;;
    *)
      echo "Invalid instance type: $instance_type"
      return 1
      ;;
  esac

  echo "kubectl logs --tail=5000 -f --selector=app.kubernetes.io/name="$kube_name",app.kubernetes.io/instance="$instance_name" --max-log-requests=10"
  kubectl logs --tail=5000 -f --selector=app.kubernetes.io/name="$kube_name",app.kubernetes.io/instance="$instance_name" --max-log-requests=10
}

function restart_rails() {
  kill -SIGUSR2 "$(cat $(pwd)/tmp/pids/server.pid)"
}
