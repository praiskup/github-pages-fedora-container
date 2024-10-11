online_image=quay.io/praiskup/jekyll
local_image=jekyll

run: clean-gemfile
	rm -f ../Gemfile.lock
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	podman run --rm -ti -p 4000:4000 -v $$jekyll_root:/the-jekyll-root:z $(online_image)

clean-gemfile:
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	rm -f "$$jekyll_root"/Gemfile.lock

run-local: clean-gemfile build
	jekyll_root=$${JEKYLL_ROOT-`pwd`/..} ; \
	podman run --rm -ti -p 4000:4000 -v $$jekyll_root:/the-jekyll-root:z $(local_image)

push:
	podman push  $(local_image) $(online_image)


build:
	podman build . -t $(local_image)
