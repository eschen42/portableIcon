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

## Files in this repository

- `nticont.exe` is the Icon translator.
  - When invoked without the `-o` argument, this produces a `.exe` with the same name as the `.icn` file, in the same directory.
- `nticonx.exe` is the Icon virtual machine, which normally is incorporated into the built executable.
  - In other words, `nticont.exe` builds an executable that runs without dependecies on any other files or shared libraries.
- [`options_nticont.md`](./options_nticont.md) describes the options that may be passed for `nticont` and the environment variables that may be set for running the translated program.
  - This is drawn from [the reference page](https://cs.arizona.edu/icon/refernce/icontx.htm#icont) and [the v9.32 source code](https://cs.arizona.edu/icon/ftp/packages/unix/).
- [`examples\smoke_test.cmd`](./examples/smoke_test.cmd) demonstrates use of the following files:
  - `icont.cmd` is a "convenience script" for invoking `nticont.exe` from a "portable directory":
    - It passes all arguments through to `nticont.exe` *after* it:
      - Ensures that the portable directory (which contains `nticont.exe` and `nticonx.exe`) is in PATH.
      - Ensures that IPATH points to the included IPL,
        - This must have no spaces, but it is only used at translation time.
          - The workaround is to use ["short file names"](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).
          - You can discover them using `dir /x`.
      - Ensures that a `noop.bat` file exists in the current directory.
        - Smoke tests 4, 5, and 6 in `smoke_test.cmd` demonstrate scenarios where this is necessary because the translator was invoked with the `-s` option.
    - Run `icont.cmd` without any arguments for a list of options.
  - `icont_nopath.cmd` invokes `icont` with a directive **not** to ensure that the portable directry is on the PATH.
    - On the other hand, if it does nothing to move the portable directory from the PATH, either.
    - See the "Just `icode` please" section below for details.
    - See smoke test 7 in `smoke_test.cmd`.
  - `smudge_nopath.cmd` complements `icont_nopath.cmd`.
    - See the "Just `icode` please" section below for details.
    - See smoke test 7 in `smoke_test.cmd`.
  - `examples\example_stdin.cmd` is a simple if not silly example of how to translate and run Icon source code from a script file, passing arguments.
    - See smoke test 3 in `smoke_test.cmd`.
    - See also "Shebang - scripting with Icon" for details.
  - `examples\example_shebang.cmd` and `#!icon.cmd` work together to avoid copying the virtual machine when translating and running an Icon script on-the-fly.
    - See smoke test 8 in `smoke_test.cmd`.
    - See also "Shebang - scripting with Icon" for details.

## Stand-alone `.exe` files and `PATH`

The `nticont.exe` and `nticonx` programs *only need to be on your computer when you translate your program* with `icont.cmd` (or `nticont.exe`).
- The resulting runnable program includes both the Icon Virtual Machine (about 255 kb) and the "icode" (Icon bytecode, which is interpreted by the Icon VM) that is produced by the Icon "linker", which is embedded in `nticont.exe`.
- You can put it anywhere or copy it to another machine.
- The `icont.cmd` script is designed to take care of the PATH requirement temporarily, so that you don't need to make permanent changes to your PATH.
  - You can get "one-click translation" of your Icon program with this script (without modifying your PATH) as follows:
    - Right-click on a `.icn` file in Windows File Explorer
    - Choose "Open with ..."
    - Navigate to and select the `icont.cmd` script.
  - You can get translation without altering your PATH by supplying the absolute path to the `icont.cmd` script.

## Just `icode` please

In the event that `nticonx.exe` is not on the PATH, a `.bat` file will be produced.  You will get the following message:
```
  Linking:
  Tried to open wiconx to build .exe, but couldn't
```
This is not an ordinary batch file:
- It's more like a Unix script with a ["shebang"](https://en.wikipedia.org/wiki/Shebang_(Unix)) (that is, `#!`) as the first two characters on the first line.
  - This causes the Unix shell to pass the rest of the file to the interpreter designated on the first line.
- In the case of this batch file, it invokes `nticonx` without any path (or file extension).
  - So, all you need to do to run it is to make sure that `nticonx` is on your PATH when you call the `.bat` file, e.g.,
    - `cmd /c "set PATH=c:\Users\art\src\portable_icon_932&example.bat"`

- Unfortunately, there is not a command line option for icont to trigger this behavior when `nticonx.exe` *is* on your PATH.
  - You could circumvent this by keeping it off your PATH and:
    - either putting `nticonx.exe` elsewhere (not on your PATH).
    - or by invoking `icont_nopath.cmd` instead of invoking `icont_nopath.cmd`
      - Afterward, you will want to run `smudge_nopath.cmd` on the resulting batch file.

If you don't "smudge" the batch file, then it will not run because:
- it does not include the Icon Virtual Machine, and
- it does not know the path to `nticonx.exe` (which smudging supplies).
- In this case, the path to it may be passed to `nticonx.exe` (as the first argument) to run it.
  - For instance:
    - `C:\Users\art\obscure_place\nticonx.exe example.bat`
  - See test 4 in `smoke_test.cmd`.
- It can also be run by putting `nticonx.exe` on your PATH, however:
  - You should run it with `cmd` or `start`
  - You will want to make sure that `noop.bat` is in the current directory or on your PATH and contains one line:
    - `exit /b %ERRORLEVEL%`
    - Note that `icont.cmd` creates `noop.bat` along side of the output file when translation fails for any reason.
  - See tests 5 and 6 in `smoke_test.cmd`.

## Shebang - scripting with Icon

Another option (certainly not limited to Icon) is to do just-in-time translation.
- The `examples\example.cmd` script represents a very incomplete first effort in this regard.
  - No attempt is made by `examples\example.cmd` to run from icode rather than copying the entire interpreter, even though it the translated program right after it runs. 
- The `examples\example_shebang.cmd` and `#!icon.cmd` scripts together:
  - avoid copying the virtual machine when translating and running an Icon script on-the-fly, and
  - allow the script to be a valid Icon source file, *but*
  - you get the first line on the standard output unless
    - you run `echo off` before running it or
    - you run it from another script that has echo off.
  - For this to work, a batch script named `#!icon.cmd` must be on your PATH and, if not this `#!icon.cmd`, must pass control to this one.
    - In other words, I don't have to have this script on my PATH *per se*, as long as I have another (trivial) script on my path containing one line:
      - `@"C:\Users\art\src\portable_icon_932\examples\#!icon.cmd" %*`
  - See test 8 in `smoke_test.cmd`.

## Bugs

So far, I have not found a way to express an IPATH or LPATH that has directories that themselves include spaces, except by using ["8.3" filenames](https://en.wikipedia.org/wiki/8.3_filename#Working_with_short_filenames_in_a_command_prompt).
