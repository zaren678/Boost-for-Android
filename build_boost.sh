#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "first argument should be ndk root"
fi

NDK_DIR=$1

PATH="$PATH:$NDK_DIR"

function build_one {
  ./build-android.sh --shared --toolchain=4.9 --android-abi=$ABI --android-platform=android-14 --boost=1.55.0 --with-libraries=atomic,random,date_time,filesystem,system,thread,chrono "${NDK_DIR}" || exit 1
  ./build-android.sh --toolchain=4.9 --android-abi=$ABI --android-platform=android-14 --boost=1.55.0 --with-libraries=atomic,random,date_time,filesystem,system,thread,chrono "${NDK_DIR}" || exit 1

  mkdir -p ./build/$ABI/lib
  mv ./build/lib/* ./build/$ABI/lib
  rmdir ./build/lib
}

./build-android.sh --clean || exit 1

ABI=armeabi-v7a
build_one

ABI=x86
build_one
