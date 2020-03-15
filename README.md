# Portable Icon 9.3.2

Icon [https://cs.arizona.edu/icon/](https://cs.arizona.edu/icon/) is a high-level, general-purpose programming language that is in the public domain.  It runs on an efficient virtual machine.

There exists [a modern build of Icon for Windows (from 2015)](https://www2.cs.arizona.edu/icon/v95w.htm) for which source code is not presently available.

This repository provides is a portable collection of binary and library files for running Icon 9.3.2 for Windows (compiled February 20, 1999) that has been tested on Windows 10.

- [`options_nticont.md`](./options_nt.md) describes the options that may be passed for `nticont` and the environment variables that may be set for running the translated program.
  - This is drawn from [the reference page](https://cs.arizona.edu/icon/refernce/icontx.htm#icont) and [the v9.32 source code](https://cs.arizona.edu/icon/ftp/packages/unix/).
- `nticont.exe` is the translator.
- `nticonx.exe` is the virtual machine, which normally is incorporated into the built executable.
  - In other words, `nticont.exe` builds an executable that runs without dependecies on any other files or shared libraries.
- `icont.cmd` is a "convenience script" for invoking `nticont.exe`
  - When invoked with a single argument (the path to a `.icn` source file), it produces a `.exe` with the same name in the same directory.
    - This is the most common case, when you are simply compiling a single file.
  - Otherwise it passes all arguments through to `nticont.exe`.
    - Run `icont.cmd` without any arguments for a list of options.
- `example_stdin.cmd` is a simple if not silly example of how to translate and run Icon source, passing arguments.
- `smoke_test.cmd` just exercises all of these files.
