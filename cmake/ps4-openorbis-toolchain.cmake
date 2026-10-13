# Experimental CMake cross-toolchain starter for PPSSPP/OpenOrbis.
# This is NOT a complete PPSSPP build configuration. Run CMake inside an
# environment that has the OpenOrbis SDK installed and OO_PS4_TOOLCHAIN set.
if(NOT DEFINED ENV{OO_PS4_TOOLCHAIN} OR "$ENV{OO_PS4_TOOLCHAIN}" STREQUAL "")
  message(FATAL_ERROR "OO_PS4_TOOLCHAIN must point to the installed OpenOrbis SDK sysroot")
endif()

set(OO_PS4_TOOLCHAIN "$ENV{OO_PS4_TOOLCHAIN}" CACHE PATH "OpenOrbis PS4 SDK root")

# OpenOrbis uses a FreeBSD-derived target triple. This system name is only a
# CMake cross-compilation hint; it does not mean desktop FreeBSD APIs exist.
set(CMAKE_SYSTEM_NAME FreeBSD)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

# CMake did not infer the archive utility from the OpenOrbis cross target.
# Resolve the LLVM binutils explicitly so its compiler sanity check can create
# static test archives inside the SDK container.
find_program(OPENORBIS_AR NAMES llvm-ar-12 llvm-ar ar)
find_program(OPENORBIS_RANLIB NAMES llvm-ranlib-12 llvm-ranlib ranlib)
find_program(OPENORBIS_NM NAMES llvm-nm-12 llvm-nm nm)
if(NOT OPENORBIS_AR OR NOT OPENORBIS_RANLIB)
  message(FATAL_ERROR "OpenOrbis CMake probe requires ar and ranlib (LLVM or GNU) in PATH")
endif()
set(CMAKE_AR "${OPENORBIS_AR}" CACHE FILEPATH "Archive tool")
set(CMAKE_RANLIB "${OPENORBIS_RANLIB}" CACHE FILEPATH "Archive index tool")
if(OPENORBIS_NM)
  set(CMAKE_NM "${OPENORBIS_NM}" CACHE FILEPATH "nm tool")
endif()
set(CMAKE_C_COMPILER_TARGET x86_64-pc-freebsd12-elf)
set(CMAKE_CXX_COMPILER_TARGET x86_64-pc-freebsd12-elf)

set(CMAKE_SYSROOT "${OO_PS4_TOOLCHAIN}")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_FLAGS_INIT "-fPIC -funwind-tables -D_GNU_SOURCE -D_POSIX_C_SOURCE=200809L -isystem ${OO_PS4_TOOLCHAIN}/include -I/sdk-source/include -isystem /sdk-source/include")
# OpenOrbis targets a FreeBSD-derived ABI, but this SDK's sys/param.h does not
# expose BSD for ghc::filesystem's OS detection. Define BSD only for C++ so
# armips can select its existing BSD/POSIX implementation; CI must validate it.
set(CMAKE_CXX_FLAGS_INIT "-fPIC -funwind-tables -D_GNU_SOURCE -D_POSIX_C_SOURCE=200809L -DBSD=199506 -std=c++17 -include /project/scripts/openorbis-ppsspp-compat.h -isystem ${OO_PS4_TOOLCHAIN}/include -I/sdk-source/include -isystem /sdk-source/include -isystem ${OO_PS4_TOOLCHAIN}/include/c++/v1")

# PPSSPP's upstream CMakeLists enables some desktop Unix graphics integrations
# automatically. Keep this toolchain file honest: it does not silently claim
# Vulkan/X11/Wayland/OpenGL support. A PS4 graphics backend and a matching
# PPSSPP target still need to be implemented before configuring the full app.
