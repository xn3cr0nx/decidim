#!/bin/bash

set -ex

sha1=${CIRCLE_SHA1:-latest}
latest_version=$(curl https://rubygems.org/api/v1/versions/decidim/latest.json | grep -o "[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*")
version=${DECIDIM_VERSION:-$latest_version}
extra_args=("$@")

docker build --file Dockerfile \
             --build-arg "decidim_version=$version" \
             --tag "xn3cr0nx/azione-decidim:$sha1" \
             --tag "xn3cr0nx/azione-decidim:$version" \
             --tag "xn3cr0nx/azione-decidim:latest" \
             "${extra_args[@]}" .

docker build --file Dockerfile-test \
             --build-arg "base_image=xn3cr0nx/azione-decidim:$sha1" \
             --build-arg "decidim_version=$version" \
             --tag "xn3cr0nx/azione-decidim:$sha1-test" \
             --tag "xn3cr0nx/azione-decidim:$version-test" \
             --tag "xn3cr0nx/azione-decidim:latest-test" \
             "${extra_args[@]}" .

docker build --file Dockerfile-dev \
             --build-arg "base_image=xn3cr0nx/azione-decidim:$sha1-test" \
             --tag "xn3cr0nx/azione-decidim:$sha1-dev" \
             --tag "xn3cr0nx/azione-decidim:$version-dev" \
             --tag "xn3cr0nx/azione-decidim:latest-dev" \
             "${extra_args[@]}" .

docker build --file Dockerfile-deploy \
             --build-arg "base_image=xn3cr0nx/azione-decidim:$sha1" \
             --tag "xn3cr0nx/azione-decidim:$sha1-deploy" \
             --tag "xn3cr0nx/azione-decidim:$version-deploy" \
             --tag "xn3cr0nx/azione-decidim:latest-deploy" \
             "${extra_args[@]}" .
