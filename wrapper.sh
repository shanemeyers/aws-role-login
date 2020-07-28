#!/bin/bash

TMP=`mktemp`
# not sure why, but docker is outputting DOS line endings
docker run --rm -it -v $HOME/.aws:/root/.aws shanemeyers/aws-role-login:latest $1 $2 | tr -d '\r' | tee $TMP
source $TMP
rm -f $TMP
