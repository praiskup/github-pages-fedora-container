online_image=quay.io/praiskup/github-pages

run: clean-gemfile
	rm -f ../Gemfile.lock
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	podman run --rm -ti -p 4000:4000 -v $$jekyll_root:/the-jekyll-root:z $(online_image)

clean-gemfile:
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	rm -f "$$jekyll_root"/Gemfile.lock

run-local: clean-gemfile build
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	podman run --rm -ti -p 4000:4000 -v $$jekyll_root:/the-jekyll-root:z github-jekyll


build:
	podman build . -t github-jekyll
