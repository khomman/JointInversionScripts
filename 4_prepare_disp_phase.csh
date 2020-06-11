#!/bin/csh
# Creates dispersion measurements for joint inversion

ls rftn_* > list
foreach i (`cat list`)
set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
end

awk '{print $1, $2}' *.pvel > disp.tmp

sac << EOF > /dev/null
readtable content p disp.tmp
w crayl.$kstnm
q
EOF

awk '{print $1, $2}' *.gvel > disp.tmp

sac << EOF > /dev/null
readtable content p disp.tmp
w urayl.$kstnm
q
EOF

rm disp.tmp list
