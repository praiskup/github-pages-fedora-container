Container Image for Jekyll writers
==================================

This project provides a container image based on Fedora distro, designed for
local testing of Jekyll websites or blogs.

Optionally, your pages can depend on the **github-pages** package.  However,
note that you cannot specify `github-pages` in your `Gemfile` as `gem
'github-pages'` dependency.  If you already do, drop the requirement.

In practice, the absence of this gem in `Gemfile` is not an issue because
(a) GitHub environment automatically installs it, and that is why
(b) this container image installs it automatically as well.

Background story, installing `github-pages` is a non-trivial task, especially on
Fedora which uses Ruby >= v3.0.


How to use the container
------------------------

Simple start can be done out-of-tree:

```
$ jekyll-host ~/home/you/your-project/jekyll-root
podman run --rm -ti -p 4000:4000 -v $jekyll_root:/the-jekyll-root:z jekyll
Installing deps, may take several minutes (see /tmp/bundler-install.log in container)
=========================================
 Server listens on http://127.0.0.1:4000
 Jekyll Log: /tmp/jekyll-server.log (in container)
 Install logs: /tmp/bundler-install.log (in container)
=========================================
```

Don't you have the `~/bin/jekyl-host` script yet?  Get the "stub" script from
from source:

```
$ curl https://raw.githubusercontent.com/praiskup/jekyll-container/refs/heads/main/jekyll-host | tee ~/bin/jekyll-host
#! /bin/sh -x
podman run --rm -ti -p 4000:4000 -v "$(readlink -f "$1"):/the-jekyll-root:z" quay.io/praiskup/jekyll
$ chmod +x ~/bin/jekyll-host
```

Or if you prefer direct run:

```
$ podman run --rm -ti -p 4000:4000 -v "$JEKYLL_ROOT:/the-jekyll-root:z" quay.io/praiskup/jekyll
```

This works well as git-submodule of your project:

```
$ cd <your jekyll pages root>

$ git submodule add --name testing-container https://github.com/praiskup/jekyll-container testing-container
Cloning into '/<your jekyll pages root>/testing-container'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 23 (delta 7), reused 23 (delta 7), pack-reused 0
Receiving objects: 100% (23/23), 14.77 KiB | 260.00 KiB/s, done.
Resolving deltas: 100% (7/7), done.

$ cd testing-container

$ make
...
=========================================
 Server listens on http://127.0.0.1:4000
 Jekyll Log: /tmp/jekyll-server.log (in container)
 Install logs: /tmp/bundler-install.log (in container)
=========================================
```

Quit by `CTRL+C`.


Building the image locally?
---------------------------

See above, but just do `make run-local`.
