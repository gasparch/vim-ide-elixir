#!/bin/bash

CWD=$(dirname $(readlink -f $0))
cd $CWD

[ -d sources ] || mkdir sources

cd $CWD/sources

if [ ! -d "otp" ]; then
	OTP_VERSION=`erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell | sed -e 's/"//g' -e 's///g'`
	echo "Checking out Erlang/OTP $OTP_VERSION"
	OTP_BRANCH="maint-$OTP_VERSION"
	git clone --depth 1 -b $OTP_BRANCH https://github.com/erlang/otp.git 
fi

if [ ! -d "elixir" ]; then
	ELIXIR_VERSION=`elixir -v | awk '/^Elixir/ {print $2}'`
	ELIXIR_TAG="v${ELIXIR_VERSION}"

	echo "Checking out Elixir $ELIXIR_VERSION"
	git clone --depth 1 -b $ELIXIR_TAG https://github.com/elixir-lang/elixir.git
fi
