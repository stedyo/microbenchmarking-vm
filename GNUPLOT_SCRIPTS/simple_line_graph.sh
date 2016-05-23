#!/usr/local/bin/gnuplot

set term latex
set title "CPU Usage"
set ytics "20"
plot "test_line.dat" w points
pause -1 "Hit any key to continue"

