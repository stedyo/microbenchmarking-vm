#!/usr/local/bin/gnuplot

set terminal svg size 400,300 enhanced fname 'arial'  fsize 10 butt solid
set output 'jitter.svg'

set size square
set size ratio 0.5
set boxwidth 1
set style fill   pattern 1 border lt -1
set style histogram clustered gap 1
set style data histograms
set grid x2 lt 0 lw 1 lc rgb "#DCDCDC"

## Last datafile plotted: "data.txt"

set yrange [0:0.1]
set ytics "0.025" nomirror
set y2range [0:15]
set y2tics "3" nomirror

set key top center box opaque


set xlabel 'Server Consolidation (Domains)' 
set ylabel 'Jitter (ms)'  rotate by 90 

#set offset -0.3,-0.0001,0,0

set xtics ("1" 150, "2" 450, "4" 750, "8" 1050, "16" 1350) nomirror
set x2tics ("" 300, "" 600, "" 900, "" 1200)


plot "jitter.dat" using 1 axes x1y1 title '1,2,4 Domains'  with impulses lc rgb "#7CFC00",  \
     "jitter.dat" using 2 axes x1y2 title '8,16 Domains' with impulses lc rgb "#B22222"