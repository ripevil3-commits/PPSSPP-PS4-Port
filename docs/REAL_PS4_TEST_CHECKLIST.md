# Real PS4 validation checklist

This checklist is the exit gate for calling PPSSPP-PS4 usable. A green GitHub Actions run or a linked SDL2 probe ELF is not sufficient.

## Gate 1 — Build evidence (CI)

- [ ] The full PPSSPP-derived target compiles and links; record the exact commit SHA.
- [ ] CI logs show the real PPSSPP build exit code as zero.
- [ ] The output is identified by file type and inspected; do not rename an ELF to SELF or PKG.
- [ ] SELF conversion and package creation use verified tools from the selected PS4 toolchain.
- [ ] The package includes a valid sce_sys/param.sfo, application metadata, and the expected eboot.
- [ ] The package is generated from the same commit whose build logs were reviewed.

## Gate 2 — Console installation (requires a compatible test PS4)

- [ ] Confirm the console model and system software are compatible with the homebrew package.
- [ ] Install only a package produced by the reviewed build; preserve any existing app and user data.
- [ ] Launch from the home screen and record whether it reaches the PPSSPP UI.
- [ ] Confirm clean exit and relaunch.
- [ ] Check that logs and configuration files are written to the intended app-data directory.

## Gate 3 — Emulator smoke test

Use a legally obtained homebrew test image or a game backup the tester owns. Do not bundle copyrighted games, firmware, BIOS, or keys in the repository or package.

- [ ] UI renders consistently; no black screen or crash.
- [ ] Controller input works for navigation and in-app controls.
- [ ] Audio initializes and plays without crashing.
- [ ] Load a small test image; confirm a frame is rendered and controls respond.
- [ ] Test pause/resume, exit to menu, and relaunch.
- [ ] Check save/config persistence across relaunch.
- [ ] Record performance, glitches, and any crash logs.

## Test report template

- Commit SHA:
- PS4 model:
- System software:
- Package filename and SHA-256:
- Install result:
- Launch result:
- UI / graphics:
- Controller:
- Audio:
- Test image and result:
- Logs attached:
- Known failures:

## Current status

As of this checklist's creation, this repository is still an experimental porting investigation. The actual PPSSPP build, SELF/PKG packaging, and on-console execution must each be verified before marking these gates complete. Hardware validation cannot be inferred from CI and requires a compatible physical PS4.
