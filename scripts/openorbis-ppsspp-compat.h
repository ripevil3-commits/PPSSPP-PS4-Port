// Exploratory compile shim for OpenOrbis SDK header quirks.
// OpenOrbis math.h exposes isfinite as a macro rather than a usable
// std::isfinite declaration. Remove the macro and provide the narrow C++
// overload needed by the exploratory syntax-only check. This is not yet a
// production compatibility layer for a full PPSSPP build.
#include <math.h>
#ifdef isfinite
#undef isfinite
#endif
namespace std {
inline bool isfinite(double value) {
	return __builtin_isfinite(value);
}
}
