[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5201698.svg)](https://doi.org/10.5281/zenodo.5201698)

# Portable Icon 9.5.2

## Quick start (TL;DR)

1. Create an Icon program, `world.icn`
   - e.g., `copy examples\example_shebang.cmd world.icn`
1. Translate and run in separate steps:
   1. Translate world.icn with<br />`path\to\icont world`
   1. Run the program with<br />`world`
1. Translate and run the program in a single step with<br />`icon world.icn`
1. Run an example script that contains a Icon program<br />`examples\example_shebang.cmd`

## Introduction

The Icon programming language
[https://cs.arizona.edu/icon/](https://cs.arizona.edu/icon/) is
a high-level, general-purpose programming language that is in
the public domain.  Icon programs translated by the Icon translator
("icont") can be run by the Icon runtime interpreter ("iconx").

Frequently, Icon can be an expressive and enjoyable way to write software.  You might find it helpful to copy the framework for writing and
running Icon programs to your home directory.

This repository provides is a small, portable collection of binary
and library files for running Icon 9.5.2 on Microsoft Windows
in a manner similar to how Icon runs on Unix.

- This build has been tested on Windows 10.
- This framework embeds "icode" (translated Icon programs) into `.bat`
files that provide for several ways of searching for the `iconx` runtime
system (which implements the Icon interpreter).
  - This is very similar to how Icon 9.3.2 for Windows produces `.bat`
files when directed not to include a copy of the Icon interpreter when
translating Icon programs.
- This repository also provides rudimentary support for writing scripts
in Icon.

The icon translator and interpreter here were built in August 2021 using
Cygwin as described in
[the `README.md` file in the `src` directory](./src/README.md).
(These were compiled without support for the Icon graphical interface,
and they differ from
[the build of Icon for Windows (from 2015)](https://www2.cs.arizona.edu/icon/v95w.htm),
for which source code is not presently available.)

## Examples

Icon programs use the extension `.icn` (which need not be included
for source files when invoking the translator using the `icont.cmd` script,
but which is included in the examples below for clarity).
The translator always produces a `.bat` file that includes the translation
of the program into icode and [some code to search for the Icon runtime
(`iconx`)](#searching-for-iconx-the-icon-runtime-interpreter).

### `icont.cmd` outputs

The output produced by `icont.cmd` can be adjusted several ways:

- To create `world.bat` (a batch file that includes the icode as described immediately above):
  <br />&nbsp;&nbsp;`icont world.icn`
  - To run this from within a batch file, you must use the `call` syntax:<br />
   &nbsp;&nbsp;`call world`
  - To run it from the command line, `call` is not necessary<br />
   &nbsp;&nbsp;`world`
- To create `world.exe` (an addtional 18 kb file that calls `world.bat` in the
  same directory, so that batch files can use `world` rather than `call world`),
  either give the output file a `.exe` extension or include the `--add-exe`
  option:
  <br />&nbsp;&nbsp;`icont --add-exe world.icn`
  <br />&nbsp;&nbsp;`icont -o world.exe world.icn`
  - Unless you have modified your `PATHEXT` environment variable, executing<br />
   &nbsp;&nbsp;`world`<br />
   will invoke `world.exe` in preference to `world.bat`.
- To create a "standalone" set of files in the `portable` directory that
  can be copied to and run on another machine without Icon installed,
  include the `--standalone` option:
  <br />&nbsp;&nbsp;`icont -o portable\world.exe --standalone world.icn`
  <br />which populates `portable` with:
  - `world.bat`
  - `world.exe`
  - `cygwin1.dll`
  - `nticont.exe`
- As with Icon on Unix, when the `-o` option is not specified, the result
  is named after the first `.icn` file named; the following produces
  `world.bat`:
  <br />&nbsp;&nbsp;`icont world.icn moon.icn`
- To produce an icode-only file (*in addition to* the `.bat` file), provide
  an extension for the output file different from `.bat` or `.exe`:
  <br />&nbsp;&nbsp;`icont -o world.icx world.icn`
- To produce an icode-only file (without the `.bat` file),
  - either use `icont_nosmudge`:
    <br />&nbsp;&nbsp;`icont_nosmudge -o world.icx world.icn`
  - or define the `ICONT_NOSMUDGE` environment variable:
    <br />&nbsp;&nbsp;`set ICONT_NOSMUDGE=1`
    <br />&nbsp;&nbsp;`icont -o world.icx world.icn`
  - If you were to want to create a `world.bat` file later from `world.icx`,
    you would run this:
    <br />&nbsp;&nbsp;`bin\smudge world.icx`

### Searching for `iconx` (the Icon runtime interpreter)

The `.bat` file produced by `icont.cmd` includes code to search for the
Icon runtime interpreter (`iconx`); the search order is:

1. the value to which the `ICONX` environment variable is set, which, if it is set, should be the full path to a copy of `bin\nticonx.exe`;
1. a file named `nticonx.exe` in the same directory as the `.bat` file;
1. a file named `nticonx.exe` in the directory where the translator (`nticont.exe`) was located when it translated the program (assuming that it has not moved);
1. a file named `nticonx.exe` on the `PATH`.

## Files in this repository

### Top-level files (which you may find convenient to put onto your path)

- `icont.cmd`
  - This is a "convenience script" for invoking `bin\nticont.exe`:
    - Run `icont.cmd` without any arguments for a list of options.
  - This script passes all arguments through to `bin\nticont.exe` (the actual translator) *after* it:
    - ensures that the IPATH environmental variable points to the working
      directory and `ipl/procs` unless IPATH is already set:
      - Because spaces are the separator between directories specified in
        IPATH, the individual directory names must have no spaces.
        - The script uses the
          [short, spaceless names](https://en.wikipedia.org/wiki/8.3_filename)
          of the directories when it composes IPATH
      - IPATH is only used at translation time.
      - When setting IPATH yourself, use
        ["short file names"](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).
        - You can discover them using `dir /x`.
    - ensures that the LPATH environmental variable points to the working
      directory and `ipl/incl` unless LPATH is already set;
      the same considerations for IPATH apply to LPATH.
    - invokes `bin\smudge` to present the resulting icode files as described
      in ["Examples"](#examples) above.
  - The resulting `.bat` file can be executed anywhere on the machine
    so long as the path to the `bin` directory does not change, as described in ["Examples"](#examples) above.
- `icont.exe`
  - This is a "convenience program" that calls `icont.cmd`, passing all of
    its arguments through to `icont.cmd`.
  - This allows one to put `icont world.icn` into a batch file without the word
    `call` as would be required for `call icont.cmd world.icn` for execution
    to resume in the calling batch file.
  - See [the `README.md` file in the `src` directory](./src/README.md) for
    an explanation.
- `icont_nosmudge.cmd`
  - This script invokes `icont` with a directive **not** to wrap the icode into
    a `.bat` file.  Rather, a non-executable `.exe` file containing the icode
    is produced.
  - `icont.cmd` performs this way when the `ICONT_NOSMUDGE` environment variable is set.
  - See smoke test 7 in `examples\smoke_test.cmd`.
- `iconx.cmd`
  - This is a "convenience script" for invoking `bin\nticonx.exe`:
- `iconx.exe`
  - This is a "convenience program" that calls `iconx.cmd`, passing all of its
    arguments through to `iconx.cmd`.
  - This allows one to put `iconx myicodefile` into a batch file without
    the word `call` as would be required for `call icont.cmd myicodefile`
    for execution to resume in the calling batch file.
  - See [the `README.md` file in the `src` directory](./src/README.md)
    for an explanation.
- `icon.cmd`
  - This is a "convenience script" for both compiling a `.icn` file
    and running it with the supplied arguments.
  - usage: `icon [options for icont] [program.icn or -] [args]`
    - Note that passing options of icont is an extension that is not allowed
      on the Unix builds of Icon.
  - ["Shebang - scripting with Icon"](#shebang---scripting-with-icon) makes use of this script.
    - To support this, no matching `icon.exe` program is included.
  - See smoke test 9 in `examples\smoke_test.cmd`.
- `#!icon.cmd`
  - This script facilitates construction of scripts that are valid Icon
    source code and may be just-in-time translated and executed.
  - See `example\example_shebang.cmd` and `example\#!icon.cmd` to see how
    to reference and use this script.
  - See also ["Shebang - scripting with Icon"](#shebang---scripting-with-icon).

### More examples

- `examples\smoke_test.cmd`
  - This demonstrates use of most of the files in the repository
    (at the top level and within `examples`).
  - See [`examples\smoke_test.output.expected.txt`](./examples/smoke_test.output.expected.txt)
    for the expected output.
  - Admittedly, it isn't highly readable.
- `examples\run_smoke_test.cmd`
  - This runs `smoke_test.cmd` and compares the actual output
    to the expected output.
  - This sets a zero exit code (accessible through the ERRORLEVEL
    pseudo-environment variable) when all tests pass and nonzero otherwise.
- `examples\example_shebang.cmd` and `examples\#!icon.cmd` leverage `icon.cmd`
    to execute a self-translating script that is still valid Icon source code.
  - See smoke test 8 in `examples\smoke_test.cmd`.
  - See also "Shebang - scripting with Icon" for details.
- `examples\example_stdin.cmd` is a simple example of how to translate
   and run Icon source code from a script file, passing arguments.
  - The script is *not* valid Icon source code as a consequence.
  - See smoke test 3 in `examples\smoke_test.cmd`.
  - See also "Shebang - scripting with Icon" for details.

### Files with which you (ordinarily) do not need to interact directly

The following files are used by the top level programs; you shouldn't need
to interact with them directly.

- `bin\nticont.exe`
  - This is the actual Icon translator.
  - When invoked without the `-o` argument, this writes "icode" to
    a (non-functional) `.exe` with the same name as the `.icn` file,
    in the same directory.
  - See `icont.*` below for a convenient way to invoke this indirectly.
  - [`options_nticont.md`](./options_nticont.md) describes the options that
    may be passed for `nticont` and the environment variables that may
    be set for running the translated program.
    - This is drawn from
     [the `icont` reference material](https://cs.arizona.edu/icon/refernce/icontx.htm#icont).
- `bin\nticonx.exe`
  - This is the actual Icon interpreter, which executes "icode".
  - See `iconx.*` for a convenient way to invoke this indirectly.
- `bin\smudge.cmd` is a small utility invoked by `icont.cmd` (but not by
  `icont_nosmudge.cmd`) that, in turn, converts an "icode" file into
   a `.bat` file that locates and invokes the virtual machine; the search order
   is:
  1. The path set in the `ICONX` environment variable.
  1. `nticonx.exe` if it exists in the same directory as the `.bat` file.
      - This is to mimic the behavior of the Unix build; it requires copies
        of `bin\nticonx.exe` and `bin\cygwin1.dll` to be in the directory
        as well.
        - When you supply the argument `--standalone` to `icont.*` or
          to `bin\smudge.cmd`, these files will be copied
          to the output directory if they do not already exist there.
  1. `bin\nticonx.exe` if it still exists (i.e., if it has not been moved since
      the `.bat` file was produced).
  1. The first `iconx.exe`, `iconx.bat`, or `iconx.cmd` on the executable path,
      i.e., the `PATH` environmental variable.
- `bin\cygwin1.dll` is a the Cygnal patch of the `cygwin1.dll` from
   Cygwin 3.2.0.
  - This file comes from the Cygnal project ([http://www.kylheku.com/cygnal/](https://web.archive.org/web/20210811182329im_/http://www.kylheku.com/cygnal/)).
  - See [src\README.md](./src/README.md#about-bin-and-iconconfigcygwin_portable)
    for further information.

## Shebang - scripting with Icon

It is possible to do (nonpersistent) just-in-time translation of your
(single source file) Icon source program.
The `examples\example_shebang.cmd` and `examples\#!icon.cmd` scripts together:

- translate and run an Icon source code on-the-fly, and
- allow the script to be a valid Icon source file, *but:*
  - you get the first line on the standard output unless:
    - you run `echo off` before running it, or
    - you run it from another script that has echo off.

For this to work:

- the first line must be exactly <br />`#!icon "%~dpnx0" %*`
  - which is reminscent of, but not identical with, the standard first line
    of a script that specifies the interpreter, e.g., <br />`#!bin/env icon`
- a batch script named `#!icon.cmd` must be on your PATH, that must, in turn,
  must pass control to the `#!icon.cmd` script in the directory containing
  `icon.cmd`.
  - `examples\#!icon.cmd` does this.
  - a minimally dependent example (not dependent on `examples\#!icon.cmd`) would be:<br />
    `mkdir elsewhere`<br />
    `copy examples\example_shebang.cmd elsewhere\`<br />
    `cmd /c "set PATH=.;c:\windows\system32& elsewhere\example_shebang.cmd foo bar"`<br />
- I don't have to have `C:\Users\eschen42\portableIcon\#!icon.cmd`
  on my PATH *per se*, as long as I have another (trivial) script on my path
  named `#!icon.cmd` that contains one line, e.g.:
  <br /> `@"C:\Users\eschen42\portableIcon\#!icon.cmd" %*`

See test 8 in `smoke_test.cmd`.

## Bugs

- I have not found a way to express an IPATH or LPATH that has
  directories that themselves include spaces, except by using
  ["8.3" filenames](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).
- `bin\nticont.exe` and `bin\nticonx.exe` must be invoked with a relative or absolute path, i.e., the<br />
  &nbsp;&nbsp;`nticont.exe`<br />
  invocation fails from within the `bin` directory, but<br />
  &nbsp;&nbsp;`.\nticont.exe`<br />
  succeeds.

# Portable Icon 9.3.2

A portable version of Icon 9.3.2 is available on the `icon_v9.3.2` branch:

- That version can be used to create single-file, stand-alone binaries.
- A release of that version is available at
  [https://github.com/eschen42/portableIcon/releases/tag/v9.3.2_rc1](https://github.com/eschen42/portableIcon/releases/tag/v9.3.2_rc1).
- For a description, see
  [https://github.com/eschen42/portableIcon/tree/icon_v9.3.2](https://github.com/eschen42/portableIcon/tree/icon_v9.3.2)

# Unicon

There is an actively developed language extending Icon called Unicon
that may be preferred for general software development because it provides
multithreading and modern integration with networking, databases, messaging,
file attributes, and the operating system. Please see
[http://unicon.org/](http://unicon.org/) for further info.
Unicon for Windows produces stand-alone binaries have a minimum size of about 5.5mb.

