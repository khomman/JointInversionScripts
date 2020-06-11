#!/bin/csh
#
# Script by H. Tkalcic 2012 for ASC Workshop
#
# Stack RFs for a given ray parameter grouping
set RAYP = $1

cd HF/rayp$RAYP
#mi-stack
set i = 1

########### (1)
foreach a ( `ls *.eqr | cat` )
set sacfile = `ls *.eqr | awk 'NR==k {print $1}' k=$i`
if ( $i == 1 ) then
echo "First record ..."

sac << EOF > /dev/null
read $sacfile
mul 0.0
write stack.sac
quit
EOF
echo "Zero file created"
endif

sac << EOF > /dev/null
read stack.sac
addf $sacfile
write over
quit
EOF
echo $i ". record added..."
@ i = $i + 1
end
########### (1)

sac << EOF > /dev/null
read stack.sac
div $i
write over
quit
EOF
mv stack.sac rftn_hf$RAYP

#maka header
foreach i (*.eqr)
	set stla = `saclst STLA f $i | awk '{print $2}'`
	set stlo = `saclst STLO f $i | awk '{print $2}'`
	set stel = `saclst STEL f $i | awk '{print $2}'`
	set stdp = `saclst STDP f $i | awk '{print $2}'`
	set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
	set knetwk = `saclst KNETWK f $i | awk '{print $2}'`
end

#normalizing
sac << EOF > /dev/null
r rftn_hf$RAYP
ch stla $stla
ch stlo $stlo
ch stel $stel
ch stdp $stdp
ch kstnm $kstnm
ch knetwk $knetwk
wh
q
EOF

sac << EOF > /dev/null
r rftn_hf$RAYP
ppk
wh
cut t0 -5 t0 +40
r
w over
q
EOF

sac << EOF > /dev/null
r rftn_hf$RAYP
div 1.42
w over
q
EOF

#computing average and stdev
ls *.eqr > list
set nb = 0
foreach i (`cat list`)
	set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
	set user6 = `saclst BAZ f $i | awk '{print $2}'`
	set baz = `printf '%.1f' $user6`
	set user8 = `saclst USER8 f $i | awk '{print $2}'`
	set rayp=`printf '%.3f' $user8`
	echo $rayp >> tmprayp
	echo $baz >> tmpbaz
	@ nb++
end

set meanbaz = `awk '{total+=$1; count++}END{print total/count}' tmpbaz | awk '{print (int($1*10))/10}'`
set sdbaz = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmpbaz | awk '{print (int($1*10))/10}'`
set meanrayp = `awk '{total+=$1; count++}END{print total/count}' tmprayp | awk '{print (int($1*1000))/1000}' `
set sdrayp = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmprayp | awk '{print (int($1*1000))/1000}'`

sac << EOF > /dev/null
r rftn_hf$RAYP
ch user0 2.5
ch user1 $nb
ch user6 $meanbaz
ch user7 $sdbaz
ch user8 $meanrayp
ch user9 $sdrayp
wh
q
EOF
rm list
cp rftn_hf$RAYP ../../rftn_hf$RAYP.$kstnm

###########################

cd ../../LF/rayp$RAYP
#mi-stack
set i = 1
foreach a ( `ls *.eqr | cat` )
set sacfile = `ls *.eqr | awk 'NR==k {print $1}' k=$i`
if ( $i == 1 ) then
echo "First record ..."
sac << EOF > /dev/null
read $sacfile
mul 0.0
write stack.sac
quit
EOF
echo "Zero file created"
endif

sac << EOF > /dev/null
read stack.sac
addf $sacfile
write over
quit
EOF
echo $i ". record added..."
@ i = $i + 1
end

sac << EOF > /dev/null
read stack.sac
div $i
write over
quit
EOF
mv stack.sac rftn_lf$RAYP

#maka header
foreach i (*.eqr)
	set stla = `saclst STLA f $i | awk '{print $2}'`
	set stlo = `saclst STLO f $i | awk '{print $2}'`
	set stel = `saclst STEL f $i | awk '{print $2}'`
	set stdp = `saclst STDP f $i | awk '{print $2}'`
	set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
	set knetwk = `saclst KNETWK f $i | awk '{print $2}'`
end

# Normalizing
sac << EOF > /dev/null
r rftn_lf$RAYP
ch stla $stla
ch stlo $stlo
ch stel $stel
ch stdp $stdp
ch kstnm $kstnm
ch knetwk $knetwk
wh
q
EOF

