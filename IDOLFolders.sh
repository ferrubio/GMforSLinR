#!/bin/bash 

robots=(Dumbo Minnie)
foldRob=(dum min)
cond=(Cloudy Night Sunny)
foldCond=(cloudy night sunny)

for m in {0..1}
do
    mkdir datasets/KTH-IDOL/${robots[$m]}/
    for j in {0..2}
    do
        for k in {1..4}
        do
            mkdir datasets/KTH-IDOL/${foldRob[$m]}_${foldCond[$j]}$k
            tar -xf datasets/KTH-IDOL/${foldRob[$m]}_${foldCond[$j]}$k.tar -C datasets/KTH-IDOL/${foldRob[$m]}_${foldCond[$j]}$k
            mv datasets/KTH-IDOL/${foldRob[$m]}_${foldCond[$j]}$k/png datasets/KTH-IDOL/${robots[$m]}/${cond[$j]}$k
            rm -r datasets/KTH-IDOL/${foldRob[$m]}_${foldCond[$j]}$k/
        done
    done
done
