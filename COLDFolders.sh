#!/bin/bash 

robots=(Freiburg Ljubljana Saarbrucken)
paths=(PartA-Path1 PartA-Path2 PartB-Path3 PartB-Path4)
cond=(Cloudy Night Sunny)
foldCond=(cloudy night sunny)

for m in {0..2}
do
    for i in {1..4}
    do
        nPath=`expr $i - 1`
        mkdir datasets/COLD/${robots[$m]}/${paths[$nPath]}
        for j in {0..2}
        do
            for k in {1..5}
            do
                tar -xf datasets/COLD/${robots[$m]}/seq${i}_${foldCond[$j]}$k.tar -C datasets/COLD/${robots[$m]}/
                mv datasets/COLD/${robots[$m]}/seq${i}_${foldCond[$j]}$k/std_cam datasets/COLD/${robots[$m]}/${paths[$nPath]}/${cond[$j]}$k
                mv datasets/COLD/${robots[$m]}/seq${i}_${foldCond[$j]}$k/localization/places.lst datasets/COLD/${robots[$m]}/${paths[$nPath]}/${cond[$j]}$k.lst
                rm -r datasets/COLD/${robots[$m]}/seq${i}_${foldCond[$j]}$k/
            done
        done
    done
done
