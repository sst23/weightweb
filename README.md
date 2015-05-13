# weightweb

This repo contains a small web app which helps you with tracking
your weight.

![weightweb screenshot](http://i.imgur.com/wF5Vl81.png)

It will create a `~/.weight.txt` file which contains your data in
a human-readable format:

    2015-05-04 80.3
    2015-05-05 81.3
    2015-05-06 80.7

You can also edit this file by hand. It will be automatically
updated in the webinterface.

This app uses `OX` and `Moose` and other dependencies. After checking out the
repo you can install these dependencies by running the following
commands:

    cd weightweb
    cpanm --installdeps .

The app uses PSGI, so you can use any PSGI you like to run the app:

    cd bin
    plackup weightweb.psgi
