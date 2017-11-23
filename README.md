# Utilities for Motor Intelligence Laboratory Library #

Utilities for installing libraries developed in [Motor Intelligence Laboratory](http://mi.ams.eng.osaka-u.ac.jp/) in Osaka University. See the [project page](http://mi.ams.eng.osaka-u.ac.jp/open-e.html) for more details.

## Getting started ##

### Downloading ###

To download the latest version of cure, type the following:

``` shell
./download cure
```

To download all the public versions of cure, type the following:

``` shell
mkdir -p archive
tac versions/cure.public | xargs -n 1 ./download --output-dir archive
```

To download all the versions of cure including ones which are stored on Motor Intelligence Laboratory's wiki, type the following:

``` shell
mkdir -p archive
tac versions/cure | xargs -n 1 ./download --output-dir archive --user USERNAME --passwd PASSWORD
```

Or, you can create a file which contains username and password for authentication to wiki.

``` shell
 echo "USERNAME" >>passwd    # this command should not remain in the command history
 echo "PASSWORD" >>passwd    # this command should not remain in the command history
chmod 400 passwd
tac versions/cure | xargs -n 1 ./download --output-dir archive --passwd-file passwd
```

### Updating ###

To update source files to a specific version of cure, type the following:

``` shell
./update --no-git cure-1.0.0-beta5.tgz cure
```

To make a Git commit when updating, type the following:

``` shell
./update cure-1.0.0-beta5.tgz cure
```

To make a series of Git commit history, type the following:

``` shell
tac versions/cure | xargs -n 1 -i ./update --skip archive/{} cure
```
