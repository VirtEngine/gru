## Site Repo

This directory contains an example of a site repo for Gru.

A site repo in Gru is essentially a Git repository with branches,
where each branch maps to an environment, which can be used by
remote minions.

In order to use this site repo, simply copy the contents of this
directory and add them to a Git repository, which you can use by
your minions.

```bash
$ git clone https://github.com/megamsys/gru.git
$ cd ~/gru
$ git init
$ git add
$ git commit -m 'Initial commit of site repo'
```
you want to write the lua code for example ,you create a directory with lua file like
```bash
$ cd ~/gru/site
$ mkdir -p <directoryname>
$ cd <directoryname>
$ touch <filename>.lua
```
Once you've got the Gru repo in Git you can run the gru project by using this command, e.g.

```bash
$ ~/gru/gulp/gructl apply  ~/gru/site/route/route.lua
```
