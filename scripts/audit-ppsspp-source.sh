#!/usr/bin/env bash
set -euo pipefail

src_dir="${1:-_ppsspp-upstream}"
cmake_file="$src_dir/CMakeLists.txt"

if [[ ! -f "$cmake_file" ]]; then
  echo "::error::PPSSPP source tree not found at $src_dir"
  exit 1
fi

echo "Auditing upstream PPSSPP source at: $src_dir"
grep -n -m 1 'project(PPSSPP' "$cmake_file"
if ! grep -Eq 'set\(CMAKE_CXX_STANDARD 17\)' "$cmake_file"; then
  echo "::error::Expected C++17 setting was not found in upstream CMakeLists.txt"
  exit 1
fi

for path in Core GPU Common; do
  if [[ ! -d "$src_dir/$path" ]]; then
    echo "::error::Expected PPSSPP source directory missing: $path"
    exit 1
  fi
  echo "Found source directory: $path/"
done

echo "PPSSPP source audit passed. This confirms source layout only; it does not build a PS4 target."
