# Command line options for Windows `Icon-2 Version 9.3.2.  February 20, 1999`

References:
- [https://web.archive.org/web/20000902165350/http://www.cs.arizona.edu/icon/refernce/icontx.htm](Capture from 2000 of http://www.cs.arizona.edu/icon/refernce/icontx.htm)
- [https://web.archive.org/web/20010624161003/http://www.cs.arizona.edu/icon/ftp/packages/unix/icon.v932src.tgz](v9.3.2 source code tgz)
  - BSD tar could understand this archive:
    - `bsdtar 3.3.2 - libarchive 3.3.2 zlib/1.2.5.f-ipp`
  - GNU tar could not:
    - `tar (GNU tar) 1.12`

## `nticont` - Icon Translator

```
usage: icont [-cstuEIX] [-fs] [-e efile] [-o ofile] file ... [-x args]
```
From `src/icont/tmain.c`:

- `-c` (line 644) compile only
  - Perform no linking, just produce `.u1` and `.u2` files
- `-fs` prevent removal of all unreferenced declarations
  - same as putting "invocable all" in your program
- `-s` (line 644) suppress informative messages
- `-t` (line 689) turn on procedure tracing
- `-u` (line 692) warn about undeclared ids
- `-v n` set verbosity of output, where n = 
  - `0` suppress non-error output (same as -s)
  - `1` list procedure names (the default)
  - `2` also report the sizes of icode sections (procedures, strings, and so forth)
  - `3` also list discarded globals
- `-E` (Line 609) preprocess only
- `-I` (line 631) do not make EXE
  - This is apparently ignored because it is not applicable to this build.
- `-X` (line 631) make EXE 
  - This is apparently the default.

Line 938 of `src/icont/tmain.c` reads from `nticonx.exe` as long as it is in the current directory or accessible via the `PATH` environment variable.

### `nticont` search paths:
```
Name         Default    Description
--------     -------    -----------------------
IPATH        none       search path for link directives
LPATH        none       search path for $include directives
```
Search paths are blank-separated lists of directories. The current directory is searched before a search path is used.

## `nticonx` - Icon Interpreter

```
usage: iconx icode-file-name [arguments for Icon program]
```

### Environment variables recognized at runtime

```
Name         Default    Description
--------     -------    -----------------------
TRACE              0    Initial value for &trace.
NOERRBUF   undefined    If set, &errout is not buffered.
STRSIZE       500000    Initial size (bytes) of string region (strings).
BLKSIZE       500000    Initial size (bytes) of block region (most objects).
COEXPSIZE       2000    Size (long words) of co-expression blocks.
MSTKSIZE       10000    Size (long words) of main interpreter stack.
```

```
icon9.32_src/src$ grep -n "case '.':" icont/tmain.c 
298:	 case '"': {
607:         case 'C':			/* Ignore: compiler only */
609:         case 'E':			/* -E: preprocess only */
614:         case 'L':			/* -L: enable linker debugging */
622:         case 'S':			/* -S */
627:         case 'X':			/* -X */
634:         case 'I':			/* -C */
638:         case 'A':
644:         case 'c':			/* -c: compile only (no linking) */
647:         case 'e':			/* -e file: redirect stderr */
650:         case 'f':			/* -f features: enable features */
656:	 case 'i':                      /* -i: Don't create .EXE file */
661:         case 'm':			/* -m: preprocess using m4(1) [UNIX] */
664:         case 'n':			/* Ignore: compiler only */
666:         case 'o':			/* -o file: name output file */
670:         case 'p':			/* -p path: iconx path [ATARI] */
679:	 case 'q':
683:         case 'r':			/* Ignore: compiler only */
685:         case 's':			/* -s: suppress informative messages */
689:         case 't':			/* -t: turn on procedure tracing */
692:         case 'u':			/* -u: warn about undeclared ids */
695:         case 'v':			/* -v n: set verbosity level */
702:         case 'x':			/* -x illegal until after file list */
```
