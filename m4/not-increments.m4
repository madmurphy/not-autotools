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
dnl  I N C R E M E N T I N G   A N D   D E C R E M E N T I N G   M A C R O S
dnl  **************************************************************************


dnl  **************************************************************************
dnl  NOTE:  These utilities are designed to perform simple increment and
dnl         decrement operations on numerical macros. If you are looking for
dnl         full-fledged, self-updating counters, please see `n4_set_counter()`
dnl         in `not-m4sugar.m4`.
dnl  **************************************************************************



dnl  n4_pp_amount(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of one unit,
dnl  then expand the new value (“plus-plus-amount”)
dnl
dnl  This macro corresponds to ECMAScript `++macro`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_pp_amount([my_amount])     # Prints `101`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_pp_amount],
	[m4_define([$1], m4_incr($1))[]$1])


dnl  n4_ppn_amount(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of `num`
dnl  units, then expand the new value
dnl
dnl  This macro corresponds to ECMAScript `(macro += num)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_ppn_amount([12], [my_amount])     # Prints `112`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_ppn_amount],
	[m4_define([$2], m4_eval($2[ + $1]))[]$2])


dnl  n4_amount_pp(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of one unit,
dnl  then expand the old value (“amount-plus-plus”)
dnl
dnl  This macro corresponds to ECMAScript `macro++`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_pp([my_amount])     # Prints `100`
dnl      my_amount     # Prints `101`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_pp],
	[$1[]m4_define([$1], m4_incr($1))])


dnl  n4_amount_ppn(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of `num`
dnl  units, then expand the old value
dnl
dnl  This macro corresponds to ECMAScript `macro;void(macro += num);`. For
dnl  example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_ppn([592], [my_amount])     # Prints `100`
dnl      my_amount     # Prints `692`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_ppn],
	[$2[]m4_define([$2], m4_eval($2[ + $1]))])


dnl  n4_amount_incr(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of one unit,
dnl  then expand an empty string
dnl
dnl  This macro corresponds to ECMAScript `void(++macro)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_incr([my_amount])     # Prints ``
dnl      my_amount     # Prints `101`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_incr],
	[m4_define([$1], m4_incr($1))])


dnl  n4_amount_add(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by incrementing it of `num`
dnl  units, then expand an empty string
dnl
dnl  This macro corresponds to ECMAScript `void(macro += num)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_add([999], [my_amount])     # Prints ``
dnl      my_amount     # Prints `1099`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_add],
	[m4_define([$2], m4_eval($2[ + $1]))])


dnl  n4_amounts_incr(macro-name1[, macro-name2[, ... macro-nameN]])
dnl  **************************************************************************
dnl
dnl  Redefine one or more numerical macros altogether by incrementing them of
dnl  one unit, then expand an empty string
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount_1], [0])
dnl      m4_define([my_amount_2], [19])
dnl      m4_define([my_amount_3], [98])
dnl      n4_amounts_incr([my_amount_1], [my_amount_2], [my_amount_3])
dnl      my_amount_1, my_amount_2, my_amount_3     # Prints `1, 20, 99`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amounts_incr],
	[m4_if([$#], [0], [],
		[m4_define([$1], m4_incr($1))[]m4_if([$#], [1], [],
			[$0(m4_shift($@))])])])


dnl  n4_amounts_add(num, macro-name1[, macro-name2[, ... macro-nameN]])
dnl  **************************************************************************
dnl
dnl  Redefine one or more numerical macros altogether by incrementing them of
dnl  `num` units, then expand an empty string
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount_1], [1])
dnl      m4_define([my_amount_2], [20])
dnl      m4_define([my_amount_3], [99])
dnl      n4_amounts_add([897], [my_amount_1], [my_amount_2], [my_amount_3])
dnl      my_amount_1 / my_amount_2 / my_amount_3   # Prints `898 / 917 / 996`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amounts_add],
	[m4_if([$#], [0], [], [$#], [1], [],
		[m4_define([$2], m4_eval($2[ + $1]))[]m4_if([$#], [2], [],
			[$0([$1], m4_shift2($@))])])])


dnl  n4_mm_amount(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of one unit,
dnl  then expand the new value (“minus-minus-amount”)
dnl
dnl  This macro corresponds to ECMAScript `--macro`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_mm_amount([my_amount])     # Prints `99`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_mm_amount],
	[m4_define([$1], m4_decr($1))[]$1])


dnl  n4_mmn_amount(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of `num`
dnl  units, then expand the new value
dnl
dnl  This macro corresponds to ECMAScript `(macro -= num)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_mmn_amount([23], [my_amount])     # Prints `77`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_mmn_amount],
	[m4_define([$2], m4_eval($2[ - $1]))[]$2])


