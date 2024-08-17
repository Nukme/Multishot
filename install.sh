#!/bin/bash

# Set the source directory (build directory)
SRC_DIR="./.build"

# Determine the destination directory based on the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEST_DIR="$HOME/Applications/World of Warcraft/_retail_/Interface/Addons/Multishot"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    # Windows (assuming WSL or Git Bash)
    DEST_DIR="/w/World of Warcraft/_retail_/Interface/AddOns/Multishot"
else
    echo "Error: Unsupported OS."
    exit 1
fi

# Check if the build directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Build directory $SRC_DIR does not exist."
    exit 1
fi

# Check if the destination directory exists
if [ -d "$DEST_DIR" ]; then
    # If it exists, delete its contents
    rm -rf "$DEST_DIR"/*
else
    # If it doesn't exist, create it
    mkdir -p "$DEST_DIR"
fi

# Copy the contents of the build directory to the destination
cp -r "$SRC_DIR/"* "$DEST_DIR/"

echo "Files copied successfully to $DEST_DIR"