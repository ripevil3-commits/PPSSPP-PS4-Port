// Exploratory compile shim for OpenOrbis SDK header quirks.
// OpenOrbis math.h exposes isfinite/isinf/isnan as macros rather than usable
// std:: declarations. Remove the macros and provide narrow C++ wrappers for
// both libc++ and upstream call sites. This is not a production compatibility
// layer for a full PPSSPP build.
#include <stdlib.h>
#include <math.h>
#ifdef isfinite
#undef isfinite
#endif
#ifdef isinf
#undef isinf
#endif
#ifdef isnan
#undef isnan
#endif
inline int isfinite(double value) { return __builtin_isfinite(value); }
inline int isinf(double value) { return __builtin_isinf(value); }
inline int isnan(double value) { return __builtin_isnan(value); }

namespace std {
inline bool isfinite(double value) {
	return __builtin_isfinite(value);
}
inline bool isinf(double value) {
	return __builtin_isinf(value);
}
inline bool isnan(double value) {
	return __builtin_isnan(value);
}
}
