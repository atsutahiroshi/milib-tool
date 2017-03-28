#!/bin/bash

set -eu
WORK_DIR=`pwd`

LIBS="cure zm zeo dzco roki zx11 liw roki-gl"
HOST="ssh://git@mi.ams.eng.osaka-u.ac.jp:20202/home/git/git/atsuta"

for lib in $LIBS; do
    git clone $HOST/${lib}.git
done
