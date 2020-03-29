#!icon "%~dpnx0" %*

# world.icn is the Icon program to be translated and run

procedure main(args)
  every write(!args)
  every write(&features)
  write(&progname)
  write(&version)
end

