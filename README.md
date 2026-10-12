# PPSSPP PS4 Port (experimental)

This repository tracks experimental work toward investigating whether PPSSPP can be ported to a homebrew application for PlayStation 4 using the OpenOrbis toolchain.

## Status

- [x] Create project repository and initial plan
- [x] Add a GitHub Actions smoke-build workflow for the OpenOrbis SDL2 sample
- [x] Record an initial source audit and technical milestones
- [ ] Confirm the hosted OpenOrbis sample build passes
- [ ] Build a minimal project-owned PS4 application
- [ ] Investigate graphics, input, audio, filesystem, threading, and JIT/code-generation integration
- [ ] Prototype a minimal PPSSPP platform layer
- [ ] Produce and test a package on compatible hardware

**No working PPSSPP PS4 PKG is available yet.** The workflow is only intended to validate the toolchain and a sample; it does not build PPSSPP. A successful sample build is not proof that PPSSPP itself builds or runs. Hardware testing will be required.

## Project notes

- [Porting status and milestones](PORTING_STATUS.md)
- [Source audit and porting assessment](docs/porting-assessment.md)
- [OpenOrbis smoke-build workflow](.github/workflows/openorbis-smoke.yml)

## Source and licensing

PPSSPP is an open-source project licensed under GPL-2.0-or-later. Any port must preserve applicable notices and comply with the upstream license and third-party dependency licenses. This repository is an experimental porting effort and is not an official PPSSPP release.

Upstream project: https://github.com/hrydgard/ppsspp  
OpenOrbis toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
