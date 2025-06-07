
export PATH="/opt/homebrew/bin:$PATH"

export PATH="$PATH:$HOME/.puro/bin" # Added by Puro
export PATH="$PATH:$HOME/.puro/shared/pub_cache/bin" # Added by Puro
export PATH="$PATH:$HOME/.puro/envs/default/flutter/bin" # Added by Puro
export PURO_ROOT="/Users/vinicius.vilela/.puro" # Added by Puro
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# if [[ $TERM_PROGRAM == "WezTerm" && -z "$NU_SHELL_STARTED" && -z "$INSIDE_NUSHELL" ]]; then
#   export NU_SHELL_STARTED=1
#   clear
#   exec /opt/homebrew/bin/nu
# fi

# fnm
FNM_PATH="/Users/vinicius.vilela/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/vinicius.vilela/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(oh-my-posh init zsh)"



eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/star.omp.json)"


eval "$(zoxide init zsh)"




eval "$(fnm env --use-on-cd --shell zsh)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh



alias ls='ls -G'
alias emulator='open -a Simulator'


# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
gdv() { git diff -w "$@" | view - }
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcm='git checkout master'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --max-count=5'
alias gss='git status -s'
alias ga='git add'
alias gm='git merge'

alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'


alias gsr='git svn rebase'
alias gsd='git svn dcommit'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {

  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'

alias ggpush='git push origin $(current_branch)'

alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'

