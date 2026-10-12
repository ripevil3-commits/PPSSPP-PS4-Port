# PPSSPP to PS4: source audit

## Inputs reviewed

- PPSSPP source archive provided for this project; its README identifies the source as PPSSPP 1.20.4.
- OpenOrbis PS4 Toolchain source archive provided for this project; its README describes the toolchain as beta and explains that a prebuilt release or a separate toolchain build is required.

## Findings verified from the source tree

1. PPSSPP's top-level CMake configuration sets C++17 for non-Android builds.
2. The existing desktop frontend uses SDL3 in the current CMake configuration; the OpenOrbis sample in the supplied toolchain archive is an SDL2 sample. This means SDL2 and SDL3 should not be treated as interchangeable without porting work.
3. PPSSPP's graphics setup includes OpenGL/GLES and Vulkan paths, but its current CMake configuration does not define a ready-made PS4 target.
4. The OpenOrbis SDL2 sample Makefile targets x86_64-pc-freebsd12-elf, links PS4 system stubs, and invokes create-fself to generate eboot.bin. Its default target also invokes packaging tools.
5. The OpenOrbis source archive README states that the release package/prebuilt binaries are needed unless developers build the toolchain and its dependencies themselves.

## Proposed engineering sequence

### Phase 1 — validate the toolchain

The GitHub Actions workflow attempts to download an OpenOrbis release, locate its Linux tools and SDL2 sample, and compile/link that sample. The result of this hosted run must be checked before claiming that the environment works.

### Phase 2 — establish a minimal application

Once the sample smoke test passes, create a small project-owned test application with a unique title ID, then validate the ELF/SELF/PKG packaging chain separately. Keep the upstream sample unmodified where possible.

### Phase 3 — isolate PPSSPP platform dependencies

Before importing the entire emulator into a PS4 build, identify the exact source and dependency boundaries for:
- frontend/window and event loop;
- graphics context, shader compilation, and presentation;
- audio output and mixing;
- controller input;
- filesystem paths and savedata;
- threads, synchronization, and memory mapping;
- JIT/code generation and executable memory assumptions;
- third-party libraries and their target support.

### Phase 4 — incremental port

Start with a reduced configuration and explicit compile-time platform definitions. Add one subsystem at a time, keeping logs and small commits. A compile-only milestone is not a runtime milestone.

## Current limitations

- No PPSSPP PS4 ELF, SELF, or PKG has been produced by this project yet.
- No hosted smoke-build result has been verified in this report.
- No test on a physical PS4 has been performed.
- Graphics compatibility and performance remain open research questions; the OpenOrbis project itself describes GPU support as part of its roadmap.

## Licensing

PPSSPP is GPL-2.0-or-later. OpenOrbis and the bundled components have their own licensing terms. Any code copied into this repository must retain its notices and comply with each applicable license.
