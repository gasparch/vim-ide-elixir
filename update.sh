#!/bin/sh

CWD=`dirname $(readlink -f $0)`
cd $CWD

case $1 in
	dev)
		CHANNEL="dev"
		;;
	beta)
		CHANNEL="beta"
		;;
	*)
		CHANNEL="production"
esac

if [ "$CHANNEL" != "dev" ]; then
	VERSIONS=`$CWD/check_update.sh $CHANNEL`
	case "$VERSIONS" in
		noupdate,*)
			echo "no updates available"
			exit 1;;
		update,*)
			RELEASE=`echo "$VERSIONS" | cut -d',' -f3`
			VERSION=`echo "$VERSIONS" | cut -d',' -f4`
			echo "updating to $VERSION"
	esac
fi


git_fetch_all() {
	git fetch --all
}

git_checkout_version() {
	if [ ! -z "$VERSION" ]; then
		git checkout $VERSION
	else
		git checkout master
		git pull
	fi
}

git_update_submodules() {
	SUBMODULE_LIST=`git submodule status | awk '{print $2}'`

	HAS_REPOS_W_CHANGED_URLS=""

	for SUBMOD in $SUBMODULE_LIST; do
		cd $CWD/$SUBMOD
		REPO_URL=`git remote -v | grep fetch | awk '{print $2}'`
		cd $CWD
		MANIFEST_URL=`egrep -A1 "path = $SUBMOD\$" .gitmodules | grep url | awk '{print $3}'`
		if [ "$MANIFEST_URL" != "$REPO_URL" ]; then
			echo "changed repo URL $SUBMOD $REPO_URL $MANIFEST_URL"
			HAS_REPOS_W_CHANGED_URLS="YES"
			rm -rf $CWD/$SUBMOD
			rm -rf $CWD/.git/modules/$SUBMOD
		fi
	done

	cd $CWD
	git submodule sync > /dev/null &&
	git submodule update --init --recursive --depth 100 -j 3
}

update_release_file() {
	echo "$RELEASE" > "$CWD/.current_release"
}

git_fetch_all && git_checkout_version && git_update_submodules && update_release_file
