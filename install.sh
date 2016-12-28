#!/bin/bash

# This script is extremely Ubuntu/Debian centric
# If you need support of other *nix versions - let me know 
# and we will work it out.

cat <<EOF
	This script will:
	  * download&install dependency plugins
	  * check Exuberant Ctags version
		* download&install PowerLine symbols
		* download&install Hack font

	Press Enter to proceed, Ctrl-C to cancel
EOF

read JUNK

CWD=$(dirname $(readlink -f $0))
cd $CWD

WGET=`which wget`

if [ -z "$WGET" ]; then
	echo "It needs wget to download stuff from internets"
fi

printf '\033[0;34m%s\033[0m\n' "Installing plugins..."
echo "Enter to proceed, 's' followed by Enter to skip (you do not really want to skip them :)"

read ANSWER
if [ "$ANSWER" != "s" ]; then
	cd $CWD
	git submodule update --init --recursive
fi

printf '\033[0;34m%s\033[0m\n' "Manual configuration needed!!!! ..."
cat <<EOF

Add this line to the top of your .vimrc
execute pathogen#infect("bundle/{}", "bundle/vim-ide-elixir/bundle/{}")

Add this line to the very bottom of your .vimrc
call vimide#init()

After finishing, Press Enter to continue
EOF

read JUNK

CTAGS=`which ctags`
if [ -z "$CTAGS" ]; then
	printf '\033[0;34m%s\033[0m\n' "Need Exuberant Ctags > version 5.5 for proper work"
	echo "Will try to install using apt-get"
	echo "Enter to proceed, 's' followed by Enter to skip"

	read ANSWER
	if [ "$ANSWER" != "s" ]; then
		sudo apt-get install -y exuberant-ctags
	fi
else
	printf '\033[0;34m%s\033[0m\n' "Please validate that your Exuberant Ctags > version 5.5"
	$CTAGS --version

	echo "Enter to continue"
	read JUNK
fi

if [ ! -d $HOME/.fonts/powerline ]; then
	printf '\033[0;34m%s\033[0m\n' "Installing font for statusline..."
	echo "Enter to proceed, 's' followed by Enter to skip"

	read ANSWER
	if [ "$ANSWER" != "s" ]; then
		mkdir -p $HOME/.fonts/powerline
		$WGET -O $HOME/.fonts/powerline/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
		[ -d $HOME/.fonts.conf.d ] || mkdir $HOME/.fonts.conf.d
		$WGET -O $HOME/.fonts.conf.d/10-powerline-symbols.conf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
		cp $HOME/.fonts.conf.d/10-powerline-symbols.conf $HOME/.fonts/powerline/10-powerline-symbols.conf

		fc-cache -vf $HOME/.fonts
	fi
fi

if [ ! -d $HOME/.fonts/hack ]; then
	printf '\033[0;34m%s\033[0m\n' "Installing Hack font..."
	echo "Enter to proceed, 's' followed by Enter to skip"
	read ANSWER
	if [ "$ANSWER" != "s" ]; then
		mkdir -p $HOME/.fonts/hack

		$WGET -O $HOME/.fonts/hack/Hack-Bold.ttf https://github.com/chrissimpkins/Hack/raw/4631d7b48f3120d06877505eb5f28283cf1bb30a/build/ttf/Hack-Bold.ttf
		$WGET -O $HOME/.fonts/hack/Hack-BoldItalic.ttf https://github.com/chrissimpkins/Hack/raw/4631d7b48f3120d06877505eb5f28283cf1bb30a/build/ttf/Hack-BoldItalic.ttf
		$WGET -O $HOME/.fonts/hack/Hack-Italic.ttf https://github.com/chrissimpkins/Hack/raw/4631d7b48f3120d06877505eb5f28283cf1bb30a/build/ttf/Hack-Italic.ttf
		$WGET -O $HOME/.fonts/hack/Hack-Regular.ttf https://github.com/chrissimpkins/Hack/raw/4631d7b48f3120d06877505eb5f28283cf1bb30a/build/ttf/Hack-Regular.ttf

		fc-cache -vf $HOME/.fonts
	fi
fi




