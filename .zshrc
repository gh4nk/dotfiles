source $HOME/.antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle venv
antigen bundle docker
antigen bundle kubectl
antigen bundle helm
antigen bundle git-flow
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle terraform
antigen bundle colorize
antigen bundle emacs
antigen bundle Valiev/almostontop 
antigen bundle djui/alias-tips
antigen bundle juanrgon/yadm-zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle macos
fi

antigen theme romkatv/powerlevel10k

antigen apply

 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $HOME/.aliases
source $HOME/.env
source $HOME/.passwords
source $HOME/.functions
source <(kubectl completion zsh)
eval $(thefuck --alias)
complete -o nospace -C /usr/bin/vault vault
complete -o nospace -C /usr/bin/terraform terraform

setopt autocd extendedglob nomatch notify appendhistory sharehistory incappendhistory HIST_IGNORE_SPACE COMPLETE_ALIASES
unsetopt beep
bindkey -e
autoload -Uz compinit promptinit bashcompinit
compinit
promptinit
bashcompinit
zstyle :compinstall filename '$HOME/.zshrc'
neofetch
