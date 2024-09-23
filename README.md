Fedora-based Image for Jekyll (Optionally with GitHub Pages)
============================================================

This project provides a Podman container image based on Fedora, designed for
local testing of Jekyll websites or blogs.

Optionally, your pages can depend on the **github-pages** package.  However,
note that you cannot specify `github-pages` in your `Gemfile` as `gem
'github-pages'` dependency.  This approach won’t work—the variant installed by
Bundler from the `Gemfile` is incompatible with the Fedora container base, which
uses Ruby >= 3.0.

In practice, the absence of this gem in `Gemfile` is not an issue because
(a) GitHub environment automatically installs it, and that is why
(b) this container image installs it automatically as well.

How to use the container
------------------------

Simple start can be done out-of-tree:

```
$ jekyll-host ~/home/you/your-project/jekyll-root
```

Get the "stub" script from from source:

```
$ curl https://raw.githubusercontent.com/praiskup/jekyll-github-pages-fedora-container/refs/heads/main/jekyll-host | tee ~/bin/jekyll-host
#! /bin/sh -x
podman run --rm -ti -p 4000:4000 -v "$1:/the-jekyll-root:z" quay.io/praiskup/github-pages
$ chmod +x ~/bin/jekyll-host
```

Or if you prefer direct run:

```
$ podman run --rm -ti -p 4000:4000 -v "$JEKYLL_ROOT:/the-jekyll-root:z" quay.io/praiskup/github-pages
```

This works well as git-submodule of your project:

```
$ cd <your jekyll pages root>

$ git submodule add --name testing-container https://github.com/praiskup/github-pages-fedora-container testing-container
Cloning into '/<your jekyll pages root>/testing-container'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 23 (delta 7), reused 23 (delta 7), pack-reused 0
Receiving objects: 100% (23/23), 14.77 KiB | 260.00 KiB/s, done.
Resolving deltas: 100% (7/7), done.

$ cd testing-container

$ make
jekyll_root=${JEKYLL_ROOT-`pwd`/..} ; \
rm -f "$jekyll_root"/Gemfile.lock
rm -f ../Gemfile.lock
jekyll_root=${JEKYLL_ROOT-`pwd`/..} ; \
podman run --rm -ti -p 4000:4000 -v $jekyll_root:/the-jekyll-root:z quay.io/praiskup/github-pages
+ : installing deps, may tay several minutes
+ bundler install
+ cat
+ bundler exec jekyll serve --drafts --port 5000 --incremental
=========================================
 Server listens on http://127.0.0.1:4000
=========================================
+ tinyproxy -d
```

Quit by `CTRL+C`.


Building the image locally?
---------------------------

See above, but just do `make run-local`.
