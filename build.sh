#!/bin/bash
#xcodebuild -project libjpeg-turbo-ios.xcodeproj -configuration Release -target turbojpeg  -sdk iphoneos9.0 clean || exit $?
xcodebuild -project libjpeg-turbo-ios.xcodeproj -configuration Release -target turbojpeg  -sdk iphoneos9.0 build || exit $?
#xcodebuild -project libjpeg-turbo-simulator.xcodeproj -configuration Release -target turbojpeg -arch i386 -sdk iphonesimulator6.0 build || exit $?

BUILD_FOLDER="build/Release-iphoneos/"
CURRENT_FOLDER=`pwd`

cd $BUILD_FOLDER
ls -lh

lipo -extract arm64 libjpeg.a -o libjpeg-amd64.a
lipo -extract armv7 libjpeg.a -o libjpeg-armv7.a

lipo -extract arm64 libturbojpeg.a -o libturbojpeg-amd64.a
lipo -extract armv7 libturbojpeg.a -o libturbojpeg-armv7.a

libtool -static libjpeg-armv7.a libturbojpeg-armv7.a libsimd-armv7.a -o libturbojpeg_full-armv7.a
libtool -static libjpeg-amd64.a libturbojpeg-amd64.a libsimd-arm64.a -o libturbojpeg_full-arm64.a


lipo -create libturbojpeg_full-armv7.a libturbojpeg_full-arm64.a -o libturbojpeg_full.a

cd $CURRENT_FOLDER

mkdir -p libturbojpeg.framework/Headers
cp $BUILD_FOLDER/libturbojpeg_full.a libturbojpeg.framework/libturbojpeg

cp  libjpeg/jerror.h      libturbojpeg.framework/Headers/
cp  libturbojpeg/jconfig.h     libturbojpeg.framework/Headers/
cp  libturbojpeg/jmorecfg.h    libturbojpeg.framework/Headers/
cp  libturbojpeg/jpeglib.h     libturbojpeg.framework/Headers/
cp  libturbojpeg/turbojpeg.h   libturbojpeg.framework/Headers/
