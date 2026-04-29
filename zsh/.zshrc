# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/vini/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END


export PATH="/opt/homebrew/bin:$PATH"



eval "$(oh-my-posh init zsh)"



eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/star.omp.json)"


eval "$(zoxide init zsh)"




# eval "$(fnm env --use-on-cd --shell zsh)"



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

alias vim='nvim'
alias claude='claude --allow-dangerously-skip-permissions'

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
eval "$(~/.local/bin/mise activate zsh)"

. "$HOME/.local/bin/env"

# Update Zellij tab name to current directory basename
function _zellij_tab_name() {
    if [[ -n "$ZELLIJ" ]]; then
        local tab_name="${PWD##*/}"
        [[ -z "$tab_name" ]] && tab_name="/"
        (( ${#tab_name} > 20 )) && tab_name="${tab_name:0:19}…"
        command zellij action rename-tab "$tab_name"
    fi
}
chpwd_functions+=(_zellij_tab_name)
_zellij_tab_name

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
