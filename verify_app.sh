#!/bin/bash

echo "Verifying Ruby versions and Gemfile setup..."

echo "Installed Ruby versions:"
rvm list

for version in 2.7 3.0 3.1 3.2 3.3; do
  echo "Switching to Ruby $version..."
  rvm use $version --default
  ruby -v
  
  echo "Creating sample Ruby app..."
  mkdir -p /tmp/ruby_app
  cd /tmp/ruby_app

  echo "source 'https://rubygems.org'" > Gemfile
  echo "gem 'sinatra'" >> Gemfile

  echo "Installing Bundler and Sinatra gem..."
  gem install bundler && bundle install

  echo "Testing the Sinatra app..."
  echo "require 'sinatra'" > app.rb
  echo "get '/' do 'Hello from Ruby $version' end" >> app.rb

  ruby app.rb -o 0.0.0.0 -p 4567 &> /dev/null &
  sleep 2
  curl -s http://localhost:4567
  kill $!

  echo "Cleanup temporary Ruby app..."
  cd /tmp && rm -rf /tmp/ruby_app
done

echo "Verification complete."
