#!/bin/bash

export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Fafacxdxbxegedabagacad
export IDEA_LAUNCHER_DEBUG=true


# PROMPT STUFF
GREEN=$(tput setaf 2);
YELLOW=$(tput setaf 3);
RESET=$(tput sgr0);

function git_branch {
  # Shows the current branch if in a git repository
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \(\1\)/';
}

function random_element {
  declare -a array=("$@")
  r=$((RANDOM % ${#array[@]}))
  printf "%s\n" "${array[$r]}"
}

# Default Prompt
setEmoji () {
  EMOJI="$*"
  DISPLAY_DIR='$(dirs)'
  DISPLAY_BRANCH='$(git_branch)'
  PROMPT="${YELLOW}${DISPLAY_DIR}${GREEN}${DISPLAY_BRANCH}${RESET} ${EMOJI}"$'\n'"$ ";
}

newRandomEmoji () {
  setEmoji "$(random_element 😅 👽 🔥 🚀 👻 ⛄ 👾 🍔 😄 🍰 🐑 😎 🏎 🤖 😇 😼 💪 🦄 🥓 🌮 🎉 💯 ⚛️ 🐠 🐳 🐿 🥳 🤩 🤯 🤠 👨‍💻 🦸‍ 🧝‍ 🧞‍ 🧙‍ 👨‍🚀 👨‍🔬 🕺 🦁 🐶 🐵 🐻 🦊 🐙 🦎 🦖 🦕 🦍 🦈 🐊 🦂 🐍 🐢 🐘 🐉 🦚 ✨ ☄️ ⚡️ 💥 💫 🧬 🔮 ⚗️ 🎊 🔭 ⚪️ 🔱)"
}

newRandomEmoji

alias remixify="PS1=\"💿\"$'\n'\"$ \"";
alias jestify="PS1=\"🃏\"$'\n'\"$ \"";
alias testinglibify="PS1=\"🐙\"$'\n'\"$ \"";
alias cypressify="PS1=\"🌀\"$'\n'\"$ \"";
alias staticify="PS1=\"🚀\"$'\n'\"$ \"";
alias nodeify="PS1=\"💥\"$'\n'\"$ \"";
alias reactify="PS1=\"⚛️\"$'\n'\"$ \"";
alias harryify="PS1=\"🧙‍\"$'\n'\"$ \"";

# ripgrep config
RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# allow substitution in PS1
setopt promptsubst

# history size
HISTSIZE=5000
HISTFILESIZE=10000

SAVEHIST=5000
setopt EXTENDED_HISTORY
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS

# PATH ALTERATIONS
## Node
# /opt/homebrew/bin first so Apple-Silicon Homebrew shadows the stale Intel
# Homebrew in /usr/local/bin (e.g. its git 2.20.1, too old for lefthook).
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH:./node_modules/.bin";

## Yarn
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# alias yarn="echo update the PATH in ~/.zshrc"

# Custom bins
PATH="$PATH:$HOME/.bin";
# dotfile bins
PATH="$PATH:$HOME/.my_bin";
# npm.im/n
export N_PREFIX="$HOME/n"; [[ :$PATH: == *"$N_PREFIX/bin"* ]] || PATH="$N_PREFIX/bin:$PATH"  # Added by n-install (see http://git.io/n-install-repo).

# script kit
PATH="$PATH:$HOME/.kenv/bin:$HOME/.kit/bin";

# fly manual install
PATH="$HOME/.fly/bin:$PATH";

# CDPATH ALTERATIONS
CDPATH=.:$HOME:$HOME/code:$HOME/Desktop
# CDPATH=.:$HOME:$HOME/code:$HOME/code/epic-react:$HOME/code/testingjavascript:$HOME/Desktop

# disable https://scarf.sh/
SCARF_ANALYTICS=false

# Custom Aliases
alias codevs="\"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code\""
alias codei="cd /Applications && ./IntelliJ\ IDEA.app/Contents/MacOS/idea"
function c { code ${@:-.} }
alias ll="ls -1a";
alias ..="cd ../";
alias ..l="cd ../ && ll";
alias pg="echo 'Pinging Google' && ping www.google.com";
alias vz="vim ~/.zshrc";
alias cz="code ~/.zshrc";
alias sz="source ~/.zshrc";
alias de="cd ~/Desktop";
alias d="cd ~/code";
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias deleteDSFiles="find . -name '.DS_Store' -type f -delete"
alias kcd-oss="npx -p yo -p generator-kcd-oss -c 'yo kcd-oss'";
function rmx {
  cp -R ~/.rmx "$@";
  cd "$@";
}
alias npm-update="npx npm-check-updates --dep prod,dev --upgrade";
alias yarn-update="yarn upgrade-interactive --latest";
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias dont_index_node_modules='find . -type d -name "node_modules" -exec touch "{}/.metadata_never_index" \;';
alias check-nodemon="ps aux | rg -i '.bin/nodemon'";
alias projects='cd ~/Projects'

# Mac setup for pomo: https://gist.github.com/bashbunni/f6b04fc4703903a71ce9f70c58345106
alias work="timer 60m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"

alias rest="timer 10m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"

# Salsa project specific
alias salsa='cd ~/Projects/15-salsa/'

## git aliases
function gc { git commit -m "$@"; }
alias gs="git status";
alias gp="git pull";
alias gf="git fetch";
alias gpush="git push";
alias gd="git diff";
alias ga="git add .";
dif() { git diff --color --no-index "$1" "$2" | diff-so-fancy; }
cdiff() { code --diff "$1" "$2"; }

## npm aliases
alias ni="npm install";
alias nrs="npm run start -s --";
alias nrb="npm run build -s --";
alias nrd="npm run dev -s --";
alias nrt="npm run test -s --";
alias nrtw="npm run test:watch -s --";
alias nrv="npm run validate -s --";
alias rmn="rm -rf node_modules";
alias flush-npm="rm -rf node_modules package-lock.json && npm i && say NPM is done";
alias nicache="npm install --prefer-offline";
alias nioff="npm install --offline";

## yarn aliases
alias yar="yarn run";
alias yas="yarn run start";
alias yab="yarn run build";
alias yat="yarn run test";
alias yav="yarn run validate";
alias yoff="yarn add --offline";
alias ypm="echo \"Installing deps without lockfile and ignoring engines\" && yarn install --no-lockfile --ignore-engines"

## use hub for git
alias git=hub

# Custom functions
mg () { mkdir "$@" && cd "$@" || exit; }
cdl() { cd "$@" && ll; }
npm-latest() { npm info "$1" | grep latest; }
killport() { lsof -i tcp:"$*" | awk 'NR!=1 {print $2}' | xargs kill -9 ;}
function quit () {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: quit appname"
  else
    for appname in $1; do
    osascript -e 'quit app "'$appname'"'
    done
  fi
}

gif() {
  ffmpeg -i "$1" -vf "fps=25,scale=iw/2:ih/2:flags=lanczos,palettegen" -y "/tmp/palette.png"
  ffmpeg -i "$1" -i "/tmp/palette.png" -lavfi "fps=25,scale=iw/2:ih/2:flags=lanczos [x]; [x][1:v] paletteuse" -f image2pipe -vcodec ppm - | convert -delay 4 -layers Optimize -loop 0 - "${1%.*}.gif"
}

# zsh auto autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

source ~/.zshrc.private

[ -s "/Users/dalogon/.jabba/jabba.sh" ] && source "/Users/dalogon/.jabba/jabba.sh"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# bit
export PATH="$PATH:/Users/dalogon/bin"
# bit endexport PATH=$HOME/bin:$PATH
# infrastructure-utils
setopt prompt_subst
export PS1='$AWS_PROMPT'$PS1

# plz-cli openai api key: https://github.com/m1guelpf/plz-cli

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$HOME/.local/bin:$PATH"


# Requires https://github.com/caarlos0/timer to be installed

# Mac setup for pomo
alias work="timer 25m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -appIcon '~/Pictures/pumpkin.png'\
        && afplay /System/Library/Sounds/Glass.aiff"

alias rest="timer 5m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -appIcon '~/Pictures/pumpkin.png'\
        && afplay /System/Library/Sounds/Glass.aiff"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export NODE_OPTIONS="--dns-result-order=ipv4first"
