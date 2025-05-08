#!/bin/bash

source VERSIONS

set -ex

workflow_id=$(gh -R libsdl-org/SDL run list -b release-3.2.x --json databaseId --jq '.[0].databaseId')
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-slrsniper'
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-VC-x86'
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-VC-x64'

workflow_id=$(gh -R libsdl-org/SDL run list -b main --json databaseId --jq '.[0].databaseId')
gh -R libsdl-org/SDL run download ${workflow_id} -p 'SDL-steamrt3-arm64'

workflow_id=$(gh -R FNA-XNA/FAudio run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-lib64'
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-libaarch64'
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-x86'
gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-x64'

workflow_id=$(gh -R FNA-XNA/FNA3D run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-lib64'
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-libaarch64'
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-x86'
gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-x64'

workflow_id=$(gh -R FNA-XNA/Theorafile run list -b master --json databaseId --jq '.[0].databaseId')
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-lib64'
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-libaarch64'
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-x86'
gh -R FNA-XNA/Theorafile run download ${workflow_id} -p 'Theorafile-x64'

mkdir -p fnalibs
cp fnalibs.README fnalibs/README.txt

mkdir -p fnalibs/lib64
tar xvfz SDL-slrsniper/dist/SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux.tar.gz SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux/lib/libSDL3.so.0.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION
mv SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux/lib/libSDL3.so.0.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION fnalibs/lib64/libSDL3.so.0
chmod +x fnalibs/lib64/libSDL3.so.0
strip -S fnalibs/lib64/libSDL3.so.0
mv FAudio-lib64/libFAudio.so.0 fnalibs/lib64/
mv FNA3D-lib64/libFNA3D.so.0 fnalibs/lib64/
mv Theorafile-lib64/libtheorafile.so fnalibs/lib64/

mkdir -p fnalibs/libaarch64
tar xvfz SDL-steamrt3-arm64/dist/SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux.tar.gz SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux/lib/libSDL3.so.0.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION
mv SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Linux/lib/libSDL3.so.0.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION fnalibs/libaarch64/libSDL3.so.0
chmod +x fnalibs/libaarch64/libSDL3.so.0
strip -S fnalibs/libaarch64/libSDL3.so.0
mv FAudio-libaarch64/libFAudio.so.0 fnalibs/libaarch64/
mv FNA3D-libaarch64/libFNA3D.so.0 fnalibs/libaarch64/
mv Theorafile-libaarch64/libtheorafile.so fnalibs/libaarch64/

mkdir -p fnalibs/x86
unzip SDL-VC-x86/dist/SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC.zip SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC/bin/SDL3.dll
mv SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC/bin/SDL3.dll fnalibs/x86/
mv FAudio-x86/FAudio.dll fnalibs/x86/
mv FNA3D-x86/FNA3D.dll fnalibs/x86/
mv Theorafile-x86/libtheorafile.dll fnalibs/x86/

mkdir -p fnalibs/x64
unzip SDL-VC-x64/dist/SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC.zip SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC/bin/SDL3.dll
mv SDL3-3.$SDL_MINOR_VERSION.$SDL_PATCH_VERSION-Windows-VC/bin/SDL3.dll fnalibs/x64/
mv FAudio-x64/FAudio.dll fnalibs/x64/
mv FNA3D-x64/FNA3D.dll fnalibs/x64/
mv Theorafile-x64/libtheorafile.dll fnalibs/x64/
