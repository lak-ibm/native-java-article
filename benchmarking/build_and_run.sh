#!/bin/bash

# === READ ARGS ===
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
JAVA_FILE="${BASE_NAME}.java"
CLASS_OUTPUT_DIR="build"
HEADER_OUTPUT_DIR="native"
NATIVE_SRC="native/${BASE_NAME}.c"
NATIVE_HELPER_SRC="native/helper_${BASE_NAME}.c"
LIB_NAME="native${BASE_NAME}"
LIB_OUTPUT="native/lib${LIB_NAME}.dylib"
LOCAL_NATIVE_OBJ="Local${BASE_NAME}"
LOCAL_NATIVE_SRC="${LOCAL_NATIVE_OBJ}.c"


# === ENV ===
echo "Using JAVA_HOME: $JAVA_HOME"

# === 1. Compile Java and generate header ===
echo "Compiling Java..."
mkdir -p "$CLASS_OUTPUT_DIR" "$HEADER_OUTPUT_DIR"
javac -h "$HEADER_OUTPUT_DIR" -d "$CLASS_OUTPUT_DIR" "$JAVA_FILE" || exit 1

# === 2. Compile native code into shared library ===
echo "Compiling C..."
gcc -arch x86_64 -dynamiclib \
    -o "$LIB_OUTPUT" -fPIC \
    -I"$JAVA_HOME/include" \
    -I"$JAVA_HOME/include/darwin" \
    "$NATIVE_SRC" "$NATIVE_HELPER_SRC"|| exit 1

# === 3. Getting bytecode ===
# Throwing warning but still generateing.... Warning: File ./build/benchmarking/Main.class does not contain class build/benchmarking/Main
javap -c -v $CLASS_OUTPUT_DIR/$PACKAGE_NAME/$BASE_NAME > $CLASS_OUTPUT_DIR/$PACKAGE_NAME/${BASE_NAME}_bytecode.txt

# === 4. Run Java app ===
# echo "Running Java program..."
java -cp "$CLASS_OUTPUT_DIR" -Djava.library.path="$HEADER_OUTPUT_DIR" $PACKAGE_NAME.$BASE_NAME 
gcc "$LOCAL_NATIVE_SRC" "$NATIVE_HELPER_SRC" -o "$LOCAL_NATIVE_OBJ"
./"$LOCAL_NATIVE_OBJ"

gcc -S "$NATIVE_HELPER_SRC" -o "build/${LOCAL_NATIVE_OBJ}_ARM_O0.s"
gcc -arch x86_64 -S "$NATIVE_HELPER_SRC" -o "build/${LOCAL_NATIVE_OBJ}_X86_O0.s"
gcc -arch x86_64 -O2 -S "$NATIVE_HELPER_SRC" -o "build/${LOCAL_NATIVE_OBJ}_X86_O2.s"
gcc -arch x86_64 -O3 -S "$NATIVE_HELPER_SRC" -o "build/${LOCAL_NATIVE_OBJ}_X86_O3.s"

