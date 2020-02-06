dnl  **************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl            A collection of useful m4-ish macros for GNU Autotools
dnl
dnl                                               -- Released under GNU GPL3 --
dnl
dnl                                  https://github.com/madmurphy/not-autotools
dnl  **************************************************************************



dnl  **************************************************************************
dnl  F A N C Y   T E X T S   ( M 4 S U G A R   E X T E N S I O N S )
dnl  **************************************************************************



dnl  n4_sp(length)
dnl  **************************************************************************
dnl
dnl  Prints an arbitrary number of white spaces
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([n4_sp],
	[m4_if(m4_eval([$1 > 0]), [1],
		[n4_sp(m4_eval([$1 - 1]))[ ]])])


dnl  m4_text_center(text[, prefix[, max-width = screen-width - m4_len(prefix)[, screen-width = 79]]])
dnl  **************************************************************************
dnl
dnl  Relatively similar to `m4_text_wrap()`, but the text is centered
dnl
dnl  For example,
dnl
dnl      /*\
dnl      m4_text_center([Lorem ipsum dolor sit amet, consectetur adipiscing
dnl      elit. Ut in tristique turpis. Nunc nibh purus, faucibus a erat nec,
dnl      porta suscipit mi. Phasellus id sodales orci, sit amet semper sem.
dnl      Morbi scelerisque molestie erat at cursus. In tincidunt varius neque,
dnl      dictum elementum augue vestibulum at. Proin dignissim ullamcorper
dnl      consequat. Pellentesque ut leo aliquet, vulputate ligula quis,
dnl      fringilla metus. Sed bibendum orci leo, a aliquet lectus ornare et.
dnl      Nam imperdiet justo non felis ullamcorper pharetra. Curabitur ut
dnl      condimentum urna. Sed pretium quam non metus pulvinar accumsan.
dnl      Suspendisse in ullamcorper diam. Praesent at sollicitudin nisl. Nunc
dnl      sollicitudin maximus dignissim.], [|*|], 50, 70)
dnl      \*/
dnl
dnl  will print
dnl
dnl      /*\
dnl      |*|              Lorem ipsum dolor sit amet, consectetur
dnl      |*|           adipiscing elit. Ut in tristique turpis. Nunc
dnl      |*|          nibh purus, faucibus a erat nec, porta suscipit
dnl      |*|          mi. Phasellus id sodales orci, sit amet semper
dnl      |*|          sem. Morbi scelerisque molestie erat at cursus.
dnl      |*|         In tincidunt varius neque, dictum elementum augue
dnl      |*|            vestibulum at. Proin dignissim ullamcorper
dnl      |*|         consequat. Pellentesque ut leo aliquet, vulputate
dnl      |*|          ligula quis, fringilla metus. Sed bibendum orci
dnl      |*|          leo, a aliquet lectus ornare et. Nam imperdiet
dnl      |*|          justo non felis ullamcorper pharetra. Curabitur
dnl      |*|          ut condimentum urna. Sed pretium quam non metus
dnl      |*|           pulvinar accumsan. Suspendisse in ullamcorper
dnl      |*|             diam. Praesent at sollicitudin nisl. Nunc
dnl      |*|                  sollicitudin maximus dignissim.
dnl      \*/
dnl
dnl  This macro supports Autoconf quadrigraphs.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_sp()`
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([m4_text_center],
	[m4_bpatsubst(_m4_text_wrap([$1], [], [],
			m4_default_nblank_quoted([$3], m4_eval(m4_default_nblank_quoted([$4], [79])[ - ]m4_len([$2])))),
		[^.*$],
		[m4_escape([$2]n4_sp(m4_eval((m4_default_nblank_quoted([$4], [79])[ - ]m4_len([\&])[ - ]m4_len([$2])) / 2))[\&])])])



dnl  **************************************************************************
dnl  NOTE:  The `n4_` prefix (which stands for "Not m4sugar") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefix
dnl         `m4_`.
dnl  **************************************************************************



dnl  EOF

