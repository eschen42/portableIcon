@set ERRORLEVEL=&setlocal&set ECHO_ON=off
@echo %ECHO_ON%
pushd %~dps0
set ZIPDIR=%CD:\=/%
set CONDA_BUILD=0
set RELEASE_TAG=v9.5.2_conda_%CONDA_BUILD%_rev4
set RELEASE_ZIP=https://github.com/eschen42/portableIcon/archive/refs/tags/%RELEASE_TAG%.zip
set RELEASE_URL=https://github.com/eschen42/portableIcon/releases/tag/%RELEASE_TAG%
curl -L -o portableIcon-master.zip https://github.com/eschen42/portableIcon/archive/refs/tags/v9.5.2_conda_%CONDA_BUILD%_rev4.zip || (
  echo.zip download failed.
  echo.  If this is surprising, be sure that you have installed curl.
  popd
  exit /b 1
)
if exist recipe rmdir /s/q recipe
mkdir recipe

:::::::::::::::::::::::::: BEGIN INLINE TEXT  ::::::::::::::::::::::::::::::
call :heredoc :BLD_BAT > recipe\bld.bat && goto :BLD_BAT || goto :HERE_ERROR
@echo -------------------  bld.bat stdout start  ---------------------
rem The source code for Icon v9.5.2 does not support builds in Microsoft
rem   Visual Studio; thus, it was built with Cygwin and is installed
rem   by copying the built files to the Library\usr\bin directory,
rem   along with the matching Cygnal cygwin1.dll from
rem   http://www.kylheku.com/cygnal/
robocopy /e ^
  %SRC_DIR% %LIBRARY_PREFIX%\usr\bin ^
  /XF metadata_conda_debug.yaml ^
  /XF conda_build.bat ^
  /XF robocopy.log ^
  /XF build_env_setup.bat ^
  > robocopy.log 2>&1
@if %ERRORLEVEL% leq 7 (echo RoboCopy successful) else type robocopy log
@echo -------------------  bld.bat stdout end    ---------------------
@if %ERRORLEVEL% leq 7 (
  echo.    Note well that conda-verify will report that .exe and .bat or
  echo.     .cmd files having the same filename coexist in the same
  echo.     directory.  This is intentional.
  exit /b 0
)
@echo RoboCopy failed with exit code %ERRORLEVEL%
exit /b %ERRORLEVEL%
:BLD_BAT
:::::::::::::::::::::::::::: END INLINE TEXT  ::::::::::::::::::::::::::::::

:::::::::::::::::::::::::: BEGIN INLINE TEXT  ::::::::::::::::::::::::::::::
call :heredoc :META_YAML > recipe\meta.yaml && goto :META_YAML || goto :HERE_ERROR

{% set name = "icon" %}
{% set version = "9.5.2" %}
{% set build = "!CONDA_BUILD!" %}

package:
  name: {{ name|lower }}
  version: {{ version }}

source:
  url: file:///!ZIPDIR!/portableIcon-master.zip

build:
  number: {{ build }}
  skip: True  # [not win64]

requirements:

test:
  commands:
    - icont -V
    - iconx -V
    - echo procedure main^^^(^^^)^^^; every write^^^(^^^&features^^^)^^^; end | icon -

about:
  summary: Icon translator, runtime, and library.
  doc_url: https://cs.arizona.edu/icon
  home: https://github.com/eschen42/portableIcon
  license: LGPL-3.0-or-later
  license_family: LGPL
  license_file:  LICENSE.md
  dev_url: !RELEASE_URL!
  description:
    - This module installs the translator and runtime for
      the Icon Programming Language, built without graphics support,
      along with the applicable files from the Icon Programming Library.
    - This packge is MIT licensed, as are the scripts to support running Icon
      programs and scripts on Microsoft Windows.
    - Note that https://github.com/gtownsend/icon/blob/master/README states
      that the Icon Programming Language itself is in the public domain.
    - The Windows build includes support to make the tools and translated
      programs work in a manner similar to how they run on Unix and depends
      on the included cygwin1.dll file that is LGPL licensed.

extra:
  recipe-maintainers:
    - eschen42

:META_YAML
:::::::::::::::::::::::::::: END INLINE TEXT  ::::::::::::::::::::::::::::::

:::::::::::::::::::::::::: BEGIN INLINE TEXT  ::::::::::::::::::::::::::::::
call :heredoc :LICENSE_MD > recipe\LICENSE.md && goto :LICENSE_MD || goto :HERE_ERROR
# Licenses:

