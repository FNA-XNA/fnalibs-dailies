#!/bin/bash


# Parse command line argument for pthread_enabled
pthread_enabled=false
while [[ $# -gt 0 ]]; do
	case $1 in
		--pthread-enabled)
			pthread_enabled=true
			shift
			;;
		*)
			echo "Unknown option: $1" >&2
			exit 1
			;;
	esac
done

source VERSIONS

set -ex


# build SDL3 for WebAssembly using Emscripten
git clone --depth 1 --branch release-3.4.x https://github.com/libsdl-org/SDL.git
cd SDL
mkdir emscripten-build
cd emscripten-build
CFLAGS=""
PTHREAD_FLAGS=""
PTHREAD_ENABLED="OFF"
if [ "$pthread_enabled" = true ]; then
	PTHREAD_FLAGS="-pthread"
	PTHREAD_ENABLED="ON"
fi
CFLAGS=$PTHREAD_FLAGS emcmake cmake -S .. \
-DSDL_WERROR=ON \
-DSDL_TESTS=OFF \
-DSDL_INSTALL_TESTS=OFF \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=prefix \
-DSDL_PTHREADS=$PTHREAD_ENABLED \
-DSDL_PTHREADS_SEM=$PTHREAD_ENABLED \
-GNinja
ninja

cd ../..

# TEMPORARY: use my own forks of these libraries until the PRs are merged and new releases are made
workflow_id=$(gh -R ValorZard/FAudio run list -b add-wasm-build --json databaseId --jq '.[0].databaseId')
if [[ $pthread_enabled == true ]]; then
    gh -R ValorZard/FAudio run download ${workflow_id} -p 'FAudio-wasm-mt'
else
    gh -R ValorZard/FAudio run download ${workflow_id} -p 'FAudio-wasm-st'
fi

workflow_id=$(gh -R ValorZard/FNA3D run list -b add-wasm --json databaseId --jq '.[0].databaseId')
if [[ $pthread_enabled == true ]]; then
    gh -R ValorZard/FNA3D run download ${workflow_id} -p 'FNA3D-wasm-mt'
else
    gh -R ValorZard/FNA3D run download ${workflow_id} -p 'FNA3D-wasm-st'
fi

# TODO: add a workflow for Theorafile as well, and download it here

mkdir -p fnalibs-wasm
#cp fnalibs-wasm.README fnalibs-wasm/README.txt
mv SDL/emscripten-build/libSDL3.a  fnalibs-wasm/
mv FAudio-wasm-*/libFAudio.a fnalibs-wasm/
mv FNA3D-wasm-*/libFNA3D.a fnalibs-wasm/

