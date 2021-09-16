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
dnl  U T F - 8   S U I T E   ( M 4 S U G A R   E X T E N S I O N S )
dnl  **************************************************************************



dnl  n4_charcode(character)
dnl  **************************************************************************
dnl
dnl  Expands to the numeric value of a single 8-bit character or code unit
dnl
dnl  For example:
dnl
dnl      n4_charcode([C])
dnl          => 67
dnl
dnl  If a string of more than one character is passed as argument this macro
dnl  expands to zero.
dnl
dnl  There is no way of capturing or expanding a `NUL` character in M4:
dnl  `m4_len(m4_format([%c], [0]))` is always 0.
dnl
dnl  NOTE:  This macro temporarily changes quotes, then restores them to `[`
dnl         and `]`. Thanks to this it is able to compute any character,
dnl         including quotes and round brackets.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_lambda()` from `not-m4sugar.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_charcode],
	[m4_changecom()m4_changequote()m4_changequote(<:, :>)m4_if(m4_len(<:$*:>), 0, 0, m4_incr(m4_index(<:]m4_quote(n4_lambda([m4_if(m4_eval([$1 > 0]), [1], [$0(m4_decr([$1]))m4_changecom()m4_changequote(<:, :>)m4_format(<:%c:>, <:$*:>)<::>m4_changequote([, ])m4_changecom([#])])])(255))[:>, <:$*:>)))m4_changequote([, ])m4_changecom([#])])


dnl  n4_codeunit_at(string[, index])
dnl  **************************************************************************
dnl
dnl  Expands to the numeric value of the code unit at index `index` in the
dnl  string `string`
dnl
dnl  For example:
dnl
dnl      n4_codeunit_at([ABCDEFG], [2])
dnl          => 67
dnl
dnl  If `index` is omitted, the first code unit of the string will be computed.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_charcode()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_codeunit_at],
	[m4_if(m4_index([[$1]], [[(]]), m4_default([$2], [0]),
			[40],
		m4_index([[$1]], [[)]]), m4_default([$2], [0]),
			[41],
			[n4_charcode(m4_quote(m4_substr([$1], m4_default([$2], [0]), [1])))])])


dnl  n4_codepoint_to_ascii(unsigned-number[, escape-format-when-non-ascii])
dnl  **************************************************************************
dnl
dnl  Expands to the ASCII character whose codepoint is `unsigned-number` if the
dnl  latter is a 7-bit number, or to the string `\x[hex]` (where `[hex]` is the
dnl  hexadecimal representation of `unsigned-number`) if this is larger than
dnl  seven bits
dnl
dnl  For example:
dnl
dnl      n4_codepoint_to_ascii([67])
dnl          => C
dnl  
dnl      n4_codepoint_to_ascii([8230])
dnl          => \x2026
dnl
dnl  This macro supports also a format argument for non-7-bit code points:
dnl
dnl      # Octal
dnl      n4_codepoint_to_ascii([8230], [\0%o])
dnl          => \020046
dnl
dnl      # Decimal HTML entity
dnl      n4_codepoint_to_ascii([8230], [&#%d;])
dnl          => &#8230;
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_codepoint_to_ascii],
	[m4_format(m4_if(m4_eval([$1 < 128]), [1], [%c], m4_default_quoted([$2], [\x%x])), [$1])])


dnl  n4_escape_non_ascii(string[, escape-format])
dnl  **************************************************************************
dnl
dnl  Replaces non-ASCII code points in `string` with their escaped hexadecimal
dnl  representation
dnl
dnl  For example:
dnl
dnl      n4_escape_non_ascii([Le déjeuner sur l'herbe])
dnl          => Le d\xc3\xa9jeuner sur l'herbe
dnl
dnl  This macro supports also a format argument for non-7-bit code units:
dnl
dnl      # Decimal escape
dnl      n4_escape_non_ascii([Le déjeuner sur l'herbe], [\%d])
dnl          => Le d\195\169jeuner sur l'herbe
dnl
dnl      # Hexadecimal escape
dnl      n4_escape_non_ascii([Le déjeuner sur l'herbe], [\x%x])
dnl          => Le d\xc3\xa9jeuner sur l'herbe
dnl
dnl      # Octal escape
dnl      n4_escape_non_ascii([Le déjeuner sur l'herbe], [\0%o])
dnl          => Le d\0303\0251jeuner sur l'herbe
dnl
dnl      # Convert it back to a string
dnl      n4_escape_non_ascii([Le déjeuner sur l'herbe], [%c])
dnl          => Le déjeuner sur l'herbe
dnl
dnl  NOTE:  Unfortunately this macro cannot deal with square and round
dnl         brackets.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_codeunit_at()` and `n4_codepoint_to_ascii()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_escape_non_ascii],
	[m4_if(m4_eval(m4_len([$1])[ > 0]), [1],
		[n4_codepoint_to_ascii(n4_codeunit_at([$1], 0), [$2])])[]m4_if(m4_eval(m4_len([$1])[ > 1]), [1],
			[n4_escape_non_ascii(m4_quote(m4_substr([$1], 1)), [$2])])])


dnl  n4_escape_everything(string[, escape-format])
dnl  **************************************************************************
dnl
dnl  Replaces **all** code points in `string` (both ASCII and non-ASCII) with
dnl  a given format or their escaped hexadecimal representation
dnl
dnl  For example:
dnl
dnl      # Null terminated array of characters
dnl      n4_escape_everything([Section § 2], [%d, ])0
dnl          => 83, 101, 99, 116, 105, 111, 110, 32, 194, 167, 32, 50, 0
dnl
dnl      # Hexadecimal escape
dnl      n4_escape_everything([Section § 2], [\x%x])
dnl          => \x53\x65\x63\x74\x69\x6f\x6e\x20\xc2\xa7\x20\x32
dnl
dnl      # Octal escape
dnl      n4_escape_everything([Section § 2], [\0%o])
dnl          => \0123\0145\0143\0164\0151\0157\0156\040\0302\0247\040\062
dnl
dnl      # Convert it back to a string
dnl      n4_escape_everything([Section § 2], [%c])
dnl          => Section § 2
dnl
dnl  If `escape-format` is omitted, the default format `\x%x` will be used:
dnl
dnl      n4_escape_everything([Section § 2])
dnl          => \x53\x65\x63\x74\x69\x6f\x6e\x20\xc2\xa7\x20\x32
dnl
dnl  NOTE:  Unfortunately this macro cannot deal with square and round
dnl         brackets.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_codeunit_at()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_escape_everything],
	[m4_if(m4_eval(m4_len([$1])[ > 0]), [1],
		[m4_format(m4_default_quoted([$2], [\x%x]), n4_codeunit_at([$1], 0))])[]m4_if(m4_eval(m4_len([$1])[ > 1]), [1],
			[n4_escape_everything(m4_quote(m4_substr([$1], 1)), [$2])])])



dnl  **************************************************************************
dnl  NOTE:  The `n4_` prefix (which stands for "Not m4sugar") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefix
dnl         `m4_`.
dnl  **************************************************************************



dnl  EOF

