#!/bin/bash
echo "Starting verification of Ruby app across all installed versions..."

source /etc/profile.d/rvm.sh

for version in $(rvm list strings); do
    echo "======================================"
    echo "Testing with Ruby version: $version"
    echo "======================================"
    
    # Use the specified Ruby version
    rvm use $version --default

    # Install dependencies from Gemfile
    echo "Installing gems..."
    bundle install

    # Run the Ruby application
    echo "Running Ruby application..."
    ruby app.rb &
    APP_PID=$!

    # Wait a few seconds to ensure the app starts
    sleep 5

    # Check if the application is running
    if ps -p $APP_PID > /dev/null; then
        echo "Application is running successfully with Ruby $version"
        kill $APP_PID
    else
        echo "Application failed to start with Ruby $version"
        exit 1
    fi
done

echo "All Ruby versions verified successfully!"
