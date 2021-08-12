@REM findstr vim: sw=2 ts=2 et ai syntax=icon :
@(findstr /v findstr %~dpnxs0) | "%~dps0..\icon" - %* & goto :eof || goto :eof

# world.icn is the Icon program to be translated and run

procedure main(args)
  write("There are ", *args, " args")
  every write(!args)
  every write(&features)
  write(&version)
end

