Change Log
==========


2.6.0
-----

Changes:

* New macros `n4_list_append_list()`, `n4_list_append_members()`,
  `n4_pluralize()`, `n4_list_prepend_list()` and `n4_list_prepend_members()`
  have been created in `not-m4sugar.m4`; macros `NA_MODULE_CHECK_PKGS()` and
  `NA_MODULES_CHECK_PKGS()` have been created in `not-autotools.m4`
* Documentation


2.5.0
-----

Changes:

* Three renamings in `not-autoversion.m4` (macro † `NR_RECORD_HISTORY_RC()` has
  been renamed to `NR_RECORD_HISTORY_RCO()`, macro † `NR_GET_EVENT_VSTATE_RC()`
  has been renamed to `NR_GET_EVENT_VSTATE_RCO()`, macro
  † `NR_FOR_EACH_EVENT_RC()` has been renamed to `NR_FOR_EACH_EVENT_RCO()`)
* The `introspect` directory has been added to the repository (for aiding
  debug)
* A new example has been added to the repository
  (`examples/not-autoversion/reverse-chronological-order`)


2.4.0
-----

Changes:

* New library file `not-increments.m4` has been created, containing the
  following new macros:
    * `n4_pp_amount()`
    * `n4_ppn_amount()`
    * `n4_amount_pp()`
    * `n4_amount_ppn()`
    * `n4_amount_incr()`
    * `n4_amount_add()`
    * `n4_amounts_incr()`
    * `n4_amounts_add()`
    * `n4_mm_amount()`
    * `n4_mmn_amount()`
    * `n4_amount_mm()`
    * `n4_amount_mmn()`
    * `n4_amount_decr()`
    * `n4_amount_subtract()`
    * `n4_amounts_decr()`
    * `n4_amounts_subtract()`
* New macro `n4_retrieve()` has been created in `not-m4sugar.m4`
* New macro `NS_CATCH()` has been created in `not-autoshell.m4`
* New macro `NC_CPP_EXPAND()` has been created in `not-cc.m4`
* New macros † `NR_RECORD_HISTORY_RC()`, † `NR_GET_EVENT_VSTATE_RC()` and
  † `NR_FOR_EACH_EVENT_RC()` have been created in `not-autoversion.m4`
* Code review (macro `NC_AUTOVERSION_SUBSTITUTIONS()` in `not-autoversion.m4`;
  macros `NS_SETVARS()`, `NS_GETVAR()`, `NS_UNSET()`, `NS_MOVEVAR()` and
  `NS_REPLACEVAR()` in `not-autoshell.m4`)
* File `macro-index.md` has been sorted alphabetically
* Documentation


2.3.0
-----

Changes:

* New library file `not-parallel-configure.m4` has been created, containing the
  new macros `NC_THREAD_NEW()` and `NC_JOIN_THREADS()`
* New macros `NC_AUTO_REQ_PROGS()` and `NM_AUTO_QUERY_PROGS()` have been
  created in `not-autotools.m4`
* Documentation
* New examples have been created (`examples/not-parallel-configure`)


2.2.2
-----

Changes:

* Code review (macros `NR_HISTORY_ROOT_VSTATE()` and  `NR_BUMP_VSTATE()` in
  `not-autoversion.m4` – made sure that the default `NR_PROJECT_MINVER` is set
  to `1` when `NR_PROJECT_MAJVER` is `0`)


2.2.1
-----

Changes:

* Code review (macro `NC_GLOBAL_LITERALS()` in `not-autotools.m4`)
* Documentation
* New examples have been created (`examples/na_amend`)


2.2.0
-----

Changes:

* New macros `n4_rshift()`, `n4_rshift2()` and `n4_rshift3()` have been created
  in `not-m4sugar.m4`
* Code review (macro `NA_HELP_STRINGS()` in `not-autotools.m4`; macros
  `NS_TEST_AEQ()` and `NS_TEST_NAE()` in `not-autoshell.m4`)
* Documentation


2.1.0
-----

Changes:

