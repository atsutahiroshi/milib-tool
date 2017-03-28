#!/bin/bash

# settings
set -eu
AUTO_COMMIT=${AUTO_COMMIT:-y}
WORK_DIR=`pwd`

# get path where this script exists
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd )"

if [ $# -eq 0 ]; then
    echo "specify library name to be updated as follows:"
    echo "  $0 cure-1.0.0-beta5"
    exit 1
fi

NEWLIB=$1
LIBNAME="${NEWLIB%%-*}"
VERSION="${NEWLIB#*-}"
if [[ ${NEWLIB} == roki-gl* ]]; then
    LIBNAME=roki-gl
    VERSION="${NEWLIB#*-*-}"
fi
LIBPATH=${WORK_DIR}/${LIBNAME}

# initialize as git repository
mkdir -p ${LIBPATH}
if [ ! -d ${LIBPATH}/.git ]; then
    cd ${LIBPATH}
    git init
    cp ${SCRIPT_DIR}/gitignore_samples/gitignore_${LIBNAME} .gitignore
    cd ${WORK_DIR}
fi

# download archive
wget --no-verbose --no-clobber http://www.mi.ams.eng.osaka-u.ac.jp/software/${NEWLIB}.tgz

# unarchive
tar xvfz ${NEWLIB}.tgz > /dev/null 2>&1

# delete old files and directories
find ${LIBPATH} -mindepth 1 -maxdepth 1 -type f ! -name ".git*" -exec rm -f {} +
find ${LIBPATH} -mindepth 1 -maxdepth 1 -type d ! -name ".git" -exec rm -rf {} +

# update
cp -r ${NEWLIB}/* ${LIBPATH}

# add .gitignore to empty directories
EMPTY_DIR=`find ${LIBPATH} -type d -empty | grep -v ".git"`
for dir in $EMPTY_DIR; do
    echo "*"           >> $dir/.gitignore
    echo "!.gitignore" >> $dir/.gitignore
done

# move archive
rm -rf ${NEWLIB}
mkdir -p ${WORK_DIR}/archive
mv ${NEWLIB}.tgz ${WORK_DIR}/archive

# commit
if [ $AUTO_COMMIT = y ]; then
    cd ${LIBPATH}
    ret=$(git branch)
    if [ -n "$ret" ]; then
        git checkout master
    fi
    git add .
    git commit -m "Version ${VERSION}"
    git tag "v${VERSION}" master
    cd ${WORK_DIR}
fi

# update GTAGS
if command -v gtags >/dev/null 2>&1; then
    cd ${WORK_DIR}
    rm -f G*
    gtags
    echo "updated GTAGS"
fi
