#!/usr/bin/env bash
set -uo pipefail

src="${1:-_ppsspp-upstream}"
toolchain="${2:-_openorbis-toolchain}"
log="${3:-upstream-translation-unit.log}"
test -f "$src/Common/Log/LogManager.cpp" || { echo "::error::Upstream LogManager.cpp not found"; exit 1; }
test -f "$toolchain/samples/SDL2/Makefile" || { echo "::error::OpenOrbis sample Makefile not found"; exit 1; }

# Exploratory syntax-only checks: these do not constitute a PPSSPP build.
# Keep trying all candidates so one platform incompatibility doesn't hide others.
overall=0
: > "$log"
for unit in \
  Common/Log/LogManager.cpp \
  Common/Data/Encoding/Base64.cpp \
  Common/Data/Encoding/Utf8.cpp \
  Common/Data/Format/JSONWriter.cpp \
  Common/Data/Format/JSONReader.cpp \
  Common/File/Path.cpp
do
  echo "===== $unit =====" | tee -a "$log"
  set +e
  docker run --rm \
    --volume "$PWD/$src:/ppsspp:ro" \
    --volume "$PWD/$toolchain:/workspace" \
    --workdir /workspace/samples/SDL2 \
    openorbisofficial/toolchain:latest \
    bash -lc "clang++ --target=x86_64-pc-freebsd12-elf -D_GNU_SOURCE -D_POSIX_C_SOURCE=200809L -std=c++17 -fPIC -fsyntax-only -isysroot \"\$OO_PS4_TOOLCHAIN\" -isystem \"\$OO_PS4_TOOLCHAIN/include\" -isystem \"\$OO_PS4_TOOLCHAIN/include/c++/v1\" -I/ppsspp -I/ppsspp/Common /ppsspp/$unit" 2>&1 | tee -a "$log"
  result=${PIPESTATUS[0]}
  set -e
  if [[ "$result" -eq 0 ]]; then
    echo "PASS: $unit" | tee -a "$log"
  else
    echo "FAIL: $unit (exit $result)" | tee -a "$log"
    overall=1
  fi
done

if [[ "$overall" -eq 0 ]]; then
  echo "PASS: all exploratory upstream translation units passed syntax-only compilation."
else
  echo "::warning::One or more exploratory upstream translation units failed. See uploaded log for diagnostics."
fi
exit 0