dnl  n4_amount_mm(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of one unit,
dnl  then expand the old value (“amount-minus-minus”)
dnl
dnl  This macro corresponds to ECMAScript `macro--`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_mm([my_amount])     # Prints `100`
dnl      my_amount     # Prints `99`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_mm],
	[$1[]m4_define([$1], m4_decr($1))])


dnl  n4_amount_mmn(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of `num`
dnl  units, then expand the old value
dnl
dnl  This macro corresponds to ECMAScript `macro;void(macro -= num);`. For
dnl  example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_mmn([1022], [my_amount])     # Prints `100`
dnl      my_amount     # Prints `-922`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_mmn],
	[$2[]m4_define([$2], m4_eval($2[ - $1]))])


dnl  n4_amount_decr(macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of one unit,
dnl  then expand an empty string
dnl
dnl  This macro corresponds to ECMAScript `void(--macro)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_decr([my_amount])     # Prints ``
dnl      my_amount     # Prints `99`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_decr],
	[m4_define([$1], m4_decr($1))])


dnl  n4_amount_subtract(num, macro-name)
dnl  **************************************************************************
dnl
dnl  Redefine the numerical macro `macro-name` by decrementing it of `num`
dnl  units, then expand an empty string
dnl
dnl  This macro corresponds to ECMAScript `void(macro -= num)`.
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount], [100])
dnl      n4_amount_subtract([8], [my_amount])     # Prints ``
dnl      my_amount     # Prints `92`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amount_subtract],
	[m4_define([$2], m4_eval($2[ - $1]))])


dnl  n4_amounts_decr(num, macro-name1[, macro-name2[, ... macro-nameN]])
dnl  **************************************************************************
dnl
dnl  Redefine one or more numerical macros altogether by decrementing them of
dnl  one unit, then expand an empty string
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount_1], [898])
dnl      m4_define([my_amount_2], [917])
dnl      m4_define([my_amount_3], [996])
dnl      n4_amounts_decr([my_amount_1], [my_amount_2], [my_amount_3])
dnl      my_amount_1 / my_amount_2 / my_amount_3     # Prints `897 / 916 / 995`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amounts_decr],
	[m4_if([$#], [0], [],
		[m4_define([$1], m4_decr($1))[]m4_if([$#], [1], [],
			[$0(m4_shift($@))])])])


dnl  n4_amounts_subtract(num, macro-name1[, macro-name2[, ... macro-nameN]])
dnl  **************************************************************************
dnl
dnl  Redefine one or more numerical macros altogether by decrementing them of
dnl  `num` units, then expand an empty string
dnl
dnl  Example:
dnl
dnl      m4_define([my_amount_1], [897])
dnl      m4_define([my_amount_2], [916])
dnl      m4_define([my_amount_3], [995])
dnl      n4_amounts_subtract([897], [my_amount_1], [my_amount_2], [my_amount_3])
dnl      my_amount_1 / my_amount_2 / my_amount_3     # Prints `0 / 19 / 98`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_amounts_subtract],
	[m4_if([$#], [0], [], [$#], [1], [],
		[m4_define([$2], m4_eval($2[ - $1]))[]m4_if([$#], [2], [],
			[$0([$1], m4_shift2($@))])])])



dnl  **************************************************************************
dnl  NOTE:  The `n4_` prefix (which stands for "Not m4sugar") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefix
dnl         `m4_`.
dnl  **************************************************************************



dnl  EOF