* New macro `n4_bind()`, has been created in `not-m4sugar.m4`
* Code review (macro `n4_burn_out()` in `not-m4sugar.m4`; macro `n4_sp()` in
  `not-fancy-texts.m4`; macro `NR_CONFIG_FILES()` in `not-autoreconf.m4`;
  macros `NC_MSG_ERRORBOX()` and `NC_MSG_FAILUREBOX()` in `not-ac-messages.m4`)
* Documentation


2.0.0
-----

Changes:

* New macros `n4_set_counter()`, `n4_has()`, `n4_has_any()`, `n4_nquote()` and
  `n4_void()`, have been created in `not-m4sugar.m4`
* New macros `NC_SUBST_VARS()`, `NC_SUBST_PAIRS()`, `NC_SUBST_VARS_NOTMAKE()`
  and `NC_SUBST_PAIRS_NOTMAKE()` have been created in `not-autotools.m4`
* New macros `NS_HEREDOC()` and `NS_LITERAL_HEREDOC()` have been created in
  `not-autoshell.m4`
* New macro `n4_newlines()` has been created in `not-fancy-texts.m4`
* New library file `not-autoversion.m4` has been created, containing the
  following new macros:
    * `NR_RECORD_HISTORY()`
    * `NR_PROJECT_VERSION`
    * `NR_BINARY_VERSION`
    * `NR_LIBTOOL_VERSION_INFO`
    * `NR_PROJECT_MAJVER`
    * `NR_PROJECT_MINVER`
    * `NR_PROJECT_MICVER`
    * `NR_BINARY_MAJVER`
    * `NR_BINARY_MINVER`
    * `NR_BINARY_MICVER`
    * `NR_INTERFACE_NUM`
    * `NR_INTERFACES_SUPPORTED`
    * `NR_IMPLEMENTATION_NUM`
    * `NR_SOURCE_AGE`
    * `NC_AUTOVERSION_SUBSTITUTIONS`
    * `NR_HISTORY_CURRENT_EVENT_NAME`
    * `NR_HISTORY_CURRENT_VSTATE`
    * `NR_HISTORY_ROOT_VSTATE`
    * `NR_HISTORY_EVENTS`
    * `NR_HISTORY_GET_EVENT_VSTATE()`
    * `NR_HISTORY_FOR_EACH_EVENT()`
    * `NR_VSTATE_GET_PROJECT_VERSION()`
    * `NR_VSTATE_GET_PROJECT_MAJVER()`
    * `NR_VSTATE_GET_PROJECT_MINVER()`
    * `NR_VSTATE_GET_PROJECT_MICVER()`
    * `NR_VSTATE_GET_BINARY_VERSION()`
    * `NR_VSTATE_GET_BINARY_MAJVER()`
    * `NR_VSTATE_GET_BINARY_MINVER()`
    * `NR_VSTATE_GET_BINARY_MICVER()`
    * `NR_VSTATE_GET_LIBTOOL_VERSION_INFO()`
    * `NR_VSTATE_GET_INTERFACE_NUM()`
    * `NR_VSTATE_GET_INTERFACES_SUPPORTED()`
    * `NR_VSTATE_GET_IMPLEMENTATION_NUM()`
    * `NR_VSTATE_GET_SOURCE_AGE()`
    * `NR_BUMP_VSTATE()`
    * `NR_GET_EVENT_VSTATE()`
    * `NR_FOR_EACH_EVENT()`
* The behavior of `n4_with()`, `n4_let()` and `n4_qlet()` has changed in
  respect to quoted arguments
* Code review (macros `n4_list_index()`, `n4_joinalln()`, `n4_arg_index()`,
  `n4_let()`, `n4_case_in()`, `n4_define_substrings_as()`, `n4_expand_once()`,
  `n4_expanded_once()` and `n4_repeat()` in `not-m4sugar.m4`; macro
  `NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`; macro `NS_TEXT_WRAP()`
  in `not-autoshell.m4`)
* Macro † `NC_THREATEN_BLINDLY()` in `not-extended-config.m4` has been renamed
  to `NR_THREATEN_BLINDLY()`
* An `examples` subdirectory has been added to the package tree
* The † `pkgutils` subdirectory has been renamed to `collection-utils`


1.1.0
-----

Changes:

* New macro `NC_MAKETARGET_SUBST_UNQUOTED()` has been created in
  `not-autotools.m4`
