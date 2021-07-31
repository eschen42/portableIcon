#!icon "%~dpnx0" %*

# world.icn is the Icon program to be translated and run

procedure main(args)
  write("There are ", *args, " args")
  every write(!args)
  every write(&features)
  write(&version)
end

