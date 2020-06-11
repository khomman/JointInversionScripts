#!/bin/csh

# Usage: 3_control_files_many_rayp.csh p smth

# These are the parameters that are expected in the script.
# p is the ray parameter. and smth is the smoothing factor for the total model
set p = $1
set smth = $2

# Echo errors in case you don't give it parameters
if ( $p == "" || smth == "" ) then
    echo ""
    echo "Error: Undefined p or smoothness"
    echo "Syntax : csh 3_control_files_many_rayp.csh p smth"
    echo "p = influence factor, smth = overall smoothness"
    exit
endif

# Set up the obs.r file 
ls rftn_?f*.???? > list

set nb = 0
foreach k (`cat list`)
	@ nb++ 
end

echo $nb > obs.r

foreach i (`cat list`)
	set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
	set gaussian = `saclst USER0 f $i | awk '{print $2}'`
	set rayp = `saclst USER8 f $i | awk '{print $2}'`
	echo "$i" >> obs.r
	echo $rayp >> obs.r
	echo `printf '%.1f' $gaussian` >> obs.r
	echo 5.0 >> obs.r
end

# Set up the obs.d file
cat << EOF > obs.d
2
'crayl.$kstnm'
2.0 5.0 0.05 0.0001 10
'urayl.$kstnm'
2.0 5.0 0.05 0.0001 10
EOF

# Set up the obs.j file
set layers = `head -1 model.0 | awk '{print $1}'`
cat << EOF > obs.j
6
$p
$smth
-1.0
-1.0
$layers
0.0
EOF

rm list
