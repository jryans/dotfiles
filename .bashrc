#!/bin/bash
# vim: tw=0

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

UNAME=`uname`

if [[ "$UNAME" == 'Darwin' ]]; then
  OS="mac"
else
  OS="linux"
fi

if [[ "$OS" == 'mac' ]]; then
  SED="gsed"
else
  SED="sed"
fi

PS1='\[\e]1;\W\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[1;31m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '

export LANG="en_US.UTF-8"

export PROJPATH="${HOME}/Projects"
export EDITOR="vim"
export PATH="$HOME/bin:$HOME/.cargo/bin:${PROJPATH}/git-cinnabar:${PROJPATH}/hgexts/version-control-tools/git/commands:${PROJPATH}/mozilla/moz-git-tools:${PROJPATH}/arcanist/bin:${PROJPATH}/mozilla/moz-phab:${PROJPATH}/android-sdk/tools:${PROJPATH}/android-sdk/platform-tools:/usr/local/sbin:/usr/local/bin:$PATH"
hash brew 2>/dev/null && export PATH="$PATH:$(brew --prefix go)/bin:$(brew --prefix vim)/bin"

export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL="ignoreboth"
export HISTTIMEFORMAT="%F %r %Z "
shopt -s histappend

[[ -s /usr/libexec/java_home ]] && export JAVA_HOME=`/usr/libexec/java_home`
export MAVEN_OPTS="-Xmx1024M"

export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

if [[ "$OS" == 'mac' ]]; then
  CORES="$(sysctl -n hw.ncpu)"
else
  CORES="$(nproc)"
fi
export MAKEFLAGS="-j $(echo "${CORES} - 2" | bc)"

# Shell integrations
hash brew 2>/dev/null && [[ -s `brew --prefix`/etc/bash_completion ]] && source `brew --prefix`/etc/bash_completion
[[ -s /etc/bash_completion ]] && source /etc/bash_completion
hash rbenv 2>/dev/null && eval "$(rbenv init -)"
[[ -s ~/.twig/twig-completion.bash ]] && source ~/.twig/twig-completion.bash
[[ -s "${PROJPATH}/mozilla/gecko-dev/python/mach/bash-completion.sh" ]] && source "${PROJPATH}/mozilla/gecko-dev/python/mach/bash-completion.sh"
# [[ -s ~/.scm_breeze/scm_breeze.sh ]] && source ~/.scm_breeze/scm_breeze.sh
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
hash direnv 2>/dev/null && eval "$(direnv hook bash)"
[[ -s ~/.fzf.bash ]] && source ~/.fzf.bash

