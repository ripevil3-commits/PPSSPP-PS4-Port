# Upstream PPSSPP source audit

The CI workflow clones the upstream `v1.20.4` tag and runs
`scripts/audit-ppsspp-source.sh`. This is intentionally a small, repeatable
preflight check rather than a claim that upstream PPSSPP builds for PS4.

## What the check confirms

- The checked-out source identifies itself as the PPSSPP CMake project.
- Its top-level CMake configuration requests C++17.
- The expected `Core/`, `GPU/`, and `Common/` source directories exist.

## What remains unresolved

- PPSSPP does not have a ready-made OpenOrbis/PS4 platform target in this port.
- The upstream CMake configuration enables platform features based on broad
  operating-system tests; a PS4/FreeBSD-derived target must explicitly avoid
  accidentally enabling unsupported Linux/X11/Wayland/Vulkan paths.
- The PS4 graphics backend, controller and audio APIs, filesystem behavior,
  threading, JIT/code-generation constraints, and third-party library builds
  still require investigation and implementation.
- The SDL2 smoke program is project-owned test code, not PPSSPP's frontend.
- CI currently verifies only source layout plus compile/link of that small SDL2
  probe. It does not build PPSSPP, create a SELF/PKG, or verify execution on a
  console.

## Next engineering gate

Before adding PPSSPP source files to the PS4 build, establish a minimal target
configuration that can compile a small upstream PPSSPP translation unit with
the OpenOrbis compiler, then use compiler errors and dependency checks to decide
which platform abstractions and libraries need adaptation. Do not disable
graphics or system dependencies globally just to force CMake configuration to
pass; each choice needs to match an implemented backend.
