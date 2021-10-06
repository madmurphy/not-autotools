dnl  **************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl              A collection of useful m4 macros for GNU Autotools
dnl
dnl                                               -- Released under GNU GPL3 --
dnl
dnl                                  https://github.com/madmurphy/not-autotools
dnl  **************************************************************************



dnl  **************************************************************************
dnl  A   L O O K   I N T O   T H E   A U T O R E C O N F   P R O C E S S
dnl  **************************************************************************



dnl  NR_GET_ENV_VAR(variable)
dnl  **************************************************************************
dnl
dnl  Retrieves an environment variable present during the `autoreconf` process
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([This package has been distributed by NR_GET_ENV_VAR([USER]).])
dnl
dnl  Note that `autoreconf` runs at a different time (and often even on a
dnl  different computer) than the `configure` script.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NR_GET_ENV_VAR], [m4_esyscmd_s([echo ${$1}])])


dnl  NR_ENVIRONMENT_KEYS()
dnl  **************************************************************************
dnl
dnl  Reads all the environment variables present during the `autoreconf`
dnl  process and returns a comma-separated list of their names
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([This package has been distributed by n4_case_in([USER],
dnl      	[NR_ENVIRONMENT_KEYS],
dnl      		[NR_GET_ENV_VAR([USER])],
dnl      		[unknown])])
dnl
dnl  For the `n4_case_in()` macro, see `not-m4sugar.m4`.
dnl
dnl  Note that `autoreconf` runs at a different time (and often even on a
dnl  different computer) than the `configure` script.
dnl
dnl  To iterate through the `NR_ENVIRONMENT_KEYS` list you can also use GNU
dnl  M4sugar looping utilities, like the `m4_map()` macro in the following
dnl  example:
dnl
dnl      AC_DEFUN([MY_MACRO], [AC_MSG_NOTICE([Found $1 among the environment variables]);])
dnl      m4_map([MY_MACRO], [NR_ENVIRONMENT_KEYS])
dnl
dnl  See:
dnl  https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Looping-constructs.html
dnl
dnl  This macro makes a system call the first time it is invoked, then
dnl  overwrites itself with the literal list of the environment keys received,
dnl  so that any further access to the list will rely on a cache and not
dnl  anymore on system calls. If you want to force further system calls after
dnl  the first access you can use:
dnl
dnl      m4_popdef([NR_ENVIRONMENT_KEYS])
dnl      NR_ENVIRONMENT_KEYS
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NR_ENVIRONMENT_KEYS],
	[m4_pushdef([NR_ENVIRONMENT_KEYS],
		m4_quote(m4_esyscmd([env | sed 's/^\([^=]\+\)=.*$/[\1],/g' | tr '\n' ' ' | sed 's/,\s*$//'])))[]NR_ENVIRONMENT_KEYS])


dnl  NR_LOAD_ENVIRONMENT()
dnl  **************************************************************************
dnl
dnl  Reads all the environment variables present during the `autoreconf`
dnl  process and defines for each of them a separate macro named
dnl  `[RENV_]VARNAME` (where the `RENV_` prefix stands for "autoReconf
dnl  ENVironment")
dnl
dnl  For example,
dnl
dnl      NR_LOAD_ENVIRONMENT
dnl      AC_MSG_NOTICE([This package has been distributed by ]RENV_USER[.])
dnl
dnl  prints on my computer:
dnl
dnl      This package has been distributed by madmurphy.
dnl
dnl  All `RENV_*` macros contain literals (no further system calls)
dnl
dnl  Be aware that environment variables can contain unmatched quotes. This
dnl  macro will load all environment variables in any case, without generating
dnl  errors. The problem however will raise when trying to expand an `RENV_*`
dnl  macro containing an unmatched quote.
dnl
dnl  For example, a user might have a `LESS_TERMCAP_mb` variable set to
dnl  `\x1b[01;31m` -- for colouring the Unix `less` utility -- which contains
dnl  the left quote `[`. When trying to expand the `RENV_LESS_TERMCAP_mb` macro
dnl  the following error will be generated:
dnl  
dnl      NR_LOAD_ENVIRONMENT
dnl      RENV_LESS_TERMCAP_mb
dnl          ==> m4:test.m4:2: ERROR: end of file in string
dnl
dnl  However, since the variable is correctly stored, temporarily changing
dnl  quotes will be enough to solve the problem:
dnl
dnl      NR_LOAD_ENVIRONMENT
dnl      m4_changequote
dnl      RENV_LESS_TERMCAP_mb
dnl      m4_changequote([, ])
dnl
dnl  This macro may be invoked only once. Note that `autoreconf` runs at a
dnl  different time (and often even on a different computer) than the
dnl  `configure` script.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN_ONCE([NR_LOAD_ENVIRONMENT], 
	[m4_esyscmd_s([echo "m4_changequote({{<<, >>}}){{<<>>}}$(env | sed 's/^\([^=]\+\)=\(.*\)$/m4_define({{<<RENV_\1>>}}, {{<<\2>>}})/g'){{<<>>}}m4_changequote([, ])"])])


dnl  NR_NEWFILE(file-name[, file-content])
dnl  **************************************************************************
dnl
dnl  Creates a new file with a custom content when `autoreconf` is run
dnl
dnl  This macro may be invoked before `AC_INIT()`.  
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NR_NEWFILE],
	[m4_ifblank([$1],
		[m4_fatal([NR_NEWFILE(): file name cannot be empty])],
		[m4_syscmd([cat << 'NA_END_OF_FILE' > '$1']m4_newline()[$2]m4_newline()[NA_END_OF_FILE])])])


