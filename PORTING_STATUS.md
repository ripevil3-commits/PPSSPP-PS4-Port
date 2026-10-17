# Porting status and next steps

Last updated: 2026-10-14

## Current state

This repository is an experimental porting investigation. It is not an official PPSSPP release and does not yet contain a working PS4 build.

- [x] Create a project repository.
- [x] Add an OpenOrbis CI smoke build.
- [x] Confirm that the OpenOrbis container can compile and link a PS4 ELF.
- [x] Add a project-owned minimal SDL2 probe source.
- [x] Audit upstream PPSSPP v1.20.4 source layout and C++17 configuration.
- [x] Add exploratory syntax-only checks for selected upstream PPSSPP translation units.
- [x] Confirm that eight selected upstream translation units pass the current OpenOrbis compiler syntax-only probe (CI run #37).
- [x] Add an exploratory compatibility shim that resolves the `JSONWriter.cpp` `isfinite` syntax issue in the probe (CI run #37); production integration still needs review.
- [x] Add an experimental OpenOrbis CMake toolchain starter and CI static audit for its key cross-compile settings.
- [x] Get upstream PPSSPP CMake configuration to complete in the diagnostic container (CI run #55).
- [ ] Compile/link actual PPSSPP targets with the experimental toolchain.
- [ ] Add a PS4-specific PPSSPP CMake target and compile/link actual PPSSPP objects, not only syntax-only probes.
- [ ] Restore packaging tools or provide a supported packaging environment for SELF/PKG generation.
- [ ] Validate a runnable build on a compatible PS4.
- [ ] Map PPSSPP's platform services to available PS4 APIs/libraries.
- [ ] Select and validate a graphics path before attempting the full emulator.
- [ ] Investigate audio, controller input, filesystem, threading, JIT/code generation, and third-party dependencies.
- [ ] Produce and test a PPSSPP-derived package on compatible hardware.

## Current CI milestone

The workflow builds `ps4-smoke/main.cpp`, a small SDL2 program maintained in this repository, using the OpenOrbis sample's compiler and link configuration. It checks for a linked ELF and uploads it as a short-lived Actions artifact.

A separate exploratory syntax-only pass checks eight upstream PPSSPP translation units. All eight passed in CI run #37 with an exploratory compatibility shim for the OpenOrbis `isfinite` issue. This is useful compatibility evidence, but syntax-only checks do not link PPSSPP or prove the whole project builds.

The CMake-enabled diagnostic container includes CMake, Make, binutils, and Python 3 for host-side configure steps. In CI run #55, PPSSPP's CMake configuration completed successfully after Python 3 was added. CMake reported optional or platform-specific dependencies such as Snappy, X11, ZLIB, and LIBZIP missing; configuration still generated build files. The workflow now attempts an actual build immediately after configuration and uploads the build log. The first build attempt (#58) was blocked by host-mounted directory permissions; that was fixed in the workflow. In run #60, CMake configured successfully and actual compilation began, but the first C++ target (`xbrz`) stopped in the OpenOrbis libc++ headers because global `abs` was not declared by the SDK's `math.h`. The compatibility shim now includes `<stdlib.h>` before `<math.h>` and is force-included by the experimental C++ toolchain. In runs #61-#63, the `abs` blocker was cleared and the build advanced to third-party C++ targets. New failures were identified: OpenOrbis `math.h` defines `isinf` and `isnan` macros that break upstream `std::isinf`/`std::isnan` calls, and armips' bundled `ghc::filesystem` rejects the FreeBSD-derived PS4 target as an unsupported operating system. The shim was updated to undefine those macros, but CI run #64 showed that OpenOrbis libc++'s `<random>` also expects a global `isinf` identifier. The shim now provides global `isfinite`, `isinf`, and `isnan` wrappers after removing the SDK macros; the next run will test whether this resolves both libc++ and upstream call sites. The armips filesystem target check remains unresolved. This diagnostic is allowed to fail while blockers are being identified.


The latest diagnostic build (#67) confirms the math-predicate shim now gets past the previous `isinf`/`isnan` blocker; compilation again reaches armips at about 24%. The current failure is `ghc::filesystem` not recognizing the SDK's FreeBSD-derived target because `BSD` is not exposed by its headers. The experimental C++ flags now define `BSD=199506` so armips can select its existing BSD/POSIX implementation. This is a targeted hypothesis, not yet validated; the next CI run must confirm it does not introduce new compatibility errors.


CI run #68 validated the `BSD=199506` experiment: armips now compiles and links successfully, and the overall build advanced to about 31%. The next blocker is in glslang, where upstream calls `std::isinf` and `std::isnan` but the OpenOrbis libc++ headers do not declare those functions after the SDK macros are removed. The compatibility shim now adds corresponding `std` wrappers as well as the global wrappers needed by libc++; CI must verify the fix. This is still an incomplete diagnostic build, not a runnable emulator.

An experimental CMake toolchain starter is at `cmake/ps4-openorbis-toolchain.cmake`. CI checks its required cross-compilation settings. Successful CMake configuration is only an initial milestone: it does not mean PPSSPP compiles, links, runs, or has a working PS4 graphics backend.

This is **not a PPSSPP build yet**. CI does not currently create an ELF-to-SELF conversion, a PKG, or a runnable install package. The CI container used so far did not include `create-fself`, so packaging remains a separate blocker. An ELF artifact is not proof of successful execution on PS4 hardware.

## Why the full port is non-trivial

PPSSPP is a large cross-platform C++ project. A PS4 port needs more than changing compiler flags: platform services, rendering, audio, controller input, filesystem behavior, generated machine code/JIT behavior, threading, and third-party dependencies all need to be evaluated. The existing source archives do not provide a ready-to-build PS4 target.

## Source projects

- PPSSPP: https://github.com/hrydgard/ppsspp
- OpenOrbis PS4 Toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
- OpenOrbis GitHub Actions helper: https://github.com/OpenOrbis/toolchain-action

Respect upstream licenses and third-party notices when importing or modifying code.


CI run #70 confirmed that the `std::isinf`/`std::isnan` wrappers let glslang compile substantially further; the build reached about 44%. The next blocker is another OpenOrbis `math.h` macro collision: `signbit` expands inside `std::signbit` in `Common/Arm64Emitter.cpp`. The exploratory compatibility shim now removes the `signbit` macro and supplies global and `std::` wrappers using the compiler builtin. This needs confirmation in the next CI run and remains a diagnostic-only workaround, not a production-ready SDK compatibility layer.


CI run #72 confirms the `signbit` macro workaround passed: `glslang` built successfully and the overall compilation reached about 50%. The next failure is an OpenOrbis socket header using `uint8_t` before it is declared. The compatibility shim now includes `<stdint.h>` early so the SDK socket header can see the fixed-width integer types; run #74 will test this targeted fix. These percentages are the CMake build's reported progress before the first blocking error, not a percentage of a finished, runnable PS4 port.

CI run #74 (after the `uint8_t` header adjustment) confirms that `uint8_t` is no longer the reported blocker and compilation reaches about 50%. Two independent diagnostic issues are now visible: the OpenOrbis `fpclassify` macro expands inside `std::fpclassify` in glslang, and the container lacks GLES2 development headers for the exploratory GLES2 source compile. The compatibility shim now undefines `fpclassify` and supplies narrow global/`std` wrappers; the diagnostic image now installs host GLES2 headers to let this source-compilation experiment proceed. These host headers are only for diagnostics and do not establish a PS4 GLES runtime or renderer. The next run must validate both changes; full PS4 graphics support is still unimplemented.

CI run #77 validated the `fpclassify` compatibility workaround: glslang's SPIR-V library now builds and the diagnostic build advances to about 51%. The GLES2 header is present in the OpenOrbis toolchain source checkout but not the installed SDK sysroot in the diagnostic image. Rather than use host Mesa headers for a PS4 target, the workflow now mounts the OpenOrbis source checkout read-only and adds its headers as an exploratory include path. This may let compilation proceed but does not provide or prove a PS4 GLES runtime/backend. The diagnostic remains non-production and must be rechecked in CI.


CI runs #79–#81 confirm the source-checkout include path alone did not resolve the GLES2 include failure: the build still stops in `Common/GPU/OpenGL/GLCommon.h` at `GLES2/gl2.h`, with `CMAKE_BUILD_EXIT=2` around 48–51%. The OpenOrbis repository tree does contain `include/GLES2/gl2.h`, so this is currently an include-path/mount diagnostic rather than evidence that a PS4 GLES runtime is available. The toolchain now also adds an explicit `-I/sdk-source/include` path, and CI checks that the header is actually visible inside the diagnostic container before attempting compilation. The next run will show whether the header is mounted and whether the compiler honors the path. The overall Actions check can still report success because this experimental full-build step is intentionally `continue-on-error`; use the `CMAKE_BUILD_EXIT` line as the build result.


Follow-up diagnosis after run #86: the missing GLES2 include is first reported while compiling `Common/GPU/OpenGL/gl3stub.c`, a C translation unit. The exploratory toolchain had added `/sdk-source/include` only to `CMAKE_CXX_FLAGS_INIT`, not `CMAKE_C_FLAGS_INIT`, so the header path was not consistently available to C compilation. Added the same source-header include paths to the C flags. This is a targeted hypothesis based on the failing translation unit; the next CI build must confirm whether it resolves the error.

## DolphinPS4 reference review (2026-10-17)

Reviewed the DolphinPS4 README, BUILDING.md, and PS4 CMake toolchain. Added [docs/DOLPHINPS4_REFERENCE.md](docs/DOLPHINPS4_REFERENCE.md) with transferable build lessons and a PPSSPP-specific follow-up checklist. The useful patterns are a separate target sysroot/runtime, explicit cross-toolchain and link configuration, small hardware/API probes, pinned upstream revisions, and a separately verified packaging pipeline. Dolphin's Mesa/RADV/GNM graphics implementation is not a drop-in PPSSPP backend. This reference review does not itself change the build status: the actual PPSSPP compile and PS4 runtime remain unverified until CI and hardware tests confirm them.
