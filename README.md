Not Autotools
=============

A collection of awesome and self-documented m4 macros for GNU Autotools


Overview
--------

This collection has grown steadly and has now more than 100 macros. The macros
are organized by topic and each topic has its own file. With the exception of
two stand-alone frameworks (`not-autoversion.m4` and `not-extended-config.m4`),
most of the macros are independent from each other, so you can just copy and
paste what you need. The few cases where a macro depends on a helper macro are
documented.

For the complete list of the macros released by the **Not Autotools** project,
please see [`macro-index.md`][1].

Feel free to contribute. For any questions, [drop a message][2].


Relationship with the Autoconf Archive
--------------------------------------

This project has many similarities with the [**Autoconf Archive**][3], however
there are important differences too.

One difference is that while the **Autoconf Archive** mostly aims at solving
compiler or dependency problems, **Not Autotools** has a broader focus, which
includes expanding the M4 language to try and render it as less painful as
possible in its integration with the shell and the `configure` script.

One other difference is represented by the way whereby the macros are
distributed. The **Autoconf Archive** expects users to install a package that
makes some new macros automatically available via `autoreconf`. The **Not
Autotools** project instead by design releases macros that need to be manually
copied and pasted, or included directly in a build directory. This has the
advantage of not slowing down the project's evolution, and backward
incompatible changes do not break existing packages.

A way to think of the **Not Autotools** project is as “a possible staging
laboratory for the **Autoconf Archive**”. Here the macros often change
radically, or even disappear, without caring too much for backward
compatibility. However, when a macro becomes good and stable enough it can
easily become part of the **Autoconf Archive** as well.


Free software
-------------

This library is free software. You can redistribute it and/or modify it under
the terms of the GPL3 license. See [COPYING][4] for details.


  [1]: macro-index.md
  [2]: https://github.com/madmurphy/not-autotools/issues
  [3]: https://www.gnu.org/software/autoconf-archive/
  [4]: https://github.com/madmurphy/not-autotools/blob/master/COPYING

