# Portable Icon 9.3.2

## Motivation
Sometimes a small, single-file binary is what's needed for a simple task.  Frequently, Icon/Unicon can be an expressive and enjoyable way to write software to accomplish the task.  This repository provides is a portable collection of binary and library files for running Icon 9.3.2 for Windows (compiled February 20, 1999) that has been tested on Windows 10.  This produces binaries as small as 260kb that include the Icon Virtual Machine and are without external dependencies.

Icon [https://cs.arizona.edu/icon/](https://cs.arizona.edu/icon/) is a high-level, general-purpose programming language that is in the public domain.  It runs on an efficient virtual machine.  There exists [a modern build of Icon for Windows (from 2015)](https://www2.cs.arizona.edu/icon/v95w.htm) for which source code is not presently available.  There is also an actively developed language extending Icon called Unicon that is preferred for general software development because it provides multithreading and better integration with networking, databases, messaging, file attributes, and the operating system: [http://unicon.org/](http://unicon.org/).

## Files
- `nticont.exe` is the translator.
- `nticonx.exe` is the virtual machine, which normally is incorporated into the built executable.
  - In other words, `nticont.exe` builds an executable that runs without dependecies on any other files or shared libraries.
- [`options_nticont.md`](./options_nt.md) describes the options that may be passed for `nticont` and the environment variables that may be set for running the translated program.
  - This is drawn from [the reference page](https://cs.arizona.edu/icon/refernce/icontx.htm#icont) and [the v9.32 source code](https://cs.arizona.edu/icon/ftp/packages/unix/).
- `examples\smoke_test.cmd` demonstrates use of the following files:
- `icont.cmd` is a "convenience script" for invoking `nticont.exe`
  - When invoked with a single argument (the path to a `.icn` source file), it produces a `.exe` with the same name in the same directory.
    - This is the most common case, when you are simply compiling a single file.
    - See the first example in `smoke_test.cmd`.
  - Otherwise it passes all arguments through to `nticont.exe`.
    - See the second example in `smoke_test.cmd`.
  - Run `icont.cmd` without any arguments for a list of options.
- `examples\example_stdin.cmd` is a simple if not silly example of how to translate and run Icon source, passing arguments.
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
