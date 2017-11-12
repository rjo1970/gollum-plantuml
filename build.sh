#!/usr/bin/env bash

echo "Installing rspec/serverspec dependencies..."
bundle install

echo "Creating docker image gollum"
docker build -t gollum .

echo "Running specs"
rspec spec/Dockerfile_spec.rb
