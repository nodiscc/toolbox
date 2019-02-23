#!/usr/bin/env ruby
#Used to play VT100 animations
#Source: http://forums.freebsd.org/showthread.php?t=18278
#Some VT100 animations can be found at http://artscene.textfiles.com/vt100/

pausetime = 0.0005

vtfile = IO.read(ARGV[0])
$stdout.sync = true
vtfile.each_char do |char|
  print char
  sleep pausetime
end
