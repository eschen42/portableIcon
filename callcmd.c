/* callcmd.c - a Microsoft Windows program to call a CMD file having the same filename
 *
 * Motivation:
 *   If the name of a batch file is invoked from another batch file without a
 *   the word "call" and without piped standard input, execution will not
 *   resume in the invoking batch file after the invoked batch file finishes.
 *
 *   Note that, when a filename ending in ".exe" appears in the same directory
 *   as a filename ending in ".cmd", invoking the filename (without extension)
 *   will result in the execution of the ".exe" file.
 *
 *   This program enables "natural" invocation of a program name from a batch
 *   file without worrying whether whether the name refers to a ".exe" or a
 *   ".cmd".
 *
 * Notes:
 *   Build this program with MinGW64 targeting x86_64-w64-mingw32
 */

// platform inclusions
#include <windows.h>
#include <shlwapi.h> // needed for StrStrIA
// standard inclusions
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define CMDLINE_SIZE 32767

int main( int argc, char *argv[] ) {
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char cmdline[CMDLINE_SIZE] = "cmd /c ";
  char *pos = cmdline + strlen(cmdline);
  char *arg0 = pos;
  DWORD result;
  DWORD last_error;
  int i;

  // ref: https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamea
  result = GetModuleFileName(0, pos, CMDLINE_SIZE - 1);
  if (result < 9) {
    printf("%s: result %d (0x%08X), lasterror %d (0x%08X), when calling GetModuleFileName\n",
        argv[0], result, result, GetLastError(), GetLastError());
    exit(result);
  }
  pos = strrchr(cmdline,'\\');
  if (!pos) {
    printf("%s: internal error - program path is invalid\n'%s'\n",
        argv[0], cmdline);
    return result;
  }
  // https://docs.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-strstria
  pos = StrStrIA(pos, ".exe");
  if (!pos) {
    printf("%s: internal error - program filename extension is invalid\n'%s'\n",
        argv[0], cmdline);
    return result;
  }
  if (strlen(pos) < 4) {
    printf("%s: internal error - string pointer 'pos' is invalid\n'%s'\n",
        argv[0], pos);
    return result;
  }
  *pos = '\0';
  strncat(pos, ".cmd", CMDLINE_SIZE - (5 + (pos - cmdline)));
  // ref: https://stackoverflow.com/a/230068
  //   I used this rather than the PathFileExistsA function defined in shlwapi.h
  //   because PathFileExistsA the latter would not link for me in MinGW64
  if( access( arg0, F_OK ) != 0 ) {
    printf("%s: File '%s' does not exist; you probably should rename '%s'\n",
        argv[0], arg0, argv[0]);
    return ERROR_FILE_NOT_FOUND; // ERROR_FILE_NOT_FOUND = 2 in error.h
  }

  for (i=1; i<argc; ++i) {
    if (!strchr(argv[i],' ')) {
      strncat(cmdline, " ", CMDLINE_SIZE - 2);
      strncat(cmdline, argv[i], CMDLINE_SIZE - (1 + strlen(cmdline) + strlen(argv[i])));
    } else {
      strncat(cmdline, " \"", CMDLINE_SIZE - 3);
      strncat(cmdline, argv[i], CMDLINE_SIZE - (1 + strlen(cmdline) + strlen(argv[i])));
      strncat(cmdline, "\"", CMDLINE_SIZE - 2);
    }
  }

  // ref: https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/aa366877(v=vs.85)
  SecureZeroMemory( &si, sizeof(si) );
  si.cb = sizeof(si);
  SecureZeroMemory( &pi, sizeof(pi) );

  // Start the child process. 
  // ref: https://docs.microsoft.com/en-us/windows/win32/procthread/creating-processes
  // ref: https://github.com/rprichard/win32-console-docs
  if( !CreateProcessA( NULL,   // No module name (use command line)
    //argv[1],        // Command line
    cmdline,        // Command line
    NULL,           // Process handle not inheritable
    NULL,           // Thread handle not inheritable
    FALSE,          // Set handle inheritance to FALSE
    0,              // No creation flags
    NULL,           // Use parent's environment block
    NULL,           // Use parent's starting directory 
    &si,            // Pointer to STARTUPINFO structure
    &pi )           // Pointer to PROCESS_INFORMATION structure
  ) 
  {
    printf( "CreateProcess failed (%d).\n", GetLastError() );
    return GetLastError();
  }

  // Wait until child process exits.
  WaitForSingleObject( pi.hProcess, INFINITE );

  // Close process and thread handles. 
  CloseHandle( pi.hProcess );
  CloseHandle( pi.hThread );

  return 0;
}
// vim: ai sw=2 ts=2 et :
