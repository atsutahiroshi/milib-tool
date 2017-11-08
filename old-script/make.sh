#!/bin/sh

PREFIX=$HOME/usr

SRCDIR=$PREFIX/src
BINDIR=$PREFIX/bin
INCDIR=$PREFIX/include
LIBDIR=$PREFIX/lib
ARCDIR=$PREFIX/archive

LIBCURE=cure
LIBZM=zm
LIBZEO=zeo
LIBDZCO=dzco
LIBROKI=roki
LIBZX11=zx11
LIBLIW=liw
LIBROKIGL=roki-gl
LIBS="$LIBCURE $LIBZM $LIBZEO $LIBDZCO $LIBROKI $LIBZX11 $LIBLIW $LIBROKIGL"

TAR=/bin/tar
GZIP=/bin/gzip

# mkdir
mkdirandcheck(){
    if [ ! -d $dir ]; then
	echo "cannot make" $dir;
	exit 1;
    fi
}

# compile
compile(){
  if [ -d $project ]; then
    cd $project
    if [ -n "$PREFIX" ]; then
	rm config;
	cat config.org | sed -e "/^PREFIX/c\PREFIX=$PREFIX" > config;
    fi
    if [ ! -f config ]; then
	cp config.org config;
    fi
    make clean
    make && make install || ( echo  "failed to compile " $project; exit 1 )
    cd -
  else
    echo "cannot find directory" $project
    exit 1
  fi
}

# install
setup(){
  for dir in $SRCDIR $BINDIR $INCDIR $LIBDIR $ARCDIR
  do
    mkdir -p $dir
    mkdirandcheck
  done
  # build all libraries
  for lib in $LIBS
  do
    project=$lib
    compile
  done
  # add paths to the shell source file
  echo "installation completed."
  echo
  echo "You may need to set your PATH and LD_LIBRARY_PATH environment"
  echo "variables. This is done by:"
  echo " export PATH=\$PATH:$BINDIR"
  echo " export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$LIBDIR"
  echo "if your working shell is Bourne shell (bash, zsh, etc.), or by:"
  echo " set path = ( \$path $BINDIR )"
  echo " setenv LD_LIBRARY_PATH \$LD_LIBRARY_PATH:$LIBDIR"
  echo "if your working shell is C shell (csh, tcsh, etc.)."
  echo "Or, edit /etc/ld.so.conf to point to the installed location and"
  echo "make sure you have run ldconfig if that is required on your system."
}

# makeclean
makeclean(){
  if [ -d $project ]; then
    cd $project
    make clean
    rm -f config *~
    cd -
  else
    echo "cannot find directory" $project
    exit 1
  fi
}

# archive
archive(){
  test -x ${TAR} || ( echo "cannot find" ${TAR}; exit 1 )
  test -x ${GZIP} || ( echo "cannot find" ${GZIP}; exit 1 )
  command -v git >/dev/null 2>&1 || ( echo "cannot find git"; exit 1 )
  cd $project
  ver=`git describe --abbrev=0 --tags`
  ARCH=$project-$ver.`date "+%Y%m%d"`.tgz
  # ${TAR} cf - $project | ${GZIP} > ${ARCH}
  git archive --format=tar --prefix=$project-$ver HEAD | gzip > ../${ARCH}
  echo "created archive" ${ARCH}
  cd -
}

case $1 in
  install)
    setup
  ;;
  clean)
    for lib in $LIBS
    do
      project=$lib
      makeclean
    done
  ;;
  archive)
    for lib in $LIBS
    do
      project=$lib
      archive
    done
    ;;
  *)
    for lib in $LIBS
    do
      project=$lib;
      compile;
    done
  ;;
esac

exit 0
