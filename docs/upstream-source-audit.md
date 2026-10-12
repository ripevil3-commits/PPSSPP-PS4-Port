# Upstream PPSSPP source audit

The CI workflow clones the upstream `v1.20.4` tag and runs
`scripts/audit-ppsspp-source.sh`. This is intentionally a small, repeatable
preflight check rather than a claim that upstream PPSSPP builds for PS4.

## What the checks confirm

- The checked-out source identifies itself as the PPSSPP CMake project.
- Its top-level CMake configuration requests C++17.
- The expected `Core/`, `GPU/`, and `Common/` source directories exist.
- Selected upstream translation units can be parsed by the OpenOrbis compiler
  in syntax-only mode: `Common/Log/LogManager.cpp`,
  `Common/Data/Encoding/Base64.cpp`, `Common/Data/Encoding/Utf8.cpp`,
  `Common/Data/Format/JSONReader.cpp`, and `Common/File/Path.cpp`.
- `Common/Data/Format/JSONWriter.cpp` currently fails because the OpenOrbis
  SDK defines an `isfinite` macro in `math.h`, which collides with usage in
  the upstream source. The CI diagnostic log records the exact compiler errors.

These are individual syntax checks, not a linked PPSSPP build. The exploratory
script records failures but leaves the overall smoke workflow successful so
diagnostics can be uploaded and reviewed without hiding other results.

## What remains unresolved

- PPSSPP does not have a ready-made OpenOrbis/PS4 platform target in this port.
- The upstream CMake configuration enables platform features based on broad
  operating-system tests; a PS4/FreeBSD-derived target must explicitly avoid
  accidentally enabling unsupported Linux/X11/Wayland/Vulkan paths.
- The PS4 graphics backend, controller and audio APIs, filesystem behavior,
  threading, JIT/code-generation constraints, and third-party library builds
  still require investigation and implementation.
- The SDL2 smoke program is project-owned test code, not PPSSPP's frontend.
- CI does not build/link the PPSSPP application, create a SELF/PKG, or verify
  execution on a console.

## Next engineering gate

Resolve the SDK macro collision in a controlled way and add a PS4-specific
CMake/toolchain configuration that compiles actual upstream objects. Then
expand from small `Common/` translation units toward the real application
target, tracking missing dependencies and unsupported platform assumptions.
Do not disable graphics or system dependencies globally just to force CMake
configuration to pass; each choice needs to match an implemented backend.
