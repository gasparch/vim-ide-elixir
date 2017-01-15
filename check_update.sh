#!/bin/sh

case $1 in
	beta) CHANNEL="beta" ;;
	dev) CHANNEL="dev" ;;
	*) CHANNEL="production"
esac

CWD=`dirname $(readlink -f $0)`
cd $CWD

if [ -f "$CWD/.release_channel" ]; then
	CHANNEL=`cat "$CWD/.release_channel"`
fi

case $CHANNEL in
	production) PATTERN='"tag_name": *".*[0-9]"' ;;
	beta) PATTERN='"tag_name": *".*[0-9]-beta"' ;;
	dev) PATTERN="dev";;
	*) echo "wrong channel name $CHANNEL"
	   exit 5
esac

if [ "$PATTERN" = "dev" ]; then
	DT=`date -I -d'6 months ago'`
	RELEASES=`curl -s -q "https://api.github.com/repos/gasparch/vim-ide-elixir/commits?since=$DT&sha=master"`
	LAST_RELEASE=`echo "$RELEASES" | egrep '"sha":' | head -n 1 | sed -e 's#^.*"\([0-9a-f]*\)".*$#\1#'`
	LAST_VERSION=$LAST_RELEASE
else
	RELEASES=`curl -s -q "https://api.github.com/repos/gasparch/vim-ide-elixir/releases" | egrep '"url":.*vim-ide-elixir|"tag_name":'`
	LAST_RELEASE=`echo "$RELEASES" | egrep -B1 "$PATTERN" | grep '"url"' | sed -e 's#^.*\/\([0-9]*\).*$#\1#' | sort -n | tail -n1`

	if [ -z "$LAST_RELEASE" ]; then
		echo "no releases in channel $CHANNEL"
		exit 5
	fi

	LAST_VERSION=`echo "$RELEASES" | egrep -A1 "url.*releases/$LAST_RELEASE" | grep '"tag_name"' | cut -d: -f2 | sed -e 's/,$//' -e 's/ //g' -e 's/"//g'`
fi

CURRENT_RELEASE=`[ -f $CWD/.current_release ] && cat $CWD/.current_release`

if [ ! -z "$CURRENT_RELEASE" -a "$CURRENT_RELEASE" = "$LAST_RELEASE" ]; then
	echo "noupdate,$CURRENT_RELEASE"
else
	echo "update,$CURRENT_RELEASE,$LAST_RELEASE,$LAST_VERSION"
fi

