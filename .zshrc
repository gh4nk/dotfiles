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
antigen bundle djui/alias-tips

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle macos
fi

antigen theme romkatv/powerlevel10k

antigen apply

 [[ ! -f ~/.p10k.zsh ]]     || source ~/.p10k.zsh
 [[ ! -f ~/.aliases ]]      || source ~/.aliases
 [[ ! -f ~/.env ]]          || source ~/.env
 [[ ! -f ~/.functions ]]    || source ~/.functions
 [[ ! -f ~/.passwords ]]    || source ~/.passwords

source <(kubectl completion zsh)
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
