#!/bin/bash

CWD=$(dirname $(readlink -f $0))
cd $CWD

git pull

# TODO: add functionality to detect submodule URL changes and
# deinit/remove/add

git submodule update --remote --merge
