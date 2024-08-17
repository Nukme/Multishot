#!/bin/bash

USE_7Z=false

# First, check that the zip command is available
if command -v zip > /dev/null 2>&1; then
    echo "zip command is available."
else
    if command -v 7z > /dev/null 2>&1; then
        USE_7Z=true
    else
        echo "Error: A supported compression command (zip/7z) is not available."
        echo ""
        echo "If using Windows, consider installing 7zip with the Chocolately package manager (https://chocolatey.org/) command:"
        echo "  choco install 7zip"
        exit 1
    fi
fi

# Set the build and release directories
BUILD_DIR="./.build"
RELEASE_DIR="./.release"
MULTISHOT_DIR="$RELEASE_DIR/Multishot"

# Check if the build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "The build directory $BUILD_DIR does not exist."
    read -p "Would you like to run the build script (./build.sh) now? (y/n): " run_build
    if [[ "$run_build" == "y" || "$run_build" == "Y" ]]; then
        if [ -f "./build.sh" ]; then
            ./build.sh
            if [ $? -ne 0 ]; then
                echo "Error: Build script failed."
                exit 1
            fi
        else
            echo "Error: build.sh script not found."
            exit 1
        fi
    else
        echo "Build directory is required. Exiting."
        exit 1
    fi
fi

# Check if the release directory exists, and if so, empty it
if [ -d "$RELEASE_DIR" ]; then
    rm -rf "$RELEASE_DIR"/*
else
    mkdir "$RELEASE_DIR"
fi

# Create the Multishot directory within the release directory
mkdir -p "$MULTISHOT_DIR"

# Copy the contents of the build directory to the Multishot directory
cp -r "$BUILD_DIR/"* "$MULTISHOT_DIR/"

# Compress the contents of the Multishot directory
if [ "$USE_7Z" = false ]; then
    zip -r "$RELEASE_DIR/Multishot.zip" -j "$MULTISHOT_DIR"
else
    7z a "$RELEASE_DIR/Multishot.zip" "$MULTISHOT_DIR"
fi

# Done! Now delete the Multishot release dir
rm -rf "$MULTISHOT_DIR"

echo "Release created successfully at $RELEASE_DIR/Multishot.zip"
