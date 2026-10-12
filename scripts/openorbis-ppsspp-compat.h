// Exploratory compile shim for OpenOrbis SDK header quirks.
// OpenOrbis math.h defines isfinite as a macro, which breaks upstream
// expressions such as std::isfinite(value). Include the SDK header first,
// then undefine the macro so the C++ standard-library spelling can parse.
#include <math.h>
#ifdef isfinite
#undef isfinite
#endif
