#!/usr/local/bin/gnuplot

set terminal svg size 400,300 enhanced fname 'arial'  fsize 10 butt solid
set output 'packetloss.svg'

set size square
set size ratio 0.5
set boxwidth 1
set style fill   pattern 1 border lt -1
set style histogram clustered gap 1
set style data histograms
set grid y lt 0 lw 1 lc rgb "#DCDCDC"

## Last datafile plotted: "data.txt"


set yrange [0:125]
set ytics "25" nomirror
set y2range [0:250]
set y2tics "50" nomirror

set key top center box opaque

set xtics nomirror
set xlabel 'Server Consolidation (Domains)' 
set ylabel 'Packet Loss (%)'  rotate by 90

set offset -1.0,-0.0001,0,0

p 'packetloss.dat' u 2:xticlabel(1) title "AVG" lc rgb "black" lt 3, '' u 3:xticlabel(1) title "MAX" lc rgb "black" lt 3, \
			