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
HOST_ARCH="arm64"
JVM_ARCH="arm64"
OPT_LEVEL="2"
MARCH_FLAG="" # "-mcpu=apple-m2"

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
# echo "Using JAVA_HOME: $JAVA_HOME"

# === 1. Compile Java and generate header ===
echo "Compiling Java..."
mkdir -p "$CLASS_OUTPUT_DIR" "$HEADER_OUTPUT_DIR"
javac -h "$HEADER_OUTPUT_DIR" -d "$CLASS_OUTPUT_DIR" "$JAVA_FILE" || exit 1

# === 2. Compile native code into shared library ===
echo "Compiling C with optimization level ${OPT_LEVEL}..."
gcc -arch $JVM_ARCH \
    $MARCH_FLAG \
    -O$OPT_LEVEL -dynamiclib \
    -o "$LIB_OUTPUT" -fPIC \
    -I"$JAVA_HOME/include" \
    -I"$JAVA_HOME/include/darwin" \
    "$NATIVE_SRC" "$NATIVE_HELPER_SRC"|| exit 1

# === 3. Getting bytecode ===
# Throwing warning but still generateing.... Warning: File ./build/benchmarking/Main.class does not contain class build/benchmarking/Main
javap -c -v $CLASS_OUTPUT_DIR/$PACKAGE_NAME/$BASE_NAME > $CLASS_OUTPUT_DIR/$PACKAGE_NAME/${BASE_NAME}_bytecode.txt

# === 4. Run Java app ===
echo "Running programs..."
echo ""
java -cp "$CLASS_OUTPUT_DIR" -Djava.library.path="$HEADER_OUTPUT_DIR" $PACKAGE_NAME.$BASE_NAME 
gcc -arch ${HOST_ARCH} $MARCH_FLAG -O$OPT_LEVEL "$LOCAL_NATIVE_SRC" "$NATIVE_HELPER_SRC" -o "$LOCAL_NATIVE_OBJ"
./"$LOCAL_NATIVE_OBJ"

# === 4. Generate LLVM IR and Assembly ===
gcc -arch ${HOST_ARCH} -S "$NATIVE_HELPER_SRC" \
    -o "build/${LOCAL_NATIVE_OBJ}_${HOST_ARCH}_O0.s"

gcc -arch ${HOST_ARCH} -S -emit-llvm "$NATIVE_HELPER_SRC" \
    -o "build/${LOCAL_NATIVE_OBJ}_${HOST_ARCH}_O0.ll"

gcc -arch ${HOST_ARCH} $MARCH_FLAG -O$OPT_LEVEL -S "$NATIVE_HELPER_SRC" \
    -o "build/${LOCAL_NATIVE_OBJ}_${HOST_ARCH}_O${OPT_LEVEL}.s"

gcc -arch ${HOST_ARCH} $MARCH_FLAG -O$OPT_LEVEL -S -emit-llvm "$NATIVE_HELPER_SRC" \
    -o "build/${LOCAL_NATIVE_OBJ}_${HOST_ARCH}_O${OPT_LEVEL}.ll"

