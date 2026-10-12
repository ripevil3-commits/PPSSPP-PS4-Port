# Porting status and next steps

Last updated: 2026-10-13

## Current state

This repository is an experimental porting investigation. It is not an official PPSSPP release and does not yet contain a working PS4 build.

- [x] Create a project repository.
- [x] Add a GitHub Actions workflow to download the OpenOrbis release and attempt an upstream SDL2 sample compile/link.
- [ ] Confirm the workflow passes on the hosted Linux runner.
- [ ] Record the exact toolchain release and build logs.
- [ ] Build a minimal PS4-native application that does not depend on PPSSPP.
- [ ] Map PPSSPP's platform services to available PS4 APIs/libraries.
- [ ] Select and validate a graphics path before attempting the full emulator.
- [ ] Investigate audio, controller input, filesystem, threading, JIT/code generation, and third-party dependencies.
- [ ] Produce a package and test it on compatible hardware.

## Important distinction

The smoke workflow is only an OpenOrbis sample check. It is not a PPSSPP build, and a successful compile/link does not demonstrate that the emulator can run on PS4. The workflow may initially fail if upstream release assets or packaging requirements change; use the Actions log as the source of truth.

## Why the port is non-trivial

PPSSPP is a large cross-platform C++ project. A PS4 port needs more than changing compiler flags: platform services, rendering, audio, controller input, filesystem behavior, threading, generated machine code/JIT behavior, and packaging all need to be evaluated. The existing source archives are useful references but do not by themselves provide a ready-to-build PS4 target.

## Source projects

- PPSSPP: https://github.com/hrydgard/ppsspp
- OpenOrbis PS4 Toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain

Respect upstream licenses and third-party notices when importing or modifying code.