dnl  NR_CONFIG_FILES(file1[, file2[, file3[, ... fileN]]])
dnl  **************************************************************************
dnl
dnl  Configures output files during the `autoreconf` process, using `.m4`
dnl  scripts as input
dnl
dnl  This macro is inspired by `AC_CONFIG_FILES()`, but with some important
dnl  differences:
dnl
dnl  1. The output is not created at `configure` time, but at `autoreconf`
dnl     time
dnl  2. Each file must be listed as a separate argument, and not within a
dnl     space-separated list
dnl  3. The input files are not expected to have a `.in` file extension, but a
dnl     `.m4` file extension instead (although, as with `AC_CONFIG_FILES()`, it
dnl     is possible to specify custom inputs using the colon character -- as in
dnl     `NR_CONFIG_FILES([foo.c:my_m4_script1.in], [bar.c:other.m4])`)
dnl
dnl  For example, imagine to have a file named `hello.c.m4` containing the
dnl  following C code:
dnl
dnl      #include <stdio.h>
dnl
dnl      int main () {
dnl          printf(SENTENCE);
dnl          return 0;
dnl      }
dnl
dnl  Inserting the following two lines in the `configure.ac` script
dnl
dnl      m4_define([SENTENCE], ["Hello world!\n"])
dnl      NR_CONFIG_FILES([hello.c])
dnl
dnl  will produce a file named `hello.c` with the following content:
dnl
dnl      #include <stdio.h>
dnl
dnl      int main () {
dnl          printf("Hello world!\n");
dnl          return 0;
dnl      }
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.1
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NR_CONFIG_FILES],
	[m4_ifnblank([$1], [m4_pushdef([_sep_idx_], m4_quote(m4_bregexp([$1], [:])))m4_syscmd([cat << 'NA_END_OF_FILE' > ']m4_if(_sep_idx_, [-1], m4_normalize([[$1]]), [m4_normalize(m4_quote(m4_substr([$1], [0], _sep_idx_)))])[']m4_newline()m4_quote(m4_include(m4_if(_sep_idx_, [-1], m4_normalize([[$1.m4]]), [m4_normalize(m4_quote(m4_substr([$1], m4_incr(_sep_idx_))))])))[NA_END_OF_FILE])m4_popdef([_sep_idx_])])m4_if([$#], [1], [], [NR_CONFIG_FILES(m4_shift($@))])])


dnl  NR_PROG_VERSION(program)
dnl  **************************************************************************
dnl
dnl  Launches `program --version` via `m4_esyscmd()` and passes the output to
dnl  `grep -o -m 1 '[0-9]\+.[0-9]\+\(.[0-9]\+\(.[0-9]\+\)\?\)\?\S*'`
dnl
dnl  For example,
dnl
dnl      AC_MSG_NOTICE([autoconf version: ]NR_PROG_VERSION([autoconf]))
dnl
dnl  will generate the following output:
dnl
dnl      configure: autoconf version: 2.69
dnl
dnl  For caching the result of a single `NR_PROG_VERSION()` call, the
dnl  `n4_expand_once()` macro from `not-m4sugar.m4` is usually a good solution.
dnl  For example to cache into a `MY_AC_VERSION` macro the current version of
dnl  `autoconf`, use:
dnl
dnl      n4_expand_once([MY_AC_VERSION], [NR_PROG_VERSION], [autoconf])
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NR_PROG_VERSION],
		[m4_esyscmd_s(m4_changequote({{<<, >>}}){{<<'$1' --version | grep -o -m 1 '[0-9]\+.[0-9]\+\(.[0-9]\+\(.[0-9]\+\)\?\)\?\S*'>>}}m4_changequote({{<<[>>}}, {{<<]>>}}))])



dnl  **************************************************************************
dnl  NOTE:  The `NR_` prefix (which stands for "Not autoReconf") is used with
dnl         the purpose of avoiding collisions with the default Autotools
dnl         prefixes `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

