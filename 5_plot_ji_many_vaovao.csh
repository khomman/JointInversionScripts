#!/bin/csh
# Modified by Cristo on 02/2016
# Plots Joint inversion model results
gmt gmtset MAP_FRAME_TYPE FANCY PROJ_LENGTH_UNIT CM FONT_ANNOT_PRIMARY 12
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE PS_MEDIA A4 FONT_LABEL 12
gmt gmtset MAP_FRAME_PEN 1 MAP_TICK_LENGTH_PRIMARY 0.1

# Set up the 
ls rftn_?f??.???? > list
set iteration = `head -n1 obs.j`
set isa_rf = `head -n1 obs.r`
set kstnm = `head -n1 list | awk -F. '{print $2}'`
set tmp=`pwd`
set file=`basename $tmp` 
set psfile=${kstnm}_${file}.ps
##############################
### Plot RFs.
echo Plotting the Receiver Functions for $kstnm.
set latmax = `echo $isa_rf | awk '{print (($1)+0.7)}'`
gmt psbasemap -R-5/40/0.7/$latmax -JX8/17 -BSwnE -Bx+l"Time (s)" -By+l"Receiver functions" -Bx10,g100 -By1,g1  -V -X19 -K > $psfile

set y1 = 0
foreach rf (`cat list`)
	@ y1++
	set syn_rf = `echo $rf | awk -v it=$iteration -F_ '{print "syn." it $2}' | awk -F. '{print $1"."$2".rftn"}'`
#	set syn_rf = `echo $rf | awk -v `
	echo $syn_rf
	# observed
	sac2xy 1 $rf $y1 > rftn.asc
	gmt psxy rftn.asc -R -JX -W01.2p,black -K -V -O >> $psfile

	#sac2xy 1 ${rf}_plus $y1 > rftn.asc
	#gmt psxy rftn.asc -R -JX -W0.2p,black -K -O >> $psfile
	
	#sac2xy 1 ${rf}_minus $y1 > rftn.asc
	#gmt psxy rftn.asc -R -JX -W0.2p,black -K -O >> $psfile
	
	#predicted
#foreach m (.1 .2 .3 .4 .6 .7 .8 .9)
#	sac2xy 1 ${syn_rf}_${m} $y1 > rftn.asc
#	gmt psxy rftn.asc -R -JX -W1p,red -K -O >> $psfile
#end
	sac2xy 1 ${syn_rf} $y1 > rftn.asc
	gmt psxy rftn.asc -R -JX -W1p,red -K -O >> $psfile

	set isa = `saclst USER1 f $rf | awk '{print $2}'`
	set baz = `saclst USER6 f $rf | awk '{print $2}'`
	set baz = `printf '%.0f' $baz`
	set sdbaz = `saclst USER7 f $rf | awk '{print $2}'`
	set sdbaz = `printf '%.0f' $sdbaz`	
	set rayp = `saclst USER8 f $rf | awk '{print $2}'`
	set rayp = `printf '%.3f' $rayp`
	set sdrayp = `saclst USER9 f $rf | awk '{print $2}'`
	set sdrayp = `printf '%.3f' $sdrayp`

	set y3 = `echo $y1 | awk '{print (($1)+0.2)}'`
	set y4 = `echo $y1 | awk '{print (($1)-0.25)}'`
	
echo 18 $y4 Ray_p 0.0`echo $rf | awk -F_ '{print substr($2,3,2) }'` | gmt pstext -R -JX -F+f11p,Helvetica,black+jLB+a0 -K -O >> $psfile

@ x++

end
###########################

################################################################################
################################################################################
### Plot dispersion curves.
echo Plotting the Phase velocities for $kstnm.
# Observed - phase
sac2xy 2 ./crayl.$kstnm > disp.asc
gmt psxy disp.asc -R0/125/2.5/5.0 -JX5/4 -BSWne -Bx+l"Period" -Byg.5 -By+l"Phase Velocity (km/s)" -Bx30 -By.5 -Sp0.13 -G0/0/0 -X-16 -Y13 -K -O  >> $psfile

# Synthetic - phase
#foreach m (.1 .2 .3 .4 .6 .7 .8 .9)
#sac2xy 2 6cr.syn.disp_${m} > disp.asc
#gmt psxy disp.asc -R -JX -W1.5p,gray -K -O >> $psfile
#end

# Synthetic - phase
sac2xy 2 syn.6cr.disp > disp.asc
gmt psxy disp.asc -R -JX -W1.5p,red -K -O >> $psfile

############################
echo Plotting the Group velocities for $kstnm.
sac2xy 2 ./urayl.$kstnm > disp.asc
gmt psxy disp.asc -R0/70/2.5/5.0 -JX5/4 -BSWne -Bx+l"Period" -Byg.5 -By+l"Group Velocity (km/s)" -Bx15 -By.5 -Sp0.13 -G0/0/0 -X0 -Y-8 -K -O  >> $psfile

# Synthetic - group
#foreach m (.1 .2 .3 .4 .6 .7 .8 .9)
#sac2xy 2 6ur.syn.disp_${m} > disp.asc
#gmt psxy disp.asc -R -JX -W1.5p,gray -K -O >> $psfile
#end

# Observed - group
sac2xy 2 ./urayl.$kstnm > disp.asc
gmt psxy disp.asc -R0/70/2.5/5.0 -JX5/4 -BSWne -Bx+l"Period" -Byg.5 -By+l"Group Velocity (km/s)" -Bx15 -By.5 -Sp0.13 -G0/0/0 -K -O  >> $psfile

