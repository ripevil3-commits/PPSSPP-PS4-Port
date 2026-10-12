# PPSSPP to PS4: source audit

## Inputs reviewed

- PPSSPP 1.20.4 source archive provided for this project.
- OpenOrbis PS4 Toolchain source archive provided for this project.

## Findings verified from the source tree

1. PPSSPP uses C++17 for non-Android builds.
2. The desktop frontend's SDL version depends on the upstream revision; the supplied 1.20.4 configuration uses SDL3. The OpenOrbis sample environment is SDL2, so the APIs and frontend cannot be assumed interchangeable.
3. PPSSPP includes OpenGL/GLES and Vulkan graphics paths, but its source tree does not provide a ready-made PS4 target.
4. The OpenOrbis sample Makefile targets `x86_64-pc-freebsd12-elf`, links PS4 system stubs, and normally uses `create-fself` and packaging tools.
5. The hosted OpenOrbis container previously compiled and linked the upstream sample, but the container did not include `create-fself`. Packaging has therefore not been demonstrated.
6. The repository now has a small project-owned SDL2 probe at `ps4-smoke/main.cpp`. GitHub Actions run #18 passed its compile/link-only build. This validates only the probe's build path, not the emulator or runtime behavior.

## Proposed engineering sequence

### Phase 1 — validate the toolchain

- [x] Establish a successful OpenOrbis compile/link smoke test.
- [x] Add a project-owned SDL2 probe source.
- [x] Confirm the project-owned SDL2 probe passes in CI (run #18, commit `b0403476d93fb2fc4bf779ac6086e8ad330044a2`).
- [ ] Find a reproducible, compatible ELF-to-SELF/PKG packaging toolchain.
- [ ] Validate execution on compatible PS4 hardware.

### Phase 2 — map PPSSPP's platform dependencies

Identify the exact source and dependency boundaries for:
- frontend/window and event loop;
- graphics context, shader compilation, and presentation;
- audio output and mixing;
- controller input;
- filesystem paths and savedata;
- threads, synchronization, and memory mapping;
- JIT/code generation and executable-memory assumptions;
- third-party libraries and target support.

### Phase 3 — incremental port

Start with a reduced configuration and explicit platform definitions. Add one subsystem at a time, preserving upstream license notices and keeping each milestone independently testable. A compile-only milestone is not a runtime milestone.

## Current limitations

- No PPSSPP PS4 ELF, SELF, or PKG has been produced by this project.
- The project-owned SDL2 probe has not yet been verified as running on PS4 hardware.
- No physical-console test has been performed.
- Graphics compatibility, audio, input, filesystem integration, JIT behavior, and performance remain open questions.

## Licensing

PPSSPP is GPL-2.0-or-later. OpenOrbis and bundled components have their own licensing terms. Any code copied into this repository must retain its notices and comply with each applicable license.
