# Portable Icon 9.5.2

The Icon programming language [https://cs.arizona.edu/icon/](https://cs.arizona.edu/icon/) is a high-level, general-purpose programming language that is in the public domain.  Icon programs translated by the Icon translator ("icont") can be run by the Icon interpreter ("iconx").

Frequently, Icon can be an expressive and enjoyable way to write software.  You might find it helpful to copy the framework for writing and running Icon programs to your home directory.

This repository provides is a small, portable collection of binary and library files for running Icon 9.5.2 on Microsoft Windows in a manner similar to how Icon runs on Unix.

- This build has been tested on Windows 10.
- This framework embeds "icode" (translated Icon programs) embedded `.bat` files that provide for several ways of searching for the `iconx` runtime system (which implements the Icon interpreter).
  - This is very similar to how Icon 9.3.2 for Windows produces `.bat` files when directed not to include a copy of the Icon interpreter when translating Icon programs.

This repository also provides rudimentary support for writing scripts in Icon.

The icon translator and interpreter here were built in July 2021 using Cygwin as described in [the `README.md` file in the `src` directory](./src/README.md).  (These were compiled without support for the Icon graphical interface, and they differ from [the build of Icon for Windows (from 2015)](https://www2.cs.arizona.edu/icon/v95w.htm), for which source code is not presently available.)  

(There is also an actively developed language extending Icon called Unicon that is preferred for general software development because it provides multithreading and modern integration with networking, databases, messaging, file attributes, and the operating system. Please see [http://unicon.org/](http://unicon.org/) for further info.  Unicon for Windows produces stand-alone binaries have a minimum size of about 5.5mb.)

## Files in this repository

Note that invoking `icont.cmd` or `icont.exe` produces `.bat' program that needs no adjustments to the PATH to execute.

### Top-level files that you may find convenient to put onto your path

- `icont.cmd`
  - This is a "convenience script" for invoking `bin\nticont.exe`:
  - Run `icont.cmd` without any arguments for a list of options.
  - This script passes all arguments through to `nticont.exe` *after* it:
    - ensures that the portable directory (which contains `bin\nticont.exe` and `bin\nticonx.exe`) is in PATH.
    - ensures that the IPATH environmental variable points to the included the working directory and `ipl/procs` unless IPATH is already set,
      - Because spaces are the separator between directories specified in IPATH, the individual directory names must have no spaces.
        - The script uses the [short, spaceless names](https://en.wikipedia.org/wiki/8.3_filename) of the directories when it composes IPATH
      - IPATH is only used at translation time.
      - When setting IPATH yourself, use ["short file names"](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).
        - You can discover them using `dir /x`.
    - converts the resulting icode into a `.bat` file.
  - The resulting `.bat` file can be executed anywhere on the machine so long as the path to the `bin` directory does not change.
- `icont.exe`
  - This is a "convenience program" that calls `icont.cmd`, passing all of its arguments through to `icont.cmd`.
  - This allows one to put `icont world.icn` into a batch file without the word `call` as would be required for `call icont.cmd world.icn` for execution to resume in the calling batch file.
  - See [the `README.md` file in the `src` directory](./src/README.md) for an explanation.
- `icont_nosmudge.cmd`
  - This script invokes `icont` with a directive **not** to wrap the icode into a `.bat` file.  Rather, a non-executable `.exe` file containing the icode is produced.
  - See smoke test 7 in `examples\smoke_test.cmd`.
- `iconx.cmd`
  - This is a "convenience script" for invoking `bin\nticonx.exe`:
- `iconx.exe`
  - This is a "convenience program" that calls `iconx.cmd`, passing all of its arguments through to `iconx.cmd`.
  - This allows one to put `iconx myicodefile` into a batch file without the word `call` as would be required for `call icont.cmd myicodefile` for execution to resume in the calling batch file.
  - See [the `README.md` file in the `src` directory](./src/README.md) for an explanation.
- `icon.cmd`
  - This is a "convenience script" for both compiling a `.icn` file and running it with the supplied arguments.
  - usage: `icon [options for icont] [program.icn or -] [args]`
    - Note that passing options of icont is an extension that is not allowed on the Unix builds of Icon.
  - "Shebang - scripting with Icon" makes use of this script.
  - See smoke test 9 in `examples\smoke_test.cmd`.
- `#!icon.cmd`
  - This script facilitates construction of scripts that are valid Icon source code and may be just-in-time translated and executed.  
  - See `example\example_shebang.cmd` and `example\#!icon.cmd` to see how to reference and use this script.

### Examples of how to use the top-level files

- `examples\smoke_test.cmd`
  - This demonstrates use of most of the files in the repository (at the top level and within `examples`).
  - See [`examples\smoke_test.output.expected.txt`](./examples/smoke_test.output.expected.txt) for the expected output.
  - Admittedly, it isn't highly readable.
- `examples\run_smoke_test.cmd`
  - This runs `smoke_test.cmd` and compares the actual output to the expected output.
  - This sets a zero exit code (accessible through the ERRORLEVEL pseudo-environment variable) when all tests pass and nonzero otherwise.
- `examples\example_shebang.cmd` and `examples\#!icon.cmd` leverage `icon.cmd` to execute a self-translating script that is still valid Icon source code.
  - See smoke test 8 in `examples\smoke_test.cmd`.
  - See also "Shebang - scripting with Icon" for details.
- `examples\example_stdin.cmd` is a simple example of how to translate and run Icon source code from a script file, passing arguments.
  - The script is *not* valid Icon source code as a consequence.
  - See smoke test 3 in `examples\smoke_test.cmd`.
  - See also "Shebang - scripting with Icon" for details.

### Files that you do not need to interact with directly

The following files are used by the top level programs; you shouldn't need to interact with them directly.

- `bin\nticont.exe`
  - This is the actual Icon translator.
  - When invoked without the `-o` argument, this writes "icode" to a (non-functional) `.exe` with the same name as the `.icn` file, in the same directory.
  - See `icont.*` below for a convenient way to invoke this indirectly.
  - [`options_nticont.md`](./options_nticont.md) describes the options that may be passed for `nticont` and the environment variables that may be set for running the translated program.
    - This is drawn from [the `icont` reference material](https://cs.arizona.edu/icon/refernce/icontx.htm#icont).
- `bin\nticonx.exe`
  - This is the actual Icon interpreter, which executes "icode".
  - See `iconx.*` for a convenient way to invoke this indirectly.
- `bin\smudge.cmd` is a small utility that converts an "icode" file into a `.bat` file that locates and invokes the virtual machine; the search order is:
  1. The path set in the `ICONX` environment variable.
  1. `nticonx.exe` if it exists in the same directory as the `.bat` file. 
      - This is to mimic the behavior of the Unix build; it requires copies of `bin\nticonx.exe` and `bin\cygwin1.dll` to be in the directory as well.
        - When you supply the argument `--standalone` to `icont.*` or to `bin\smudge.cmd`, these files will be copied to the output directory if they do not already exist there.
  1. `bin\nticonx.exe` if it still exists (i.e., if it has not been moved since the `.bat` file was produced).
  1. The first `iconx.exe`, `iconx.bat`, or `iconx.cmd` on the executable path, i.e., the `PATH` environmental variable.

## Shebang - scripting with Icon

One option is to do just-in-time translation of your Icon source program. The `examples\example_shebang.cmd` and `examples\#!icon.cmd` scripts together:

- translate and run an Icon source code on-the-fly, and
- allow the script to be a valid Icon source file, *but*
- you get the first line on the standard output unless:
  - you run `echo off` before running it or
  - you run it from another script that has echo off.

For this to work, a batch script named `#!icon.cmd` must be on your PATH and, if not this `examples\#!icon.cmd`, must pass control to the `#!icon.cmd` script in the directory containing `icon.cmd`.

- In other words, I don't have to have this script on my PATH *per se*, as long as I have another (trivial) script on my path containing one line, e.g.:
  - `@"C:\Users\art\src\portableIcon\#!icon.cmd" %*`

See test 8 in `smoke_test.cmd`.

## Bugs

So far, I have not found a way to express an IPATH or LPATH that has directories that themselves include spaces, except by using ["8.3" filenames](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).

# Portable Icon 9.3.2

A portable version of Icon 9.3.2 is available on the `icon_v9.3.2` branch:

- That version can be used to create stand-alone binaries.
- A release of that version is available at [https://github.com/eschen42/portableIcon/releases/tag/v9.3.2_rc1](https://github.com/eschen42/portableIcon/releases/tag/v9.3.2_rc1).
- For a description, see [https://github.com/eschen42/portableIcon/tree/icon_v9.3.2](https://github.com/eschen42/portableIcon/tree/icon_v9.3.2)
