# Gollum with PlantUML

## Why I put this together

* I wanted a way to record design decisions and collect technical reference information in a way that was portable and system/application independent.

* I wanted a Docker container that I could run in a private network and share with classes or working groups so that concerns and ideas could be collected organically with more fidelity than a sticky-note.

The result is what you have before you.  It is a simple Ruby wiki and PlantUML server combined with HAProxy joining both together on the same port.

## How to build it:

You will need:

* Docker
* ruby 2.3 or better with bundler installed
* a bash shell installed

Run `build.sh` in this folder to build the gollum image and verify it with serverspec.

## How to run the resulting gollum image:

If you simply want to run the wiki inside the Docker container and lose its contents when you are finished:

`docker run -d -p 4567:4567 gollum`

If you want to keep your wiki available between docker container runs, mount a git repository to the /gollum directory inside the container:

`docker run -d -p 4567:4567 -v your-wiki-git-repository:/gollum gollum`

In either case, browse to [your machine on port 4567](http://localhost:4567) to use the wiki.
