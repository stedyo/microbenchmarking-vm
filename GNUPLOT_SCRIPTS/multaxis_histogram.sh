#!/usr/local/bin/gnuplot

set term latex
set style data histogram
set style histogram cluster gap 1

set yrange [400:900]
set ytics nomirror
set y2range [10:30]
set y2tics

set auto x
set yrange [0:*]
plot 'test_histogram.dat' using 1:xtic(1) title col axes x1y1, \
        '' using 2:xtic(1) title col axes x1y2
        
