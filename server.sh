#!/bin/sh

if [ ! -d game ]; then
    mkdir game
fi

if [ ! -f node_modules/.bin/browser-sync ]; then
    npm install
fi

node_modules/.bin/browser-sync start --server game --files game
