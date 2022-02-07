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
dnl  P A R A L L E L   " T H R E A D S "   D U R I N G   ` C O N F I G U R E `
dnl  **************************************************************************



dnl  NC_THREAD_NEW([thread-name, ]thread-content)
dnl  **************************************************************************
dnl
dnl  Run expensive computations in parallel, in new "threads" to be joined at
dnl  the end of the configuration process
dnl
dnl  After a thread has been joined all the variables that this has set during
dnl  its life will be imported into the `configure` environment.
dnl
dnl  If called with two arguments, the first argument will be the name of the
dnl  thread. When called with only one argument an unnamed thread will be
dnl  created instead.
dnl
dnl  Named threads can be joined individually by `NC_JOIN_THREADS()`. Unnamed
dnl  threads can be joined only collectively.
dnl
dnl  All threads will need to be joined eventually. For most cases creating
dnl  unnamed threads and joining them altogether at the end of the
dnl  `configure.ac` script represents the most convenient setup.
dnl
dnl  For instance, the following example will perform two expensive tests in
dnl  parallel while the `configure` script continues its configuration. Their
dnl  results will be then captured after invoking `NC_JOIN_THREADS()` later in
dnl  the `configure.ac` script.
dnl
dnl      # Start a new unnamed thread....
dnl      NC_THREAD_NEW([
dnl          AC_MSG_NOTICE([Starting a parallel test...])
dnl          # Do something expensive here
dnl          sleep 3
dnl          # ...
dnl          AS_VAR_SET([TEST_RESULT_1], [foo])
dnl          AC_MSG_NOTICE([Parallel test 1 has terminated])
dnl      ])
dnl
dnl      # Start another thread, named this time....
dnl      NC_THREAD_NEW([my_named_thread], [
dnl          # Do something expensive here
dnl          # ...
dnl          sleep 1
dnl          # ...
dnl          AS_VAR_SET([TEST_RESULT_2], [bar])
dnl          AC_MSG_NOTICE([Parallel test 2 has terminated])
dnl      ])
dnl
dnl      # This message will appear immediately, without waiting for the tests
dnl      # to be completed
dnl      AC_MSG_NOTICE([Hello world])
dnl
dnl      # Do other unrelated things here
dnl      # ...
dnl
dnl      AC_MSG_NOTICE([Wait until all the threads have returned...])
dnl      NC_JOIN_THREADS
dnl
dnl      AC_MSG_NOTICE([The result of the first test was ${TEST_RESULT_1}])
dnl      AC_MSG_NOTICE([The result of the second test was ${TEST_RESULT_2}])
dnl
dnl      AC_OUTPUT
dnl
dnl  You can see this example in action at `examples/not-parallel-configure`.
dnl
dnl  NOTE:  The shell does not really support threads. We have named ours
dnl         "threads" because we have emulated a shared memory, but each
dnl         configure "thread" is actually an independent process.
dnl
dnl  Threads should not set variables that will be set concurrently by other
dnl  threads.
dnl
dnl  Threads cannot set up `configure` substitutions. These will have to be set
dnl  by the main thread after all the threads have returned.
dnl
dnl  If present, the `thread-name` argument must be a valid shell variable
dnl  name.
dnl
dnl  NOTE:  Some native Autoconf macros are not designed to run in parallel;
dnl         vanilla shell scripting on the other hand should never cause
dnl         problems.
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NC_JOIN_THREADS()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_THREAD_NEW],
[m4_define([__NC_THNUM__], m4_ifdef([__NC_THNUM__], [m4_incr(__NC_THNUM__)], [1]))
{
	echo
	(set -o posix ; set) > 'threadenv.__NC_THNUM__.tmp'
	m4_default_nblank([$2], [$1])
	(set -o posix ; set) | comm -13 --nocheck-order \
		'threadenv.__NC_THNUM__.tmp' - > 'confthread.__NC_THNUM__.source' && \
		rm 'threadenv.__NC_THNUM__.tmp';
} &
m4_ifnblank([$2], [m4_ifnblank([$1], [
_na_tmp_pno_[]__NC_THNUM__[]_="${!}"
AS_VAR_SET([na_threadnum_$1], [']__NC_THNUM__['])
AS_VAR_COPY([na_threadpid_$1], [_na_tmp_pno_]__NC_THNUM__[_])
AS_UNSET([_na_tmp_pno_]__NC_THNUM__[_])])])])


dnl  NC_JOIN_THREADS([thread-name1[, thread-name2[, ... thread-nameN]]])
dnl  **************************************************************************
dnl
dnl  Join the "threads" created with `NC_THREAD_NEW()`
dnl
dnl  If called without arguments all the threads currently running will be
dnl  joined. Similarly, a blank argument, when encountered, will be interpreted
dnl  as a request to wait all the currently running threads.
dnl
dnl  If `NC_THREAD_NEW()` is invoked at least once, this macro **must** be
dnl  invoked eventually. All the created threads must be joined, either one by
dnl  one or collectively. See the documentation of `NC_THREAD_NEW()` for more
dnl  information.
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()` and, at
dnl  least once, `NC_THREAD_NEW()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NC_THREAD_NEW()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_JOIN_THREADS],
	[m4_ifblank([$1],
		[m4_ifdef([__NC_THNUM__], [
			wait[]m4_for([__IDX__], [1], __NC_THNUM__, [1], [
			if test -f 'confthread.__IDX__.source'; then
				source './confthread.__IDX__.source' && \
				rm 'confthread.__IDX__.source';
			fi
])])], [
	AS_VAR_COPY([_na_pid_], [na_threadpid_$1])
	AS_VAR_COPY([_na_pno_], [na_threadnum_$1])
	wait "${_na_pid_}"
	source "./confthread.${_na_pno_}.source" && \
		rm "./confthread.${_na_pno_}.source"
	AS_UNSET([_na_pid_])
	AS_UNSET([_na_pno_])
	AS_UNSET([na_threadpid_$1])
	AS_UNSET([na_threadnum_$1])
	m4_if([$#], [0], [], [$#], [1], [],
		[NC_JOIN_THREADS(m4_shift($@))])])])



dnl  **************************************************************************
dnl  NOTE:  The `NC_` prefix (which stands for "Not autoConf") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

