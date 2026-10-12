# Porting status and next steps

Last updated: 2026-10-13

## Current state

This repository is an experimental porting investigation. It is not an official PPSSPP release and does not yet contain a working PS4 build.

- [x] Create a project repository.
- [x] Add a GitHub Actions workflow using the official OpenOrbis toolchain action to attempt an upstream SDL2 sample build and package.
- [x] Record an initial source audit and technical milestones.
- [ ] Verify the latest GitHub Actions run and fix any environment/sample issues.
- [ ] Build a minimal project-owned PS4 application independent of PPSSPP.
- [ ] Confirm packaging and inspect the generated artifact.
- [ ] Map PPSSPP's platform services to available PS4 APIs/libraries.
- [ ] Select and validate a graphics path before attempting the full emulator.
- [ ] Investigate audio, controller input, filesystem, threading, JIT/code generation, and third-party dependencies.
- [ ] Produce and test a PPSSPP-derived package on compatible hardware.

## Important distinction

The smoke workflow is only an upstream OpenOrbis SDL2 sample check. It is not a PPSSPP build, and a successful sample build does not demonstrate that PPSSPP itself builds or runs. The workflow must finish successfully and its artifact must be inspected before the toolchain is considered validated.

## Why the port is non-trivial

PPSSPP is a large cross-platform C++ project. A PS4 port needs more than changing compiler flags: platform services, rendering, audio, controller input, filesystem behavior, generated machine code/JIT behavior, threading, and third-party dependencies all need to be evaluated. The existing source archives are useful references but do not by themselves provide a ready-to-build PS4 target.

## Source projects

- PPSSPP: https://github.com/hrydgard/ppsspp
- OpenOrbis PS4 Toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
- Official OpenOrbis GitHub Actions helper: https://github.com/OpenOrbis/toolchain-action

Respect upstream licenses and third-party notices when importing or modifying code.
