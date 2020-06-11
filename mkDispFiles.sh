base=/Users/khomman/Documents/JointInversionPA
for net in `cat NetList`
do
  cd ${net}
  for sta in `cat StaList`
  do
    echo ${net}_${sta}
   # awk '{if ($2=="R" && $3=="U") print $0}' ${sta}/${net}_${sta}_DispCurves_2020.txt > ${sta}/${sta}RayleighGroup_2020
   # awk '{if ($2=="R" && $3=="C") print $0}' ${sta}/${net}_${sta}_DispCurves_2020.txt > ${sta}/${sta}RayleighPhase_2020
   # awk '{if ($2=="L" && $3=="U") print $0}' ${sta}/${net}_${sta}_DispCurves_2020.txt > ${sta}/${sta}LoveGroup_2020
   # awk '{if ($2=="L" && $3=="C") print $0}' ${sta}/${net}_${sta}_DispCurves_2020.txt > ${sta}/${sta}LovePhase_2020
    awk '{if ($2=="R" && $3=="U") print $0}' ${sta}/${net}_${sta}_DispCurves_longT_2020.txt > ${sta}/${sta}RayleighGroup_longT_2020
    awk '{if ($2=="R" && $3=="C") print $0}' ${sta}/${net}_${sta}_DispCurves_longT_2020.txt > ${sta}/${sta}RayleighPhase_longT_2020
    awk '{if ($2=="L" && $3=="U") print $0}' ${sta}/${net}_${sta}_DispCurves_longT_2020.txt > ${sta}/${sta}LoveGroup_longT_2020
    awk '{if ($2=="L" && $3=="C") print $0}' ${sta}/${net}_${sta}_DispCurves_longT_2020.txt > ${sta}/${sta}LovePhase_longT_2020
   done
  cd ${base}
done
