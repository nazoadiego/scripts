ZSH_THEME="gozilla"

plugins=(
        z
        git 
        ssh-agent # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/README.md
        zsh-autosuggestions # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
        zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
)

# Checkout
alias myscripts="cd ~/scripts"
alias rbscripts="cd ~/scripts/rb"

# Run scripts
alias sort_by_type="ruby ~/scripts/rb/sort_by_file_type.rb"
alias restore_from_sort="ruby ~/scripts/rb/restore_from_sort.rb"

# utils
alias reload="source ~/.zshrc"

# Git
alias gcb="git branch --show-current | tr -d '\n' | pbcopy"
alias glast="git show --color --pretty=format:%b"
alias gcm='f() { git commit -m "$(git branch --show-current | grep -o "CON-[0-9]\+" ) $1" }; f' # Replace CON- with whatever the convention is
alias gcleanlocal="git branch --merged | grep -v '\*\|master\|main\|develop' | xargs -n 1 git branch -d"

# Open app
alias mine="open -na "RubyMine.app" --args "$@""

# Open zsh config file
alias zshconfig="code ~/.zshrc"

# Easter eggs
alias rubydance="ruby ~/ruby_egg.rb"
