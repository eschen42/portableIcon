# About this directory

Use file in this directory as described below to build:

- The `icon=9.5.2` conda package in the `eschen42` channel.
- `..\bin\nticont.exe`
- `..\bin\nticonx.exe`
- `..\icont.exe`
- `..\iconx.exe`

## About the `icon=9.5.2` package in the `eschen42` conda channel

The `icon-9.5.2` package in the `eschen42` conda channel was built from
the `master` branch on GitHub by running:
```
conda_build_portableIcon_master.cmd
```
which downloads the zip of the HEAD and invokes `conda-build`.

## About `..\bin` and `.\icon\config\cygwin_portable`

To build `..\bin\nticont.exe` and `..\bin\nticonx.exe`, copy `icon\config\cygwin_portable` to into the corresponding directory in the Icon source tree of Icon 9.5.2 and compile within the Cygwin 3.2.0 environment, which links them to that environment's `cygwin1.dll`.  Note that their functionality on Microsoft Windows outside of the Cygwin environment is somewhat limited.

Cygnal is Kaz Kylheku's "Cygwin Native Application Layer" that
> provides a patched cygwin1.dll object which changes some of the
 [Cygwin `cygwin1.dll`] behaviors such that they make sense in the
 context of a Windows application.
 Cygwin executables do not have to be recompiled to use the Cygnal library.
 They just have to be bundled with it; it is a drop-in replacement.

For information regarding the "Cygwin Native Application Library", see the Cygnal project homepage [http://www.kylheku.com/cygnal/](https://web.archive.org/web/20210811182329im_/http://www.kylheku.com/cygnal/).

The `..\bin\cygwin1.dll` is a renamed copy of the Cygnal DLL ([http://www.kylheku.com/cygnal/cygwin1-3-1-98-64bit.dll](https://web.archive.org/web/20210817124227im_/http://www.kylheku.com/cygnal/cygwin1-3-1-98-64bit.dll), having SHA256 checksum 6929bf6781c322597584dcb71fbe36f836017a4704bcaad2ca5959b4aa390d30) provided for running these executables outside the context of Cygwin.  This version corresponds only to the `cygwin1.dll` from Cygwin 3.2.0, which is to say that it only works with executables linked against the Cygwin 3.2.0 `cygwin1.dll`.  Because this DLL is derived from the Cygwin DLL, it is licensed under [LGPLv3](https://www.gnu.org/licenses/lgpl-3.0-standalone.html), making it freely distributable with the license notice; see [https://cygwin.com/licensing.html](https://cygwin.com/licensing.html).

## About `.\callcmd.c`

This is the code to build `..\icont.exe` and `..\iconx.exe` as explained below.

### Purpose of `callcmd.c`

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


### Building `callcmd.c`

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

### Figure 1

![https://web.archive.org/web/20210811153809im_/https://azrael.digipen.edu/~mmead/www/public/mingw/mingw64-install-2-8.1.png](https://web.archive.org/web/20210811153809im_/https://azrael.digipen.edu/~mmead/www/public/mingw/mingw64-install-2-8.1.png)

Figure 1 - Settings for installation of `MingW64` to target platform `x86_64-w64-mingw32`
