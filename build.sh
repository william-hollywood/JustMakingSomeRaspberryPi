#!/bin/bash

PICO_SDK_PATH=~/pico-sdk/

mkdir build
pushd build

cmake ..

make

popd
