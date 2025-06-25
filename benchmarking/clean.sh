#!/bin/bash

# === READ ARGS ===
# CODE=$1
# if [ "$1" = "bm" ]; then
    BASE_NAME="Loop"
    PACKAGE_NAME="benchmarking"
# elif [ "$1" = "ma" ]; then
#     BASE_NAME="Mem"
#     PACKAGE_NAME="memalloc"
# elif [ "$1" = "sv" ]; then
#     BASE_NAME="TBD"
#     PACKAGE_NAME="stackvis"
#     exit 1
# elif [ "$1" = "sa" ]; then
#     BASE_NAME="TBS"
#     PACKAGE_NAME="sysaccess"
#     exit 1
# else
#   echo "Unknown command"
#   exit 1
# fi

# === CONFIG ===
# cd $PACKAGE_NAME
BUILD_DIR="build"
NATIVE_DIR="native"
LIB_FILE="libnative${BASE_NAME}.dylib"

echo "Cleaning up generated files..."

# Remove compiled Java classes
if [ -d "$BUILD_DIR" ]; then
    echo "Removing build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

# Remove generated JNI header files
if ls "$NATIVE_DIR"/*.h 1> /dev/null 2>&1; then
    echo "Removing JNI header files in $NATIVE_DIR"
    rm -f "$NATIVE_DIR"/$PACKAGE_NAME*.h
fi

# Remove compiled native library
if [ -f "$NATIVE_DIR/$LIB_FILE" ]; then
    echo "Removing native library: $NATIVE_DIR/$LIB_FILE"
    rm -f "$NATIVE_DIR/$LIB_FILE"
    rm -f "Local${BASE_NAME}"
fi

echo "Cleanup complete!"
