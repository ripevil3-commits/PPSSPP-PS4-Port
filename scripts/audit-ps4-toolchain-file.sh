#!/usr/bin/env bash
set -euo pipefail
file="${1:-cmake/ps4-openorbis-toolchain.cmake}"
test -f "$file" || { echo "::error::Missing experimental PS4 toolchain file: $file"; exit 1; }
grep -q 'OO_PS4_TOOLCHAIN' "$file"
grep -q 'CMAKE_SYSTEM_NAME FreeBSD' "$file"
grep -q 'x86_64-pc-freebsd12-elf' "$file"
grep -q 'CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY' "$file"
grep -qi 'not a complete PPSSPP build configuration' "$file"
echo "PASS: experimental OpenOrbis CMake toolchain starter contains required cross-compile settings and scope warning."