sac << EOF > /dev/null
r rftn_lf$RAYP
ppk
wh
cut t0 -5 t0 +40
r
w over
q
EOF

sac << EOF > /dev/null
r rftn_lf$RAYP
div 0.564
w over
q
EOF
#computing average and stdev
ls *.eqr > list
set nb = 0
foreach i (`cat list`)
set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
set user6 = `saclst BAZ f $i | awk '{print $2}'`
set baz = `printf '%.1f' $user6`
set user8 = `saclst USER8 f $i | awk '{print $2}'`
set rayp=`printf '%.3f' $user8`
echo $rayp >> tmprayp
echo $baz >> tmpbaz
@ nb++
end
set meanbaz = `awk '{total+=$1; count++}END{print total/count}' tmpbaz | awk '{print (int($1*10))/10}'`
set sdbaz = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmpbaz | awk '{print (int($1*10))/10}'`
set meanrayp = `awk '{total+=$1; count++}END{print total/count}' tmprayp | awk '{print (int($1*1000))/1000}' `
set sdrayp = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmprayp | awk '{print (int($1*1000))/1000}'`

sac << EOF > /dev/null
r rftn_lf$RAYP
ch user0 1.0
ch user1 $nb
ch user6 $meanbaz
ch user7 $sdbaz
ch user8 $meanrayp
ch user9 $sdrayp
wh
q
EOF
rm list
cp rftn_lf$RAYP ../../rftn_lf$RAYP.$kstnm

cd ../../FF/rayp$RAYP
#mi-stack
set i = 1
foreach a ( `ls *.eqr | cat` )
set sacfile = `ls *.eqr | awk 'NR==k {print $1}' k=$i`
if ( $i == 1 ) then
echo "First record ..."
sac << EOF > /dev/null
read $sacfile
mul 0.0
write stack.sac
quit
EOF
echo "Zero file created"
endif

sac << EOF > /dev/null
read stack.sac
addf $sacfile
write over
quit
EOF
echo $i ". record added..."
@ i = $i + 1
end

sac << EOF > /dev/null
read stack.sac
div $i
write over
quit
EOF
mv stack.sac rftn_ff$RAYP

#maka header
foreach i (*.eqr)
	set stla = `saclst STLA f $i | awk '{print $2}'`
	set stlo = `saclst STLO f $i | awk '{print $2}'`
	set stel = `saclst STEL f $i | awk '{print $2}'`
	set stdp = `saclst STDP f $i | awk '{print $2}'`
	set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
	set knetwk = `saclst KNETWK f $i | awk '{print $2}'`
end

# Normalizing
sac << EOF > /dev/null
r rftn_ff$RAYP
ch stla $stla
ch stlo $stlo
ch stel $stel
ch stdp $stdp
ch kstnm $kstnm
ch knetwk $knetwk
wh
q
EOF

sac << EOF > /dev/null
r rftn_ff$RAYP
ppk
wh
cut t0 -5 t0 +40
r
w over
q
EOF

sac << EOF > /dev/null
r rftn_ff$RAYP
div 2.83
w over
q
EOF
#computing average and stdev
ls *.eqr > list
set nb = 0
foreach i (`cat list`)
set kstnm = `saclst KSTNM f $i | awk '{print $2}'`
set user6 = `saclst BAZ f $i | awk '{print $2}'`
set baz = `printf '%.1f' $user6`
set user8 = `saclst USER8 f $i | awk '{print $2}'`
set rayp=`printf '%.3f' $user8`
echo $rayp >> tmprayp
echo $baz >> tmpbaz
@ nb++
end
set meanbaz = `awk '{total+=$1; count++}END{print total/count}' tmpbaz | awk '{print (int($1*10))/10}'`
set sdbaz = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmpbaz | awk '{print (int($1*10))/10}'`
set meanrayp = `awk '{total+=$1; count++}END{print total/count}' tmprayp | awk '{print (int($1*1000))/1000}' `
set sdrayp = `awk '{sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/NR - (sum/NR)^2)}' tmprayp | awk '{print (int($1*1000))/1000}'`

sac << EOF > /dev/null
r rftn_ff$RAYP
ch user0 5.0
ch user1 $nb
ch user6 $meanbaz
ch user7 $sdbaz
ch user8 $meanrayp
ch user9 $sdrayp
wh
q
EOF
rm list
cp rftn_ff$RAYP ../../rftn_ff$RAYP.$kstnm
cd -