The portableIcon programs and DLLs may be copied freely.  The applicable
license (if any) is covered in the following sections:

- [portableIcon](#portableicon)
  - MIT License
- [Icon Programming Language](#icon-programming-language)
  - Public Domain
- [Cygnal cygwin1.dll](#cygnal-cygwin1dll)
  - LGPL version 3
  - Applies only to the Microsoft Windows build of this package.

# portableIcon

```
MIT License

Copyright (c) 2021 Arthur Eschenlauer

Permission is hereby granted, free of charge, to any person obtaining a copy
of portableIcon and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

# Icon Programming Language

The Icon Programming Language itself is in the public domain. The
following is from https://github.com/gtownsend/icon/blob/master/README

```
This material is in the public domain.  You may use and copy this material
freely.  This privilege extends to modifications, although any modified
version of this system given to a third party should clearly identify your
modifications as well as the original source.

The responsibility for the use of this material resides entirely with you.
We make no warranty of any kind concerning this material, nor do we make
any claim as to the suitability of Icon for any application.
```

# Cygnal cygwin1.dll

*This license applies only to the `cygwin1.dll` file that is present only
in the Microsoft Windows build of the conda-forge `icon` package*

Because the Cygnal `cygwin1.dll` is derived from the Cygwin `cygwin1.dll`,
it is licensed under
[LGPLv3](https://www.gnu.org/licenses/lgpl-3.0-standalone.html),
making it freely distributable with the license notice; see
[https://cygwin.com/licensing.html](https://cygwin.com/licensing.html).

```
                   GNU LESSER GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.


  This version of the GNU Lesser General Public License incorporates
the terms and conditions of version 3 of the GNU General Public
License, supplemented by the additional permissions listed below.

  0. Additional Definitions.

  As used herein, "this License" refers to version 3 of the GNU Lesser
General Public License, and the "GNU GPL" refers to version 3 of the GNU
General Public License.

  "The Library" refers to a covered work governed by this License,
other than an Application or a Combined Work as defined below.

  An "Application" is any work that makes use of an interface provided
by the Library, but which is not otherwise based on the Library.
Defining a subclass of a class defined by the Library is deemed a mode
of using an interface provided by the Library.

  A "Combined Work" is a work produced by combining or linking an
Application with the Library.  The particular version of the Library
with which the Combined Work was made is also called the "Linked
Version".

  The "Minimal Corresponding Source" for a Combined Work means the
Corresponding Source for the Combined Work, excluding any source code
for portions of the Combined Work that, considered in isolation, are
based on the Application, and not on the Linked Version.

  The "Corresponding Application Code" for a Combined Work means the
object code and/or source code for the Application, including any data
and utility programs needed for reproducing the Combined Work from the
Application, but excluding the System Libraries of the Combined Work.

  1. Exception to Section 3 of the GNU GPL.

  You may convey a covered work under sections 3 and 4 of this License
without being bound by section 3 of the GNU GPL.

  2. Conveying Modified Versions.

  If you modify a copy of the Library, and, in your modifications, a
facility refers to a function or data to be supplied by an Application
that uses the facility (other than as an argument passed when the
facility is invoked), then you may convey a copy of the modified
version:

   a) under this License, provided that you make a good faith effort to
   ensure that, in the event an Application does not supply the
   function or data, the facility still operates, and performs
   whatever part of its purpose remains meaningful, or

   b) under the GNU GPL, with none of the additional permissions of
   this License applicable to that copy.

  3. Object Code Incorporating Material from Library Header Files.

  The object code form of an Application may incorporate material from
a header file that is part of the Library.  You may convey such object
code under terms of your choice, provided that, if the incorporated
material is not limited to numerical parameters, data structure
layouts and accessors, or small macros, inline functions and templates
(ten or fewer lines in length), you do both of the following:

   a) Give prominent notice with each copy of the object code that the
   Library is used in it and that the Library and its use are
   covered by this License.

   b) Accompany the object code with a copy of the GNU GPL and this license
   document.

  4. Combined Works.

  You may convey a Combined Work under terms of your choice that,
