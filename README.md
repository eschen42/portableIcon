# Portable Icon 9.3.2

## Motivation

Sometimes a small, single-file binary is what's needed for a simple task.  Frequently, Icon/Unicon can be an expressive and enjoyable way to write software to accomplish the task.
- This repository provides is a portable collection of binary and library files for running Icon 9.3.2 for Windows (compiled February 20, 1999) that has been tested on Windows 10.
 - Icon 9.3.2 for Windows produces binaries as small as 260kb that:
   - include the Icon Virtual Machine, and
   - are without external dependencies.
- The repository also provides rudimentary support for writing scripts in Icon.

### Background

Icon [https://cs.arizona.edu/icon/](https://cs.arizona.edu/icon/) is a high-level, general-purpose programming language that is in the public domain.  It runs on an efficient virtual machine.  There exists [a modern build of Icon for Windows (from 2015)](https://www2.cs.arizona.edu/icon/v95w.htm) for which source code is not presently available.

There is also an actively developed language extending Icon called Unicon that is preferred for general software development because it provides multithreading and better integration with networking, databases, messaging, file attributes, and the operating system: [http://unicon.org/](http://unicon.org/).  Unicon stand-alone binaries have a minimum size of about 5.5mb (20-fold higher than Icon).

## Files

- `nticont.exe` is the translator.
  - When invoked without the `-o` argument, this produces a `.exe` with the same name as the `.icn` file, in the same directory.
- `nticonx.exe` is the virtual machine, which normally is incorporated into the built executable.
  - In other words, `nticont.exe` builds an executable that runs without dependecies on any other files or shared libraries.
- [`options_nticont.md`](./options_nticont.md) describes the options that may be passed for `nticont` and the environment variables that may be set for running the translated program.
  - This is drawn from [the reference page](https://cs.arizona.edu/icon/refernce/icontx.htm#icont) and [the v9.32 source code](https://cs.arizona.edu/icon/ftp/packages/unix/).
- `examples\smoke_test.cmd` demonstrates use of the following files:
- `icont.cmd` is a "convenience script" for invoking `nticont.exe` from a "portable directory":
  - It passes all arguments through to `nticont.exe` *after* it:
    - Ensures that the portable directory (which contains `nticont.exe` and `nticont.exe`) is in PATH.
    - Ensures that IPATH points to the included IPL,
      - This must have no spaces, but it is only used at translation time.
    - Ensures that a `noop.bat` file exists in the current directory.
      - Smoke tests 4, 5, and 6 demonstrate scenarios where this is necessary because the translator was invoked with the `-s` option.
  - Run `icont.cmd` without any arguments for a list of options.
- `examples\example_stdin.cmd` is a simple if not silly example of how to translate and run Icon source code from a script file, passing arguments.
  - See the third example in `smoke_test.cmd`.

## Bugs

So far, I have not found a way to express an IPATH or LPATH that has directories that themselves include spaces.

## Smaller binaries

In the event that `nticonx.exe` is not on the PATH, a `.bat` file will be produced:
- This file will not run as a batch file because it does not include the Icon Virtual Machine.
- However, the path to it may be passed to `nticonx.exe` (as the first argument) to run it.
  - See the fourth example in `smoke_test.cmd`.
  - It can also be run by putting `ntconx.exe` on your path, however:
    - You will need to run it with `cmd` or `start`
    - See the fifth and sixth examples in `smoke_test.cmd`.
