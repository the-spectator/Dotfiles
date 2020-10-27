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
export DISABLE_SPRING="1"
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


# Myhelpers
function mktouch() {
  file_path="$@"
  file=${file_path##*/}
  dir_path="${file_path/%$file}"
  mkdir -p "${dir_path}" && touch "$file_path"
}
