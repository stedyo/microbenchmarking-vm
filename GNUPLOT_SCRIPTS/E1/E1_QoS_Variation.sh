#!/usr/local/bin/gnuplot

#set term canvas enhanced font 'Helvetica,10'

set terminal png
set output "e1_latency_variation.png"


set style data histogram
set style histogram cluster gap 1
set size square
set size ratio 0.5
set boxwidth 0.5
set grid y2 x
set style fill transparent solid 0.5
#set border 0
set style line 1 lc rgb "black" lt 5 dashtype 3
set style line 2 lc rgb "black" lt 2 dashtype 3



set yrange [0:3]
set ytics "1" nomirror
set y2range [20:70]
set y2tics "10"

set xtics nomirror
set xlabel 'Qtde. Dominios no Sistema Hospedeiro' 
set ylabel 'Latencia Media (ms)'  rotate by 90
set y2label 'Uso CPU (%)'  rotate by 90

set auto x
plot 'e1_qos_variation.dat' using 2:xtic(1) title col axes x1y1 with linespoints ls 1, \
        '' using 3:xtic(1) title col axes x1y2 with linespoints ls 2 
        
        


 
        