# General
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
if [[ "$OS" == 'mac' ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias dek='sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext /System/Library/Extensions/AppleUSBMultitouch.kext'
alias eek='sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext /System/Library/Extensions/AppleUSBMultitouch.kext'
alias lsp='lsof -i -n -P -sTCP:LISTEN'
alias gash='/Applications/git-annex.app/Contents/MacOS/runshell'
alias mqgit='idx=0; while read patch; do idx=$((idx + 1)); printf -v pad "%03g" $idx; $(hg-patch-to-git-patch $patch > "$pad-$patch-git"); done < series'
alias gencert="openssl req -x509 -sha256 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -days 365 -nodes -subj '/CN=localhost'"
alias serve="http-server -p 9000 -S -C localhost.crt -K localhost.key"
alias rsync-push="rsync -avuPzhn /Users/jryans/Downloads jryans@192.168.1.110:/Users/jryans"
alias rm-pyc="find . -name \*.pyc -exec rm {} \;"
alias ninja="ninja $MAKEFLAGS"

fe() {
  find . -type d -depth 1 | parallel --timeout 20 "echo -e '\033[32m{}\033[0m'; cd {}; $*"
}

# Chromium
alias gch='./build/gyp_chromium'
alias rchrome='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary --remote-debugging-port=9222'

alias urc='drc'

drc() {
  launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist
}

# Node.js
# alias node='env NODE_NO_READLINE=1 rlwrap node'
alias noder='repl.history'

# Git
alias lst="git log -n 3 | grep '#' | head -n 1 | cut -c5-"
alias gpt='git push && git push --tags'

# Android
alias carem='adb forward tcp:9222 localabstract:chrome_devtools_remote'

# DevTools
alias bdt='./mach build toolkit/devtools browser'
#alias mrel='find obj-firefox-release -regex .*/dist/[^/]*\.app | sed -e '\''s/$/\/Contents\/MacOS\/firefox-bin -no-remote -P development -purgecaches -foreground/'\'' | sh'
#alias mdbg='find obj-firefox-debug -regex .*/dist/[^/]*\.app | sed -e '\''s/$/\/Contents\/MacOS\/firefox-bin -no-remote -P development -purgecaches -foreground/'\'' | sh'
alias mr='MOZ_QUIET=1 ./mach run -P development -purgecaches |& grep -v -e "bootstrap_register" -e "bootstrap_defs" -e "presentFunctionRowItemTextInputViewWithEndpoint" -e "VR Path Registry"'
alias gfx='/Applications/Firefox.app/Contents/MacOS/firefox -profile `pwd`/profile -no-remote'
alias rfx='BIN="/Applications/FirefoxNightly.app/Contents/MacOS/firefox-bin" PROFILE="'\''/Users/jryans/Library/Application Support/Firefox/Profiles/0y5jwofy.simulator/'\''" make run'
alias af='adb forward tcp:6000 localfilesystem:/data/local/debugger-socket'
alias cjs='CC=clang CXX=clang++ ../js/src/configure --disable-threadsafe'
alias bs='obj-firefox-release-b2g-desktop/_virtualenv/bin/python b2g/simulator/build_xpi.py mac64'
alias retouch='touch */CLOBBER configure js/src/configure */config.status */js/src/config.status'
alias simprof='P=1 NOFTU=1 GAIA_APP_TARGET=production make profile'
alias fetchpr='git config --add remote.upstream.fetch +refs/pull/*/head:refs/remotes/upstream/pr/*'
alias rsim='mach run -profile /Users/jryans/Projects/mozilla/gaia/profile -start-debugger-server 6000'
alias rjpm='JPM_FIREFOX_BINARY=/Users/jryans/Projects/mozilla/gecko-dev-3/obj-firefox-release/dist/Nightly.app/Contents/MacOS/firefox-bin jpm run -v --binary-args -foreground'
alias bt='mach run -profile /Users/jryans/Library/Application\ Support/Firefox/Profiles/i9e2tppc.development/chrome_debugger_profile -chrome chrome://browser/content/devtools/framework/toolbox-process-window.xul'
alias gt='bin/gaia-test . /Applications/FirefoxNightly.app/Contents/MacOS/firefox'
alias gps='touch ~/.mozbuild/mercurial/setup.lastcheck'
alias test-wpt-firefox='./mach test-wpt --product firefox --binary /Users/jryans/Projects/mozilla/gecko-dev-3/obj-firefox-release-artifact/dist/Nightly.app/Contents/MacOS/firefox --certutil-binary /Users/jryans/Projects/mozilla/gecko-dev-3/obj-firefox-release-artifact/dist/Nightly.app/Contents/MacOS/certutil --prefs-root /Users/jryans/Projects/mozilla/gecko-dev-3/testing/profiles'
alias try-all-dt='./mach try fuzzy --preset all-dt'
alias tf='./mach try fuzzy --preset'
alias mr-prof='MOZ_PROFILER_STARTUP=1 MOZ_PROFILER_STARTUP_ENTRIES=10000000 ./mach run'

link-mc() {
  for conf in "${PROJPATH}/mozilla/gecko-dev/.mozconfig-*"
  do
    ln -snf $conf
  done
}

# Stylo
alias try-stylo-mochi='./mach try -b do -p linux64 -u mochitests'
alias try-stylo-all='./mach try -b do -p linux64,linux64-haz -u all'
alias mr-gecko='STYLO_FORCE_DISABLED=1 mr'
alias mach-gecko='STYLO_FORCE_DISABLED=1 ./mach'
alias mr-stylo='STYLO_FORCE_ENABLED=1 mr'
alias mach-stylo='STYLO_FORCE_ENABLED=1 ./mach'
alias mach-reftest-svg='./mach reftest --setpref=reftest.compareStyloToGecko=true'

# Go
export GOPATH=${PROJPATH}/go

# Rust
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export CARGO_HOME=$HOME/.cargo
export RUSTUP_HOME=$HOME/.rustup

[[ -s $HOME/Scripts/build.sh ]] && source $HOME/Scripts/build.sh
[[ -s $HOME/Scripts/dpdk.sh ]] && source $HOME/Scripts/dpdk.sh

