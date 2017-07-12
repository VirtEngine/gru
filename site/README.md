## Site Repo

This directory contains the site repo for Gru we use in MegamVertice.

A site repo in Gru is essentially a Git repository with branches,
where each branch maps to an environment, which can be used by
remote minions.

In order to use this site repo, and authoring a new `Gru recipe` is easy.

### Lets say we want to create a recipe for `mongodb`

1. Clone and simply copy the content of an existing directory into `mongodb` 

```bash

$ git clone https://github.com/<your_github_id>/gru.git

$ cd ~/gru/site

$ cp -r postgresql mongodb

$ cd mongodb

## change the name of postgresql to mongodb
$ mv postgresql.lua mongodb.lua

$ touch mongodb.lua

```

Once you've got the `Gru recipe in mongodb.lua` fixed you can run the gru project by using this command, e.g.

```bash

$ ~/gru/gulp/gructl apply  ~/gru/site/route/route.lua

```
