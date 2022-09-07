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

# My env variables
# export DISABLE_SPRING="1"
export sidekiq_user="akshay"
export sidekiq_password="abcd@123"

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
