#!/bin/bash

# A simple script to copy the appropriate files into the build folder, so they can be packaged for release or immediately installed

# Set the build directory
BUILD_DIR="./.build"

# List of directories to copy
DIRECTORIES=("./art" "./libs" "./locales")

# List of files to copy
FILES=(
    "./LICENSE"
    "./Config.lua"
    "./dbBlacklist.lua"
    "./dbWhitelist.lua"
    "./Multishot.lua"
    "./Multishot.toc"
    "./bindings.xml"
)

# Function to check if all required files and directories exist
check_existence() {
    for item in "$@"; do
        if [ ! -e "$item" ]; then
            echo "Error: $item does not exist."
            exit 1
        fi
    done
}

# Check that all directories exist
check_existence "${DIRECTORIES[@]}"

# Check that all files exist
check_existence "${FILES[@]}"

# Create the build directory or empty it if it exists
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"/*
else
    mkdir "$BUILD_DIR"
fi

# Copy the directories
for dir in "${DIRECTORIES[@]}"; do
    cp -r "$dir" "$BUILD_DIR/"
done

# Copy the files
for file in "${FILES[@]}"; do
    cp "$file" "$BUILD_DIR/"
done

echo "Build completed successfully. Files copied to $BUILD_DIR."

read -p "Would you like to install the addon to the World of Warcraft AddOns folder? (y/n): " run_install
if [[ "$run_install" == "y" || "$run_install" == "Y" ]]; then
    if [ -f "./install.sh" ]; then
        ./install.sh
        if [ $? -ne 0 ]; then
            echo "Error: Install script failed."
            exit 1
        fi
    else
        echo "Error: install.sh script not found."
        exit 1
    fi
fi
