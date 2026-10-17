# DolphinPS4 reference notes for PPSSPP-PS4-Port

Last reviewed: 2026-10-17

Reference project: https://github.com/iHaiDeeZ/DolphinPS4

## Why this is a useful reference

DolphinPS4 demonstrates a real PS4 homebrew emulator port built around a repeatable cross-compilation toolchain, a PS4-specific runtime layer, a graphics stack, and explicit package generation. Its build documentation describes Clang/LLVM, OpenOrbis, a separate target sysroot, CMake/Ninja, and a package output directory.

This is an engineering reference, not a drop-in implementation for PPSSPP. Dolphin and PPSSPP have different dependencies, renderer assumptions, CPU/JIT behavior, and emulator APIs.

## Lessons to apply to this repository

1. **Separate the target sysroot from the base SDK.** DolphinPS4 builds a dedicated libc++/runtime sysroot and places its headers and libraries ahead of the base OpenOrbis paths. Our current experimental toolchain still relies on the SDK's C++ headers and a compatibility shim. Before importing a newer C++ runtime, first identify the exact ABI and runtime requirements and add a reproducible build step with CI evidence.
2. **Use an explicit, project-owned CMake toolchain.** Set the target triple, compiler, archiver, ranlib, sysroot, link flags, CRT objects, and library order deliberately. Do not copy Dolphin's exact values blindly; verify each one against PPSSPP and the SDK version used by our CI.
3. **Make the runtime boundary visible.** DolphinPS4 has a dedicated `port/` layer for PS4 runtime services and a separate Mesa/GNM graphics integration. PPSSPP likewise needs explicit platform adapters for application startup, filesystem, input, audio, threading, timing, and graphics.
4. **Treat graphics as a major milestone of its own.** DolphinPS4's renderer depends on a substantial Mesa RADV/Vulkan port and GNM winsys. That does not mean PPSSPP can use the same renderer automatically. First audit PPSSPP's renderer interfaces and select a feasible backend; do not claim GLES/Vulkan works merely because headers compile.
5. **Probe small components before building the whole emulator.** DolphinPS4 maintains probe applications for toolchain, Vulkan, and GNM bring-up. We should similarly add small independent probes for SDL2 startup, controller/input APIs, audio output, and whichever graphics path is selected.
6. **Package only after the executable is valid.** DolphinPS4 documents an explicit ELF-to-SELF and package pipeline. Our workflow must verify that the required packaging tools exist, fail clearly when they do not, and retain the logs/artifacts. A green workflow with a diagnostic step marked `continue-on-error` is not proof that PPSSPP built.
7. **Pin upstream source revisions and patches.** DolphinPS4 records the upstream revision its patch targets. Our eventual PPSSPP port should record the exact PPSSPP revision and keep PS4-specific changes reviewable rather than silently tracking moving upstream code.
8. **Keep hardware validation separate from CI.** A successful compile or package does not prove it launches on a GoldHEN-enabled PS4. Track package creation, installation, startup, input, graphics, audio, and game execution as separate milestones.

## Immediate PPSSPP work plan

- [ ] Check the latest CI run after the C include-path correction and inspect the first actual compiler error.
- [ ] Fix the earliest reproducible blocker; do not add speculative compatibility flags without log evidence.
- [ ] Audit the PPSSPP source tree for platform-specific startup, graphics, audio, controller, filesystem, threading, and JIT assumptions.
- [ ] Build a minimal PS4 app/probe independently from PPSSPP and validate ELF/SELF/PKG packaging tools in CI.
- [ ] Choose a renderer only after the source audit; define a small graphics probe before attempting to integrate the full renderer.
- [ ] Record each milestone with the exact CI run, commit, command, and result.

## Licensing and reuse

Use this document as a technical reference checklist. Before copying source code, scripts, patches, or assets from DolphinPS4, review its GPL-2.0-or-later license, preserve required notices, and evaluate compatibility with PPSSPP and every affected dependency. Prefer learning from build structure and reproducing the needed behavior in a clearly documented, compatible way.

## Sources

- DolphinPS4 README: https://github.com/iHaiDeeZ/DolphinPS4
- DolphinPS4 build guide: https://github.com/iHaiDeeZ/DolphinPS4/blob/main/BUILDING.md
- DolphinPS4 CMake toolchain: https://github.com/iHaiDeeZ/DolphinPS4/blob/main/toolchain/ps4-dolphin.cmake
- OpenOrbis toolchain: https://github.com/OpenOrbis/OpenOrbis-PS4-Toolchain