taken together, effectively do not restrict modification of the
portions of the Library contained in the Combined Work and reverse
engineering for debugging such modifications, if you also do each of
the following:

   a) Give prominent notice with each copy of the Combined Work that
   the Library is used in it and that the Library and its use are
   covered by this License.

   b) Accompany the Combined Work with a copy of the GNU GPL and this license
   document.

   c) For a Combined Work that displays copyright notices during
   execution, include the copyright notice for the Library among
   these notices, as well as a reference directing the user to the
   copies of the GNU GPL and this license document.

   d) Do one of the following:

       0) Convey the Minimal Corresponding Source under the terms of this
       License, and the Corresponding Application Code in a form
       suitable for, and under terms that permit, the user to
       recombine or relink the Application with a modified version of
       the Linked Version to produce a modified Combined Work, in the
       manner specified by section 6 of the GNU GPL for conveying
       Corresponding Source.

       1) Use a suitable shared library mechanism for linking with the
       Library.  A suitable mechanism is one that (a) uses at run time
       a copy of the Library already present on the user's computer
       system, and (b) will operate properly with a modified version
       of the Library that is interface-compatible with the Linked
       Version.

   e) Provide Installation Information, but only if you would otherwise
   be required to provide such information under section 6 of the
   GNU GPL, and only to the extent that such information is
   necessary to install and execute a modified version of the
   Combined Work produced by recombining or relinking the
   Application with a modified version of the Linked Version. (If
   you use option 4d0, the Installation Information must accompany
   the Minimal Corresponding Source and Corresponding Application
   Code. If you use option 4d1, you must provide the Installation
   Information in the manner specified by section 6 of the GNU GPL
   for conveying Corresponding Source.)

  5. Combined Libraries.

  You may place library facilities that are a work based on the
Library side by side in a single library together with other library
facilities that are not Applications and are not covered by this
License, and convey such a combined library under terms of your
choice, if you do both of the following:

   a) Accompany the combined library with a copy of the same work based
   on the Library, uncombined with any other library facilities,
   conveyed under the terms of this License.

   b) Give prominent notice with the combined library that part of it
   is a work based on the Library, and explaining where to find the
   accompanying uncombined form of the same work.

  6. Revised Versions of the GNU Lesser General Public License.

  The Free Software Foundation may publish revised and/or new versions
of the GNU Lesser General Public License from time to time. Such new
versions will be similar in spirit to the present version, but may
differ in detail to address new problems or concerns.

  Each version is given a distinguishing version number. If the
Library as you received it specifies that a certain numbered version
of the GNU Lesser General Public License "or any later version"
applies to it, you have the option of following the terms and
conditions either of that published version or of any later version
published by the Free Software Foundation. If the Library as you
received it does not specify a version number of the GNU Lesser
General Public License, you may choose any version of the GNU Lesser
General Public License ever published by the Free Software Foundation.

  If the Library as you received it specifies that a proxy can decide
whether future versions of the GNU Lesser General Public License shall
apply, that proxy's public statement of acceptance of any version is
permanent authorization for you to choose that version for the
Library.
```
:LICENSE_MD
:::::::::::::::::::::::::::: END INLINE TEXT  ::::::::::::::::::::::::::::::

cd recipe
conda-build . || (
  echo.conda-build failed. If this is surprising, be sure that you have
  echo.  activated a conda enviroment and installed conda-bin.
  popd
  exit /b 1
)
popd
exit/b 0

:HERE_ERROR
echo %~nx0: Unable to write inline document
popd
exit /b 1

::::::::::::::::::::::::::: :heredoc subroutine ::::::::::::::::::::::::::::
:: https://github.com/ildar-shaimordanov/cmd.scripts/blob/master/heredoc.bat
:: ref: https://stackoverflow.com/a/29329912
:: ref: https://stackoverflow.com/a/15032476/3627676
::
:heredoc LABEL
@echo off
setlocal enabledelayedexpansion
if not defined CMDCALLER set "CMDCALLER=%~f0"
set go=
for /f "delims=" %%A in ( '
	findstr /n "^" "%CMDCALLER%"
' ) do (
	set "line=%%A"
	set "line=!line:*:=!"

	if defined go (
		if /i "!line!" == "!go!" goto :EOF
		echo:!line!
	) else (
		rem delims are @ ( ) > & | TAB , ; = SPACE
		for /f "tokens=1-3 delims=@()>&|	,;= " %%i in ( "!line!" ) do (
			if /i "%%i %%j %%k" == "call :heredoc %1" set "go=%%k"
			if /i "%%i %%j %%k" == "call heredoc %1" set "go=%%k"
			if defined go if not "!go:~0,1!" == ":" set "go=:!go!"
		)
	)
)
set ECHO=%ECHO_ON%
@goto :EOF
::::::::::::::::::::::::: end :heredoc subroutine ::::::::::::::::::::::::::