* `AC_DEFUN()` has been replaced with `m4_define()` for registering the
  `NC_GLOBAL_LITERALS()` macro (this fixes `autopoint` bug “error: required
  file 'build-aux/config.rpath' not found”)
* Code review (macro `NC_MAKETARGET_SUBST()` in `not-autotools.m4`)
* Documentation


1.0.0
-----

Changes:

* The version number of the collection has been set to `1.0.0`
* New macros `NC_CPP_IF()`, `NC_CC_STATIC_ASSERT()` and
  `NC_CC_CHECK_UINT_FROM_TO()` have been created in `not-cc.m4`
* Documentation


0.24.0
------

Changes:

* Macro † `NC_QUERY_PROGS()` in `not-autotools.m4` has been renamed to
  `NM_QUERY_PROGS()`
* File † `not-multiversion.m4`, containing the † `NR_SET_VERSION_ENVIRONMENT()`
  macro, has been removed
* Macros † `NS_ECHO_IF()` and † `NS_ECHO_IF_UNQUOTED()` have been removed from
  `not-autoshell.m4` – you can use `NS_PP_IF([NS_STDOUT], ...)` and
  `NS_PP_IF([NS_STDOUT_UNQUOTED], ...)` to obtain the same result
* Code review (macros `NC_MSG_ERRORBOX()` and `NC_MSG_FAILUREBOX()` in
  `not-ac-messages.m4`)
* Documentation


0.23.0
------

Changes:

* New macros † `NS_ECHO_IF()`, † `NS_ECHO_IF_UNQUOTED()`, `NS_IF()`,
  `NS_PP_IF()`, `NS_STDOUT()`, `NS_STDOUT_UNQUOTED()`, `NS_STRING_IF()` and
  `NS_STRING_IF_UNQUOTED()` have been created in `not-autoshell.m4`
* The complete macro index has been published (see `macro-index.md`)
* A script for generating automatically the complete macro index has been added
  to the package tree (see † `pkgutils/macro-index-generator.sh`)
* Documentation


0.22.0
------

Changes:

* New macros `n4_joinalln()` and `n4_list_index()` have been created in
  `not-m4sugar.m4`
* New macro † `NC_QUERY_PROGS()` has been created in `not-autotools.m4`
* The argument order of `n4_list_index()` in `not-m4sugar.m4` has changed


0.21.1
------

Changes:

* Code review (macros `n4_includedir()` and `n4_sincludedir()` in
  `not-m4sugar.m4`; macros `NS_TEST_EQ()`, `NS_TEST_NE()`, `NS_TEST_AEQ()` and
  `NS_TEST_NAE()` in `not-autoshell.m4`)


0.21.0
------

Changes:

* New macro `NC_GLOBAL_LITERALS_NOTMAKE()` has been created in
  `not-autotools.m4`
* Macro `NC_MAKETARGET_SUBST()` in `not-autotools.m4` has been expanded and
  now supports order-only prerequisites as well
* Code review (macros `NC_GLOBAL_LITERALS()` and `NC_REQ_PROGS()` in
  `not-autotools.m4`; macro `NC_CONFIG_SHADOW_DIR()` in
  `not-extended-config.m4`)


0.20.1
------

Changes:

* Code review (macro `NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`)


0.20.0
------

Changes:

* New macro `NC_REQUIRE()` has been created in `not-autotools.m4`
* Macro † `NC_CC_HAVE_HEADERS()` has been removed from `not-cc.m4` (the only
  feature this macro was adding to the native `AC_CHECK_HEADERS()` was the
  possibility to give custom names to the shell variables created for each
  header)
* Macro `n4_repeat()` has been simplified – for complex cases please use
  `m4_for()`
* Code review (macro `NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`;
  macros `NS_TEXT_WRAP()` in `not-autoshell.m4`; macros `NC_GET_PROGS()` and
  `NC_REQ_PROGS()` in `not-autotools.m4`)
* A version string has been added to all macros and has been set to `1.0.0`,
  independently of possible previous versions (i.e. versioning begins now)
* Documentation


0.19.0
------

Changes:

* New macros `NC_ARG_MISSING()` and `NC_ARG_MISSING_WITHVAL()` have been
  created in `not-autotools.m4`
