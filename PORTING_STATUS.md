# Porting status and next steps

Last updated: 2026-10-13

## Current state

This repository is an experimental porting investigation. It is not an official PPSSPP release and does not yet contain a working PS4 build.

- [x] Create a project repository.
- [x] Add an OpenOrbis CI smoke build.
- [x] Confirm that the OpenOrbis container can compile and link a PS4 ELF.
- [x] Add a project-owned minimal SDL2 probe source.
- [x] Audit upstream PPSSPP v1.20.4 source layout and C++17 configuration.
- [x] Add exploratory syntax-only checks for selected upstream PPSSPP translation units.
- [x] Confirm that `LogManager.cpp`, `Base64.cpp`, `Utf8.cpp`, `JSONReader.cpp`, and `Path.cpp` pass the current OpenOrbis compiler syntax-only probe (CI run #33).
- [ ] Resolve OpenOrbis SDK `isfinite` macro collision reported by `JSONWriter.cpp`.
- [ ] Add a PS4-specific PPSSPP CMake target and compile/link actual PPSSPP objects, not only syntax-only probes.
- [ ] Restore packaging tools or provide a supported packaging environment for SELF/PKG generation.
- [ ] Validate a runnable build on a compatible PS4.
- [ ] Map PPSSPP's platform services to available PS4 APIs/libraries.
- [ ] Select and validate a graphics path before attempting the full emulator.
- [ ] Investigate audio, controller input, filesystem, threading, JIT/code generation, and third-party dependencies.
- [ ] Produce and test a PPSSPP-derived package on compatible hardware.

## Current CI milestone

The workflow builds `ps4-smoke/main.cpp`, a small SDL2 program maintained in this repository, using the OpenOrbis sample's compiler and link configuration. It checks for a linked ELF and uploads it as a short-lived Actions artifact.

A separate exploratory syntax-only pass checks a handful of upstream PPSSPP translation units. Five of six currently pass; `JSONWriter.cpp` hits an `isfinite` macro collision from the OpenOrbis SDK's `math.h`. This is useful compatibility evidence, but syntax-only checks do not link PPSSPP or prove the whole project builds.

This is **not a PPSSPP build**. CI does not currently create an ELF-to-SELF conversion, a PKG, or a runnable install package. The CI container used so far did not include `create-fself`, so packaging remains a separate blocker. An ELF artifact is not proof of successful execution on PS4 hardware.

## Why the full port is non-trivial

PPSSPP is a large cross-platform C++ project. A PS4 port needs more than changing compiler flags: platform services, rendering, audio, controller input, filesystem behavior, generated machine code/JIT behavior, threading, and third-party dependencies all need to be evaluated. The existing source archives do not provide a ready-to-build PS4 target.

## Source projects

- PPSSPP: https://github.com/hrydgard/ppsspp
- OpenOrbis PS4 Toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
- OpenOrbis GitHub Actions helper: https://github.com/OpenOrbis/toolchain-action

Respect upstream licenses and third-party notices when importing or modifying code.
