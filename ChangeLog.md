Change Log
==========


0.8.0
-----

Changes:

* New macro `n4_mem()` has been created in `not-m4sugar.m4`
* Library file † `not-misc.m4` has been renamed to `not-multiversion.m4`
* Code review (`NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`: removed
  dependency to `n4_lambda()`; `NM_SET_VERSION_ENVIRONMENT` in
  `not-multiversion.m4`: added support for a permanent and a temporary
  multi-version state using the `multiversion.lock` and `multiversion.templock`
  files; `NA_HELP_STRINGS()` in `not-autotools.m4`: harmonized the behavior of
  the passed lists; `NS_UNSET()` in `not-autoshell.m4`: added call to
  `m4_normalize()` on the variable names)
* Documentation


0.7.1
-----

Changes:

* Code review (`NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`)


0.7.0
-----

Changes:

* New macro `NA_HELP_STRINGS()` has been created in `not-autotools.m4`
* Code review (`NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`)
* Macro † `NA_SET_GLOBALLY()` in `not-autotools.m4` has been renamed to
  `NC_SET_GLOBALLY()`
* Documentation


0.6.0
-----

Changes:

* New library files `not-ac-messages.m4`, `not-extended-config.m4` and
  `not-utf8.m4` have been created, containing the following new macros:
  `NC_MSG_ERRORBOX()`, `NC_MSG_FAILUREBOX()`, `NC_MSG_NOTICEBOX()` and
  `NC_MSG_WARNBOX()` (`not-ac-messages.m4`); `NC_CONFIG_SHADOW_DIR()`,
  `NC_SHADOW_MAYBE_OUTPUT`, `NC_THREATEN_BLINDLY` and `NC_THREATEN_FILES()`
  (`not-extended-config.m4`); `n4_charcode()`, `n4_codeunit_at()`,
  `n4_codepoint_to_ascii()`, `n4_escape_non_ascii()` and
  `n4_escape_everything()` (`not-utf8.m4`);
* New macros `n4_let()`, `n4_qlet()` and `n4_with()` have been created in
  `not-m4sugar.m4`
* New macros `NS_SETVARS()` and `NS_UNSET()` have been created in
  `not-autoshell.m4`
* Macros † `NA_REQ_PROGS()` and † `NA_GET_PROGS()` in `not-autotools.m4` have
  been renamed to `NC_REQ_PROGS()` and `NC_GET_PROGS()`
* Code review (macros `NM_ENVIRONMENT_KEYS` and `NM_LOAD_ENVIRONMENT` in
  `not-automake.m4`; macro `NM_SET_VERSION_ENVIRONMENT()` in † `not-misc.m4` --
  the new version of the latter is incompatible with previous versions)
* Documentation


0.5.0
-----

Changes:

* New macro `n4_burn_out()`  has been created in `not-m4sugar.m4`
* Code review (macro `NM_LOAD_ENVIRONMENT()` in `not-automake.m4`, macro
  † `NA_SET_GLOBALLY()` in `not-autotools.m4`)
* Documentation


0.4.0
-----

Changes:

* Macro † `NA_SET_GLOBALLY()` in `not-autotools.m4` has been made variadic
* Code review (macros † `NA_GET_PROGS()`, † `NA_REQ_PROGS()` and
  `NA_SANITIZE_VARNAME()` in `not-autotools.m4`; macros `n4_case_in()`,
  `n4_define_substrings_as()`, `n4_for_each_match()`, `n4_get_replacements()`,
  `n4_list_index()` and `n4_repeat()` in `not-m4sugar.m4`)
* Documentation


0.3.2
-----

Changes:

* Macro † `NA_UP_WORDS_ONLY()` in `not-autotools.m4` has been renamed to
  `NA_SANITIZE_VARNAME()` and prevented from doing case transformations
* Code review (macros † `NA_GET_PROGS()` and † `NA_REQ_PROGS()` in
  `not-autotools.m4`)
* Documentation


0.3.1
-----

Changes:

* Implementation of macro `n4_lambda()` has been simplified
* Documentation


0.3.0
-----

Changes:

* Macro † `nm4_unlambda` has been removed from `not-m4sugar.m4` -- lambda
  macros are now safely created without polluting the global scope
* M4sugar clones † `nm4_switch()` and † `nm4_case()` have been removed from
  `not-m4sugar.m4` (they were clones of `m4_case()` and `m4_bmatch()`
  respectively)
* Reduntant macros † `nm4_in()` and † `nm4_in_args()` have been removed from
  `not-m4sugar.m4`
* The _Not M4sugar_ prefix † `nm4_` has been changed to `n4_`
* Macros `n4_case_in()` and `n4_list_index()` have been created in
  `not-m4sugar.m4`
* Macros `n4_get_replacements()` and `n4_for_each_match()` in `not-m4sugar.m4`
  (formerly † `n4_get_replacements()` and † `n4_for_each_match()`) no longer
  depend on `n4_repeat()`, but on GNU `m4_for()` instead
* Macro `n4_define_substrings_as()` in `not-m4sugar.m4` (formerly
  † `nm4_define_substrings_as()`) has been re-implemented using a more
  efficient algorithm (removed recursion, removed multiple calls to
  `m4_bregexp()`)
* Code review
* Examples


0.2.0
-----

Changes:

* All M4 macros have been moved into the `m4` folder
* Created library files `not-automake.m4`, `not-autoshell.m4` and
  † `not-misc.m4`
* Library file † `not-m4.m4` has been renamed to `not-m4sugar.m4`
* New macros `nm4_case()`, `nm4_in()`, `nm4_in_args()`, `nm4_lambda()`,
  `nm4_switch()` and `nm4_unlambda` have been created in `not-m4sugar.m4`
* New macros `NM_ENVIRONMENT_KEYS`, `NM_GET_AM_VAR()` and `NM_LOAD_ENVIRONMENT`
  have been created in `not-automake.m4`
* New macros `NS_GETOUT()`, `NS_GETVAR()` and `NS_SETVAR()` have been created
  in `not-autoshell.m4`
* Macro † `NA_GET_LIB_VERSION_ENV()` has been renamed to
  `NM_SET_VERSION_ENVIRONMENT()` and has been moved to † `not-misc.m4`
* Macros † `NA_ASK_REPLACEMENTS()`, † `NA_DEFINE_SUBSTRINGS_AS()`,
  † `NA_FOR_EACH_MATCH()`, † `NA_REGEXP_DEPTH()` and † `NA_REPEAT_TEXT()` in
  `not-m4sugar.m4` have been renamed to † `nm4_get_replacements()`,
  † `nm4_define_substrings_as()`, † `nm4_for_each_match()`, † `nm4_redepth()`,
  and † `nm4_repeat()`
* Code review
* Examples



0.1.0
-----

**Not Autotools** has been published.