* New macros `NS_TEST_AEQ()`, `NS_TEST_EQ()`, `NS_TEST_NAE()` and
  `NS_TEST_NE()`  have been created in `not-autoshell.m4`
* Code review (macros `NS_TEXT_WRAP()` and `NS_TEXT_WRAP_UNQUOTED()` in
  `not-autoshell.m4`; macro `NC_GET_PROGS()` in  `not-autotools.m4`)


0.18.0
------

Changes:

* New macros `NS_TEXT_WRAP()`, `NS_TEXT_WRAP_UNQUOTED()` and
  `NS_TEXT_WRAP_CENTER()` have been created in `not-autoshell.m4`
* Code review (macro `n4_text_center()` in `not-fancy-texts.m4`)
* Documentation


0.17.0
------

Changes:

* Macro † `NC_CC_IF_HAVE_POSIX_C()` in `not-cc.m4` has been rewritten (now
  supports only one optional argument and caches the result of the check) and
  renamed to `NC_CC_CHECK_POSIX()`
* Code review (macros `NA_TRIANGLE_BRACKETS_TO_MAKE_VARS()` and
  `NA_TRIANGLE_BRACKETS_TO_SHELL_VARS()` in `not-autotools.m4`; macro
  `NC_CC_CHECK_SIZEOF()` in `not-cc.m4`)


0.16.0
------

Changes:

* New macros `n4_expand_once()` and `n4_expanded_once()` have been created in
  `not-m4sugar.m4`
* New macro `NR_PROG_VERSION()` has been created in `not-autoreconf.m4`
* Code review (macro `n4_define_substrings_as()` in `not-m4sugar.m4`)


0.15.1
------

Changes:

* Code review (macro `NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`)


0.15.0
------

Changes:

* New library file `not-cc.m4` has been created together with the new macros
  `NC_CC_CHECK_SIZEOF()`, `NC_CC_CHECK_CHAR_BIT` and † `NC_CC_HAVE_HEADERS()`
* New macros `NA_AMEND()`, `NA_AMENDMENTS_SED_EXPR()`, `NA_DOUBLE_DOLLAR()`,
  `NA_ESC_APOS()`, `NA_TRIANGLE_BRACKETS_TO_MAKE_VARS()`,
  `NA_TRIANGLE_BRACKETS_TO_SHELL_VARS()`, `NC_MAKETARGET_SUBST()` and
  `NC_SUBST_NOTMAKE()` have been created in `not-autotools.m4`
* Macro † `NC_IF_HAVE_POSIX_C()` has been renamed to
  † `NC_CC_IF_HAVE_POSIX_C()` and has been moved to `not-cc.m4`
* Macro † `NC_SET_GLOBALLY()` in `not-autotools.m4` has been renamed to
  `NC_GLOBAL_LITERALS()`
* Code review (macro `NA_SANITIZE_VARNAME()` in `not-autotools.m4`)


0.14.0
------

Changes:

* Macro † `NC_IF_HAVE_POSIX()` has been renamed to † `NC_IF_HAVE_POSIX_C()`


0.13.0
------

Changes:

* New macro `NR_NEWFILE()` has been created in `not-autoreconf.m4`


0.12.0
------

Changes:

* Library file † `not-automake.m4` has been renamed to `not-autoreconf.m4`
* Macros † `NM_GET_AM_VAR()`, † `NM_ENVIRONMENT_KEYS` and
  † `NM_LOAD_ENVIRONMENT` in `not-autoreconf.m4` have been renamed to
  `NR_GET_ENV_VAR()`, `NR_ENVIRONMENT_KEYS` and `NR_LOAD_ENVIRONMENT`
* Macro † `NM_SET_VERSION_ENVIRONMENT()` in † `not-multiversion.m4` has been
  renamed to † `NR_SET_VERSION_ENVIRONMENT()`
* New macros `n4_includedir()` and `n4_sincludedir()` have been created in
  `not-m4sugar.m4`
* New macro `NR_CONFIG_FILES()` has been created in `not-autoreconf.m4`


0.11.0
------

Changes:

* New macro † `NC_IF_HAVE_POSIX()` has been created in `not-autotools.m4`


