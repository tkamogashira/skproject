#ifndef libmw_src_util_h
#define libmw_src_util_h

  /* All symbols in this module are intentionally exported. */
  #ifdef _MSC_VER
      #define LIBMW_SRC_API __declspec(dllexport)
  #else
      #define LIBMW_SRC_API
  #endif

#endif /*libmw_src_util_h*/
