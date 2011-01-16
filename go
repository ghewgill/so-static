#!/bin/sh -e

rm -rf static/questions static/users unify
mkdir -p static/users
mkdir -p static/questions
mkdir unify
./xt users.xml users.xsl
python unify.py
./posts.sh
./xt unify.xml index.xsl static/index.html
./go2 haskell 20
