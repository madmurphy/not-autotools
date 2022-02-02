/*  -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */

/*\
|*|
|*| main.c
|*|
|*| https://www.example.com/libfoobar
|*|
|*| Copyright (C) 2021 John Doe <me@example.com>
|*|
|*| **Foo Bar** is free software: you can redistribute it and/or modify it
|*| under the terms of the GNU General Public License as published by the Free
|*| Software Foundation, either version 3 of the License, or (at your option)
|*| any later version.
|*|
|*| **Foo Bar** is distributed in the hope that it will be useful, but WITHOUT
|*| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
|*| FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
|*| more details.
|*|
|*| You should have received a copy of the GNU General Public License along
|*| with this program. If not, see <http://www.gnu.org/licenses/>.
|*|
\*/


#include "main.h"

#if HAVE_CONFIG_H
#include "config.h"
#endif

CALC_DATA_TYPE sum_test (
	const CALC_DATA_TYPE num1,
	const CALC_DATA_TYPE num2
) {

	return num1 + num2;

}

CALC_DATA_TYPE multiply_test (
	const CALC_DATA_TYPE num1,
	const CALC_DATA_TYPE num2
) {

	return num1 * num2;

}

/*  EOF  */
