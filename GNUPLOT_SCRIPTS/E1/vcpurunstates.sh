#!/usr/local/bin/gnuplot

# Scale font and line width (dpi) by changing the size! It will always display stretched.
set terminal svg size 400,300 enhanced fname 'arial'  fsize 10 butt solid
set output 'vcpurunstates.svg'

set style data histogram
set style histogram cluster gap 1
set size square
set size ratio 0.5
set boxwidth 0.5
set grid y x
set style fill transparent solid 0.5
#set border 0


set key top right box opaque

set yrange [0:100]
set ytics "20" nomirror



set xtics nomirror
set xlabel 'Server Consolidation (Domains)' 
set ylabel 'vCPU RUNSTATES (sec)'  rotate by 90


set auto x

plot "vcpurunstates.dat" using 2:xtic(1)  title 'Running'  with linespoint lc rgb "black" lt 3 ,  \
     "vcpurunstates.dat" using 3:xtic(1) title 'Runnable' with linespoint lc rgb "black" lt 5, \
     "vcpurunstates.dat" using 4:xtic(1) title 'Blocked' with linespoint lc rgb "black" lt 7
