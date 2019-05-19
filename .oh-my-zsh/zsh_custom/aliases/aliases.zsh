# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#####################
####### ALIASES   ###
#####################
# ZSH
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

# Git
alias g="git status"
alias gb="git branch"
alias ga="git add"
alias gc="git commit -m"
alias gpo="git push origin"
alias gco="git checkout"
alias gcb="git checkout -b"

# Computer
alias simpleserver="python -m SimpleHTTPServer"
alias reload_zsh="source ~/.zshrc"

# Node
alias npm_default="npm set registry https://registry.npmjs.org/"

# Check for work aliases
WORK_ALIASES=$ALIASES/work.zsh
if [ -f $WORK_ALIASES ]
then
  source $WORK_ALIASES
fi