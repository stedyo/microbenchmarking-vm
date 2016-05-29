#!/usr/local/bin/gnuplot

set term canvas enhanced font 'Helvetica,10'
#set title "Variação de Taxa de Transmissão e Utilização de CPU"

set rmargin 5
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




set yrange [100:120]
set ytics "5" nomirror
set y2range [0:100]
set y2tics "10"

set xtics nomirror
set xlabel 'Tamanho dos Pacotes de Rede' 
set ylabel 'Taxa de Transmissao (MB/S)'  rotate by 90
set y2label 'Uso CPU (%)'  rotate by 90

set auto x
plot 'E0_Workload_Definition_Multaxis_Histogram_DATA.dat' using 2:xtic(1) title col axes x1y1 with linespoints ls 1, \
        '' using 3:xtic(1) title col axes x1y2 with linespoints ls 2 
        
        


 
        
