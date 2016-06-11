#!/usr/local/bin/gnuplot

#set term canvas enhanced font 'Helvetica,10'

set terminal png
set output "e0_workload.png"


set style data histogram
set style histogram cluster gap 1
set size square
set size ratio 0.5
set boxwidth 0.5
set grid y x
set style fill transparent solid 0.5
#set border 0
set style line 1 lc rgb "black" lt 5 dashtype 3
set style line 2 lc rgb "black" lt 6 dashtype 3
set key invert


set y2range [0:150]
set y2tics "25" nomirror
set yrange [0:100]
set ytics "10" nomirror

set xtics nomirror
set xlabel 'Tamanho dos Pacotes de Rede' 
set y2label 'Taxa de Transferência (Mb/s)'  rotate by 90
set ylabel 'Uso CPU %'  rotate by 90

set auto x
plot 'e0_workload_definition.dat' using 3:xtic(1) title col axes x1y1 with linespoints ls 1, \
        '' using 2:xtic(1) title col axes x1y2 with linespoints ls 2 
        
        


 
        
