// Exploratory compile shim for OpenOrbis SDK header quirks.
// OpenOrbis math.h exposes math predicates as macros rather than usable
// std:: declarations. Remove conflicting macros and provide narrow C++ wrappers
// for both libc++ and upstream call sites. This is not a production compatibility
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
#ifdef signbit
#undef signbit
#endif
inline int isfinite(double value) { return __builtin_isfinite(value); }
inline int isinf(double value) { return __builtin_isinf(value); }
inline int isnan(double value) { return __builtin_isnan(value); }
inline int signbit(double value) { return __builtin_signbit(value); }

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
inline bool signbit(double value) {
	return __builtin_signbit(value);
}
}
