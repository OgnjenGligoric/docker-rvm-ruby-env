#!/bin/bash
set -e

source /usr/local/rvm/scripts/rvm

for version in 2.3 2.4 2.5 2.6 2.7 3.0 3.1 3.2 3.3; do
    echo "Testing Ruby $version"
    rvm use $version --default
    bundle install
    ruby app.rb &
    APP_PID=$!
    sleep 2
    curl -s http://localhost:4567 | grep "Running Ruby $version"
    kill $APP_PID
done