0.10.0
------

Changes:

* New macros `NS_UNTIL()`, `NS_BREAK` and `NS_CONTINUE` have been created in
  `not-autoshell.m4`


0.9.0
-----

Changes:

* New library file `not-fancy-texts.m4` has been created, containing the
  new macros `n4_sp()` and `n4_text_center()`
* New macros `NS_FOR()`, `NS_WHILE()`, `NS_MOVEVAR()` and `NS_REPLACEVAR()`
  have been created in `not-autoshell.m4`
* Macro † `NS_SETVAR` has been removed from `not-autoshell.m4`
* Code review (`NS_SETVARS` in `not-autoshell.m4`; `NC_CONFIG_SHADOW_DIR()` in
  `not-extended-config.m4`)


0.8.0
-----

Changes:

* New macro `n4_mem()` has been created in `not-m4sugar.m4`
* Library file † `not-misc.m4` has been renamed to † `not-multiversion.m4`
* Code review (`NC_CONFIG_SHADOW_DIR()` in `not-extended-config.m4`: removed
  dependency to `n4_lambda()`; † `NM_SET_VERSION_ENVIRONMENT` in
  † `not-multiversion.m4`: added support for a permanent and a temporary
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
  † `NC_SET_GLOBALLY()`
* Documentation


0.6.0
-----

Changes:

* New library files `not-ac-messages.m4`, `not-extended-config.m4` and
  `not-utf8.m4` have been created, containing the following new macros:
  `NC_MSG_ERRORBOX()`, `NC_MSG_FAILUREBOX()`, `NC_MSG_NOTICEBOX()` and
  `NC_MSG_WARNBOX()` (`not-ac-messages.m4`); `NC_CONFIG_SHADOW_DIR()`,
  `NC_SHADOW_MAYBE_OUTPUT`, † `NC_THREATEN_BLINDLY` and `NC_THREATEN_FILES()`
  (`not-extended-config.m4`); `n4_charcode()`, `n4_codeunit_at()`,
  `n4_codepoint_to_ascii()`, `n4_escape_non_ascii()` and
  `n4_escape_everything()` (`not-utf8.m4`);
* New macros `n4_let()`, `n4_qlet()` and `n4_with()` have been created in
  `not-m4sugar.m4`
* New macros `NS_SETVARS()` and `NS_UNSET()` have been created in
  `not-autoshell.m4`
* Macros † `NA_REQ_PROGS()` and † `NA_GET_PROGS()` in `not-autotools.m4` have
  been renamed to `NC_REQ_PROGS()` and `NC_GET_PROGS()`
* Code review (macros † `NM_ENVIRONMENT_KEYS` and † `NM_LOAD_ENVIRONMENT` in
  † `not-automake.m4`; macro † `NM_SET_VERSION_ENVIRONMENT()` in
  † `not-misc.m4` – the new version of the latter is incompatible with previous
  versions)
* Documentation


0.5.0
-----

Changes:

* New macro `n4_burn_out()`  has been created in `not-m4sugar.m4`
* Code review (macro † `NM_LOAD_ENVIRONMENT()` in † `not-automake.m4`, macro
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

* Macro † `nm4_unlambda` has been removed from `not-m4sugar.m4` – lambda macros
  are now safely created without polluting the global scope
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
* Created library files † `not-automake.m4`, `not-autoshell.m4` and
  † `not-misc.m4`
* Library file † `not-m4.m4` has been renamed to `not-m4sugar.m4`
* New macros `nm4_case()`, `nm4_in()`, `nm4_in_args()`, `nm4_lambda()`,
  `nm4_switch()` and `nm4_unlambda` have been created in `not-m4sugar.m4`
* New macros † `NM_ENVIRONMENT_KEYS`, † `NM_GET_AM_VAR()` and
  † `NM_LOAD_ENVIRONMENT` have been created in † `not-automake.m4`
* New macros `NS_GETOUT()`, `NS_GETVAR()` and † `NS_SETVAR()` have been created
  in `not-autoshell.m4`
* Macro † `NA_GET_LIB_VERSION_ENV()` has been renamed to
  † `NM_SET_VERSION_ENVIRONMENT()` and has been moved to † `not-misc.m4`
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

