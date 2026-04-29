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
workflow_id=$(gh -R FNA-XNA/FAudio run list -b add-wasm-build --json databaseId --jq '.[0].databaseId')
if [[ $pthread_enabled == true ]]; then
    gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-wasm-mt'
else
    gh -R FNA-XNA/FAudio run download ${workflow_id} -p 'FAudio-wasm-st'
fi

workflow_id=$(gh -R FNA-XNA/FNA3D run list -b add-wasm --json databaseId --jq '.[0].databaseId')
if [[ $pthread_enabled == true ]]; then
    gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-wasm-mt'
else
    gh -R FNA-XNA/FNA3D run download ${workflow_id} -p 'FNA3D-wasm-st'
fi

# TODO: add a workflow for Theorafile as well, and download it here

if [ "$pthread_enabled" = true ]; then
	OUTDIR=fnalibs-wasm-mt
else
	OUTDIR=fnalibs-wasm-st
fi
mkdir -p "$OUTDIR"
# Always copy README from script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/fnalibs-wasm.README" "$OUTDIR/README.txt"
cp SDL/emscripten-build/libSDL3.a  "$OUTDIR/SDL3.a"
cp FAudio-wasm-*/libFAudio.a "$OUTDIR/FAudio.a"
cp FNA3D-wasm-*/libFNA3D.a "$OUTDIR/FNA3D.a"
cp FNA3D-wasm-*/libmojoshader.a "$OUTDIR/libmojoshader.a"

