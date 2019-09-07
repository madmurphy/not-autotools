Change Log
==========


0.2.0
-----

Changes:

* All M4 macros have been moved into the `m4` folder
* Created library files `not-automake.m4`, `not-autoshell.m4` and `not-misc.m4`
* Library file `not-m4.m4` has been renamed to `not-m4sugar.m4`
* New macros `nm4_case()`, `nm4_in()`, `nm4_in_args()`, `nm4_lambda()`,
  `nm4_switch()` and `nm4_unlambda` have been created in `not-m4sugar.m4`
* New macros `NM_ENVIRONMENT_KEYS` , `NM_GET_AM_VAR()` and `NM_LOAD_ENVIRONMENT`
  have been created in `not-automake.m4`
* New macros `NS_GETOUT()`, `NS_GETVAR()` and `NS_SETVAR()` have been created in
  `not-autoshell.m4`
* Macro † `NA_GET_LIB_VERSION_ENV()` has been renamed to
  `NM_SET_VERSION_ENVIRONMENT()` and has been moved to `not-misc.m4`
* Macros † `NA_ASK_REPLACEMENTS()`, † `NA_DEFINE_SUBSTRINGS_AS()`,
  † `NA_FOR_EACH_MATCH()`, † `NA_REGEXP_DEPTH()` and † `NA_REPEAT_TEXT()` in
  `not-m4sugar.m4` have been renamed to `nm4_get_replacements()`,
  `nm4_define_substrings_as()`, `nm4_for_each_match()`, `nm4_redepth()`, and
  `nm4_repeat()`
*  Code review
*  Examples



0.1.0
-----

**Not Autotools** has been published.

