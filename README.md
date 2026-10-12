# PPSSPP PS4 Port (experimental)

This repository tracks experimental work toward porting PPSSPP to a homebrew application for PlayStation 4 using the OpenOrbis toolchain.

## Status

- [x] Set up an OpenOrbis compile/link smoke workflow.
- [x] Add a project-owned minimal SDL2 probe in `ps4-smoke/main.cpp`.
- [x] Confirm the SDL2 probe compile/link build passes in GitHub Actions.
- [ ] Establish a reproducible ELF-to-SELF/PKG packaging environment.
- [ ] Test the probe on compatible PS4 hardware.
- [ ] Port PPSSPP's platform, graphics, audio, input, filesystem, threading, and JIT/dependency layers.

**There is no working PPSSPP PS4 PKG yet.** The CI probe is a tiny SDL2 test program and currently validates compile/link only; it is not the PPSSPP emulator, does not create an installable package, and has not been tested on a console.

## Project notes

- [Porting status and milestones](PORTING_STATUS.md)
- [Source audit and porting assessment](docs/porting-assessment.md)
- [OpenOrbis probe workflow](.github/workflows/openorbis-smoke.yml)
- [GitHub Actions runs](https://github.com/ripevil3-commits/PPSSPP-PS4-Port/actions)

## Source and licensing

PPSSPP is licensed under GPL-2.0-or-later. Any port must preserve applicable notices and comply with upstream and third-party dependency licenses. This repository is experimental and is not an official PPSSPP release.

Upstream projects:
- PPSSPP: https://github.com/hrydgard/ppsspp
- OpenOrbis PS4 Toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
