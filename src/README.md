# About this directory

Use file in this directory as described below to build:

- `..\bin\nticont.exe`
- `..\bin\nticonx.exe`
- `..\icont.exe`
- `..\iconx.exe`

# About `..\bin` and `.\icon\config\cygwin_portable`

To build `..\bin\nticont.exe` and `..\bin\nticonx.exe`, copy this directory is to into the corresponding directory in the Icon source tree of Icon 9.5.2 and compile under Cygwin 3.2.0.

Check back around 14:15 for archive.org captures of these links.
 
Note that `..\bin\cygwin1.dll` is a renamed copy of the Cygnal DLL [http://www.kylheku.com/cygnal/cygwin1-3-1-98-64bit.dll](http://www.kylheku.com/cygnal/cygwin1-3-1-98-64bit.dll), which is required for running these executables outside the context of Cygwin.  This version corresponds to Cygwin 3.2.0's `cygwin1.dll`.  For more information regarding the "Cygwin Native Application Library", see the project homepage: [http://www.kylheku.com/cygnal/](http://www.kylheku.com/cygnal/).

# About `.\callcmd.c`

This is the code to build `..\icont.exe` and `..\iconx.exe` as explained below.

## Purpose of `callcmd.c`

If the name of a batch file is invoked from another batch file without a
the word `call` and without piped standard input, execution will not
resume in the invoking batch file after the invoked batch file finishes.

Note that, when a filename ending in `.exe` appears in the same directory
as a filename ending in `.cmd`, invoking the filename (without extension)
will result in the execution of the `.exe` file.

This program enables "natural" invocation of a program name from a batch
file without worrying whether whether the name refers to a `.exe` or a
`.cmd`.

This program enables `natural` invocation of a program name from a batch
file without worrying whether whether the name refers to a `.exe`, a
`.bat`, or a `.cmd`.  Note that, if both `.bat` and `.cmd` exist, `.bat`
takes priority.


## Building `callcmd.c`

To compile `callcmd.c` with `MinGW64` (installed as described below), use these commands:
```bat
:: strip out debugging and discarded symbols
gcc  -o ..\iconx.exe -Wl,--strip-all callcmd.c
:: same code for icont.exe
copy /y ..\iconx.exe ..\icont.exe
```

To install `Mingw64`, target platform `x86_64-w64-mingw32` by running the MinGW installer (downloadable at [https://sourceforge.net/projects/mingw-w64/](https://sourceforge.net/projects/mingw-w64/)) using these settings:

 - Version: no change; leave at latest
 - Architecture: `x86_64`
 - Threads: `posix`
 - Exception: `seh`
 - Build revision: `0`
 - These settings are as shown in [Figure 1](./#figure-1); ref: [https://azrael.digipen.edu/~mmead/www/public/mingw/index.html#64BIT](https://azrael.digipen.edu/~mmead/www/public/mingw/index.html#64BIT)

## Figure 1

![https://web.archive.org/web/20210811153809im_/https://azrael.digipen.edu/~mmead/www/public/mingw/mingw64-install-2-8.1.png](https://web.archive.org/web/20210811153809im_/https://azrael.digipen.edu/~mmead/www/public/mingw/mingw64-install-2-8.1.png)

Figure 1 - Settings for installation of `MingW64` to target platform `x86_64-w64-mingw32`
