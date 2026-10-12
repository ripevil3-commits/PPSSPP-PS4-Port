#!/usr/bin/env bash
set -uo pipefail

src="${1:-_ppsspp-upstream}"
toolchain="${2:-_openorbis-toolchain}"
log="${3:-upstream-translation-unit.log}"
test -f "$src/Common/Log/LogManager.cpp" || { echo "::error::Upstream LogManager.cpp not found"; exit 1; }
test -f "$toolchain/samples/SDL2/Makefile" || { echo "::error::OpenOrbis sample Makefile not found"; exit 1; }

# This is deliberately an exploratory syntax-only compile. It must not be
# mistaken for a PPSSPP build, and its diagnostics are retained even on failure.
set +e
docker run --rm \
  --volume "$PWD/$src:/ppsspp:ro" \
  --volume "$PWD/$toolchain:/workspace" \
  --workdir /workspace/samples/SDL2 \
  openorbisofficial/toolchain:latest \
  bash -lc 'clang++ --target=x86_64-pc-freebsd12-elf -std=c++17 -fPIC -fsyntax-only -isysroot "$OO_PS4_TOOLCHAIN" -isystem "$OO_PS4_TOOLCHAIN/include" -isystem "$OO_PS4_TOOLCHAIN/include/c++/v1" -I/ppsspp -I/ppsspp/Common /ppsspp/Common/Log/LogManager.cpp' 2>&1 | tee "$log"
result=${PIPESTATUS[0]}
set -e
if [[ "$result" -eq 0 ]]; then
  echo "PASS: upstream LogManager.cpp passed syntax-only compilation with the OpenOrbis compiler."
else
  echo "::warning::Exploratory upstream translation-unit compile failed (exit $result). See uploaded log; this is expected to identify the next porting blocker."
fi
exit 0
