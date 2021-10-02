#!/bin/bash

set -v

if [ ! -d game ]; then
    mkdir game
fi

rm -rf game/*

godot --export HTML5 game/index.html
