# PPSSPP PS4 Port (experimental)

This repository tracks experimental work toward investigating whether PPSSPP can be ported to a homebrew application for PlayStation 4 using the OpenOrbis toolchain.

## Status

- [x] Create a project repository
- [x] Add a GitHub Actions workflow using the official OpenOrbis toolchain action to attempt an upstream SDL2 sample build/package
- [x] Record an initial source audit and technical milestones
- [ ] Verify that the hosted smoke build succeeds
- [ ] Build a minimal project-owned PS4 application
- [ ] Investigate graphics, input, audio, filesystem, threading, JIT/code generation, and dependency integration
- [ ] Prototype a minimal PPSSPP platform layer
- [ ] Produce and test a PPSSPP-derived package on compatible hardware

**No working PPSSPP PS4 PKG is available yet.** The smoke workflow builds an upstream sample only; it does not build PPSSPP. A successful sample build is not proof that PPSSPP itself builds or runs. Hardware testing will be required.

## Project notes

- [Porting status and milestones](PORTING_STATUS.md)
- [Source audit and porting assessment](docs/porting-assessment.md)
- [OpenOrbis smoke-build workflow](.github/workflows/openorbis-smoke.yml)
- [GitHub Actions runs](https://github.com/ripevil3-commits/PPSSPP-PS4-Port/actions)

## Source and licensing

PPSSPP is an open-source project licensed under GPL-2.0-or-later. Any port must preserve applicable notices and comply with the upstream license and third-party dependency licenses. This repository is an experimental porting effort and is not an official PPSSPP release.

Upstream project: https://github.com/hrydgard/ppsspp  
OpenOrbis toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain  
OpenOrbis action: https://github.com/OpenOrbis/toolchain-action
