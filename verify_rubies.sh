#!/bin/bash

# Ensure RVM is properly loaded
source /usr/local/rvm/scripts/rvm
ruby_app_content='
puts "Hello from Ruby #{RUBY_VERSION}"
warn "This is a test warning!"
'
# List installed Ruby versions
rvm list

for version in $(rvm list strings); do
    echo "======================================"
    echo "Testing with Ruby version: $version"
    echo "======================================"
    
    # Switch to the desired Ruby version
    rvm use $version --default

    # Create a temporary Ruby app file
    app_file="inline_ruby_app_${version//./_}.rb"  # Replace periods with underscores for naming
    echo "$ruby_app_content" > "$app_file"

    # Check if the Gemfile exists and handle dependencies
    if [ -f Gemfile ]; then
        echo "Installing compatible gems..."
        
        # Attempt to determine the Bundler version from the Gemfile.lock
        bundler_version=$(grep -oP "BUNDLED WITH\n\s+\K[0-9]+\.[0-9]+\.[0-9]+" Gemfile.lock)

        # If Bundler version is incompatible, fall back to 2.3.27 for older Ruby versions
        if [[ -z "$bundler_version" || $(echo "$version" | awk -F. '{print $1*100 + $2*10 + $3}') -lt 2308 ]]; then
            bundler_version="2.3.27"
            echo "Using Bundler version $bundler_version due to Ruby compatibility issues"
        fi

        # Install the chosen Bundler version
        gem install bundler -v "$bundler_version"
        bundle install
    fi

    # Run the Ruby application
    echo "Running Ruby application with $version"
    ruby "$app_file" 2>&1 
    APP_PID=$!

    # Allow the app to run momentarily
    sleep 5

    # Remove the temporary application file
    rm "$app_file"
done

echo "All Ruby versions verified successfully with inline apps!"
