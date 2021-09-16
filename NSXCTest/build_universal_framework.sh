#! /bin/sh

# create folder where we place built frameworks
mkdir build

####################### Create devices framework #############################

#build framework for devices
xcodebuild clean build \
  -project NSXCTest.xcodeproj \
  -scheme NSXCTest \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath derived_data \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# create folder to store compiled framework for simulator
mkdir build/devices

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphoneos/NSXCTest.framework build/devices

# build framework for simulators
xcodebuild clean build \
  -project NSXCTest.xcodeproj \
  -scheme NSXCTest \
  -configuration Release \
  -sdk iphonesimulator \
  -derivedDataPath derived_data \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

####################### Create simulator framework #############################

# create folder to store compiled framework for simulator
mkdir build/simulator

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphonesimulator/NSXCTest.framework build/simulator

####################### Create universal framework #############################

# create folder to store compiled universal framework
mkdir build/universal

# copy device framework into universal folder
cp -r build/devices/NSXCTest.framework build/universal/

# create framework binary compatible with simulators and devices, and replace binary in unviersal framework
lipo -create \
  build/simulator/NSXCTest.framework/NSXCTest \
  build/devices/NSXCTest.framework/NSXCTest \
  -output build/universal/NSXCTest.framework/NSXCTest

# copy simulator Swift public interface to universal framework
cp -r build/simulator/NSXCTest.framework/Modules/NSXCTest.swiftmodule/* build/universal/NSXCTest.framework/Modules/NSXCTest.swiftmodule
