#!/usr/bin/env bash
set -euo pipefail

cmake_file="${1:-_ppsspp-upstream/CMakeLists.txt}"
if [[ ! -f "$cmake_file" ]]; then
  echo "::error::PPSSPP CMakeLists.txt not found: $cmake_file"
  exit 1
fi

echo "Checking platform-sensitive upstream CMake decisions in $cmake_file"
grep -n -E 'CMAKE_SYSTEM_NAME.*Linux|if\(ANDROID OR WIN32 OR \(UNIX AND NOT ARM_NO_VULKAN\)\)|USING_X11_VULKAN|USE_WAYLAND_WSI|find_package\(OpenGL REQUIRED\)|find_package\(SDL2\)' "$cmake_file" || true

if grep -q 'if(ANDROID OR WIN32 OR (UNIX AND NOT ARM_NO_VULKAN))' "$cmake_file"; then
  echo "NOTICE: upstream enables Vulkan for broad UNIX targets; PS4 must explicitly opt out unless a PS4 Vulkan WSI/backend is implemented."
fi
if grep -q 'if(UNIX AND NOT (APPLE OR ANDROID) AND VULKAN)' "$cmake_file"; then
  echo "NOTICE: upstream may probe X11/Wayland/display Vulkan integration for UNIX targets; this needs a PS4-specific configuration."
fi
if grep -q 'find_package(OpenGL REQUIRED)' "$cmake_file"; then
  echo "NOTICE: upstream has an OpenGL package discovery path; OpenOrbis graphics libraries must not be assumed compatible with desktop OpenGL."
fi

echo "Platform decision inventory complete. This is a diagnostic, not a configure or build."
