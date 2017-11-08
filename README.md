# Utilities for Motor Intelligence Laboratory Library #

Utilities for installing libraries developed in [Motor Intelligence Laboratory](http://mi.ams.eng.osaka-u.ac.jp/) in Osaka University. See the [project page](http://mi.ams.eng.osaka-u.ac.jp/open-e.html) for more details.

## Getting started ##

### Downloading ###

To download the latest version of cure, type the following:

``` shell
./script/download cure
```

To download all the public versions of cure, type the following:

``` shell
mkdir -p archive
tac versions/cure.public | xargs -n 1 ./script/download --output-dir archive
```

To download all the versions of cure including ones which are stored on Motor Intelligence Laboratory's wiki, type the following:

``` shell
mkdir -p archive
tac versions/cure | xargs -n 1 ./script/download --output-dir archive --user USERNAME --passwd PASSWORD
```

Or, you can create a file which contains username and password for authentication to wiki.

``` shell
 echo "USERNAME" >>script/passwd    # you need a space before command not to store it in the command history
 echo "PASSWORD" >>script/passwd    # you need a space before command not to store it in the command history
chmod 400 script/passwd
tac versions/cure | xargs -n 1 ./script/download --output-dir archive --passwd-file script/passwd
```

### Updating ###

To update source files to a specific version of cure, type the following:

``` shell
./script/update --no-git cure-1.0.0-beta5.tgz cure
```

To make a Git commit when updating, type the following:

``` shell
./script/update cure-1.0.0-beta5.tgz cure
```

To make a series of Git commit history, type the following:

``` shell
tac versions/cure | xargs -n 1 -i ./script/update --skip archive/{} cure
```
