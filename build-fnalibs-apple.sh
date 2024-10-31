#!/bin/bash

set -ex

workflow_id=$(gh -R libsdl-org/SDL run list -b main --json databaseId --jq '.[0].databaseId')
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-macos-framework'
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-ios-arm64'
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-tvos-arm64'

workflow_id=$(gh -R FNA-XNA/FAudio run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-SDL3-osx'
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-SDL3-iphoneos'
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-SDL3-appletvos'

workflow_id=$(gh -R FNA-XNA/FNA3D run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-SDL3-osx'
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-SDL3-iphoneos'
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-SDL3-appletvos'

workflow_id=$(gh -R FNA-XNA/Theorafile run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-osx'
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-iphoneos'
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-appletvos'

mkdir -p fnalibs-apple
cp fnalibs-apple.README fnalibs-apple/README.txt

mkdir -p fnalibs-apple/osx
hdiutil attach SDL-macos-framework/dist/SDL3-3.1.5-macOS.dmg
cp /Volumes/SDL3\ 3.1.5/SDL3.framework/SDL3 fnalibs-apple-osx/libSDL3.0.dylib
install_name_tool -id "@rpath/libSDL3.0.dylib" fnalibs-apple-osx/libSDL3.0.dylib
hdiutil detach /Volumes/SDL3\ 3.1.5
mv FAudio-SDL3-osx/libFAudio.0.dylib fnalibs-apple/osx/
mv FNA3D-SDL3-osx/libFNA3D.0.dylib fnalibs-apple/osx/
mv Theorafile-osx/libtheorafile.dylib fnalibs-apple/osx/
xattr -c fnalibs-apple/osx/*.dylib

mkdir -p fnalibs-apple/iphoneos
tar xvfz SDL-ios-arm64/dist/SDL3-3.1.5-iOS.tar.gz SDL3-3.1.5-iOS/lib/libSDL3.a
mv SDL3-3.1.5-iOS/lib/libSDL3.a fnalibs-apple/iphoneos/
mv FAudio-SDL3-iphoneos/libFAudio.a fnalibs-apple/iphoneos/
mv FNA3D-SDL3-iphoneos/libFNA3D.a fnalibs-apple/iphoneos/
mv FNA3D-SDL3-iphoneos/libmojoshader.a fnalibs-apple/iphoneos/
mv Theorafile-iphoneos/libtheorafile.a fnalibs-apple/iphoneos/

mkdir -p fnalibs-apple/appletvos
tar xvfz SDL-tvos-arm64/dist/SDL3-3.1.5-tvOS.tar.gz SDL3-3.1.5-tvOS/lib/libSDL3.a
mv SDL3-3.1.5-tvOS/lib/libSDL3.a fnalibs-apple/appletvos/
mv FAudio-SDL3-appletvos/libFAudio.a fnalibs-apple/appletvos/
mv FNA3D-SDL3-appletvos/libFNA3D.a fnalibs-apple/appletvos/
mv FNA3D-SDL3-appletvos/libmojoshader.a fnalibs-apple/appletvos/
mv Theorafile-appletvos/libtheorafile.a fnalibs-apple/appletvos/