#Synthetic - group
sac2xy 2 syn.6ur.disp > disp.asc
gmt psxy disp.asc -R -JX -W1.5p,red -X -K -O >> $psfile
###########################


###########################
### Plot velocity model.
echo Plotting the Velocity Model for $kstnm.

# Initial Model
sac2xy 2 model.0.vs 0.0 > model.asc
gmt psxy model.asc -R2.5/5/-100/0 -JX7/16 -BSwEn -Bx.5 -Bxg.5 -By10 -Byg5 -Bx+l"Vs (km/s)" -By+l"Depth (km)" -W1.3p,0/0/0 -X6 -Y-4 -K -O >> $psfile
#+t"Station $kstnm"

# Final Model
#foreach m (.1 .2 .3 .4 .6 .7 .8 .9 .5) # this attempts to get the error bound for using .1 to .9 influence factor
#sac2xy 2 model.6.vs_${m} 0.0 > model.asc
#gmt psxy model.asc -R -JX -W2p,gray -K -O >> $psfile
#end

sac2xy 2 model.6.vs 0.0 > model.asc
gmt psxy model.asc -R -JX -W2p,red -K -O >> $psfile
mv model.asc model6.txt

# Plot the velocity profiles for Julien's results
# Low Frequency
#if ( -e ../${kstnm}_chap.m ) then
#set di=`awk 'NR==3{print 1/$5}' /Users/Cristo/Documents/Seismic/Ant_Joint_Inv/INVERSION/Stations/ALL/RESULTS/HkStack/${kstnm}.m`
#awk -v di=$di '{print $1*di, $2}' ../${kstnm}_chap.m |  gmt psxy  -R -JX -W2p,0/210/210 -K -O >> $psfile
#endif
# High Frequency
#if ( -e ../${kstnm}_chap.m ) then
#set di=`awk 'NR==8{print 1/$5}' /Users/Cristo/Documents/Seismic/Ant_Joint_Inv/INVERSION/Stations/ALL/RESULTS/HkStack/${kstnm}.m`
#awk -v di=$di '{print $1*di, $2}' ../${kstnm}_chap.m |  gmt psxy  -R -JX -W2p,210/210/0 -K -O >> $psfile
#endif
# 
#if ( $di == "" ) then
#awk '{print $1*(1/1.6), $2}' ../${kstnm}_chap.m |  gmt psxy  -R -JX -W2p,130/130/130 -K -O >> $psfile
#endif

# Create the dotted and dashed lines
# dashed
gmt psxy  -R -JX -W1.5p,- -K -O << EOF >> $psfile
4 0
4 -150
EOF
# dotted
gmt psxy -R -JX -W1.5p,. -K -O << EOF >> $psfile
4.3 0
4.3 -150
EOF
###########################
#Legend
echo 2 13 $kstnm   | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f20p,Helvetica-Bold,black+jLT+a0 -N -K -O >> $psfile
echo 2 6 Inversion | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f14p,Helvetica-Bold,red+jLB+a0   -N -K -O >> $psfile
echo 2 2 Starting model | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f14p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
# Label0
echo -25 92 A\) | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f18p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
echo -25 52 B\) | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f18p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
echo 2 92 C\) | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f18p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
echo 40 92 D\) | gmt pstext -JX25c/18c -R0/0/100/100r -Gwhite -F+f18p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile


###########################
#Lower left 
#set dir=/Users/Cristo/Documents/Seismic/Ant_Joint_Inv/INVERSION/Stations/ALL/RESULTS

#gmt psbasemap -R0/40/15/65 -JX3/6 -BWsen  -X-7 -K -O >> $psfile

# Joint Inversion
#echo 0 60 J. Inversion Moho Depth: `grep $kstnm $dir/results.m | awk '{print $2}'` km | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#echo 0 55 Average crustal Vs: `grep $kstnm $dir/results.m | awk '{print $3}'` km/s | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
## Hk Results
#if ( `grep $kstnm $dir/results.m | awk '{print $4}'` > 0 ) then
#echo 0 50 H-k stacking Moho Depth: `grep $kstnm $dir/results.m | awk '{print $4}'` km | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#echo 0 45 H-k stacking Vp/Vs: `grep $kstnm $dir/results.m | awk '{print $7}'`   | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#else if ( `grep $kstnm $dir/results.m | awk '{print $16}'` > 0 ) then
#echo 0 50 H-k stacking Moho Depth: `grep $kstnm $dir/results.m | awk '{print $16}'` km | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#echo 0 45 H-k stacking Vp/Vs: `grep $kstnm $dir/results.m | awk '{print $19}'`  | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#else if ( `grep $kstnm $dir/results.m | awk '{print $10}'` > 0 ) then
#echo 0 50 H-k stacking Moho Depth: `grep $kstnm $dir/results.m | awk '{print $10}'` km | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#echo 0 45 H-k stacking Vp/Vs: `grep $kstnm $dir/results.m | awk '{print $13}'`  | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile
#endif
## Poisson's
#echo 0 40 Poisson\'s ratio: `grep $kstnm $dir/results.m | awk '{print $22}'` | gmt pstext -R -J -F+f12p,Helvetica-Bold,black+jLB+a0 -N -K -O >> $psfile







