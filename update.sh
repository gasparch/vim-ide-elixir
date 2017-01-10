#!/bin/bash

CWD=$(dirname $(readlink -f $0))
cd $CWD

git pull

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
git submodule sync
git submodule update --init --recursive --depth 100 -j 3
git submodule update --remote --merge
