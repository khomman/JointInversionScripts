#!/bin/csh

# This script creates four Rf traces.
# four inputs are needed: Station name, low or high frequency (lf hf),
# crustal thickness and vp/vs ratio.
#
# Usage: raypFig.csh sta fq
# 
# Will have to adjust stdir variable to be top level
# 1 for debug mode, 0 for not
set debug=0

set st=$1
## if fq == lf it will plot 1.0 rfs
## if fq == hf it will plot 2.5 rfs
## if fq == ff it will plot 5.0 rfs
set fq=$2
#set H=$3
#set k=$4

#set st=PARS
#set fq=ff
#set H=4.31
#set k=2.02
set homedir=`pwd`
set stdir=/Users/amanda/Documents/tstRF/TA/

gmt gmtset MAP_FRAME_TYPE FANCY PROJ_LENGTH_UNIT cm
gmt gmtset FONT_ANNOT_PRIMARY 10
gmt gmtset PS_PAGE_ORIENTATION LANDSCAPE
gmt gmtset PS_MEDIA LETTER

set time_min = -5
set time_max = 30

if ( -e ./.GMT_TEMP_FILES/ ) rm -r ./.GMT_TEMP_FILES/
mkdir ./.GMT_TEMP_FILES/

if ( $debug ) echo 1
##############################################
# Smaller number, bigger amplitudes
if ( -e ./.GMT_TEMP_FILES/${st}.in ) rm ./.GMT_TEMP_FILES/${st}.in
if ( $fq == lf ) foreach event (`ls $stdir/$st/rftn/*a=1.0.eqr`)
if ( $fq == lf ) set scale = .5
if ( $fq == hf ) foreach event (`ls $stdir/$st/rftn/*a=2.5.eqr`)
if ( $fq == hf ) set scale = 1
if ( $fq == ff ) foreach event (`ls $stdir/$st/rftn/*a=5.0.eqr`)
if ( $fq == ff ) set scale = 1.5

	# Set up the naming convention
    set rftmp=`basename -s .eqr $event`
    set eqr=${rftmp}.eqr
    set eqt=${rftmp}.eqt

	cd $stdir/$st/rftn
    # Convert sac files to ascii
    sac2xy 1 $eqr > $homedir/.GMT_TEMP_FILES/${eqr}.txt
    sac2xy 1 $eqt > $homedir/.GMT_TEMP_FILES/${eqt}.txt
	cd $homedir

    # Obtain the ray parameter
    set rayp=`saclst USER8 f $event | awk '{print $2}'`

    # Add the text file to the wig file
    awk -v ray=$rayp '{print $1, ray, $2}' < ./.GMT_TEMP_FILES/${eqr}.txt >> ./.GMT_TEMP_FILES/${st}.in
    echo \> >> ./.GMT_TEMP_FILES/${st}.in
end
if ( $debug ) echo 2

####### BackAz
# Smaller number, bigger amplitudes
if ( -e ./.GMT_TEMP_FILES/${st}baz.in ) rm ./.GMT_TEMP_FILES/${st}baz.in
if ( $fq == lf ) foreach event (`ls $stdir/$st/rftn/*a=1.0.eqr`)
if ( $fq == lf ) set scale = .5
if ( $fq == hf ) foreach event (`ls $stdir/$st/rftn/*a=2.5.eqr`)
if ( $fq == hf ) set scale = 1
if ( $fq == ff ) foreach event (`ls $stdir/$st/rftn/*a=5.0.eqr`)
if ( $fq == ff ) set scale = 1.5

	# Set up the naming convention
    set rftmp=`basename -s .eqr $event`
    set eqr=${rftmp}.eqr

    # Obtain the ray parameter
    set baz=`saclst BAZ f $event | awk '{print $2}'`

    # Add the text file to the wig file
    awk -v baz=$baz '{print $1, baz, $2}' < ./.GMT_TEMP_FILES/${eqr}.txt >> ./.GMT_TEMP_FILES/${st}baz.in
    echo \> >> ./.GMT_TEMP_FILES/${st}baz.in
end

####### DIST
# Smaller number, bigger amplitudes
if ( -e ./.GMT_TEMP_FILES/${st}dist.in ) rm ./.GMT_TEMP_FILES/${st}dist.in
if ( $fq == lf ) foreach event (`ls $stdir/$st/rftn/*a=1.0.eqr`)
if ( $fq == lf ) set scale = .5
if ( $fq == hf ) foreach event (`ls $stdir/$st/rftn/*a=2.5.eqr`)
if ( $fq == hf ) set scale = 1
if ( $fq == ff ) foreach event (`ls $stdir/$st/rftn/*a=5.0.eqr`)
if ( $fq == ff ) set scale = 1.5

	# Set up the naming convention
    set rftmp=`basename -s .eqr $event`
    set eqr=${rftmp}.eqr

    # Obtain the ray parameter
    set dist=`saclst GCARC f $event | awk '{print $2}'`

    # Add the text file to the wig file
    awk -v dist=$dist '{print $1, dist, $2}' < ./.GMT_TEMP_FILES/${eqr}.txt >> ./.GMT_TEMP_FILES/${st}dist.in
    echo \> >> ./.GMT_TEMP_FILES/${st}dist.in
end

####### Transverse
# Smaller number, bigger amplitudes
if ( -e ./.GMT_TEMP_FILES/${st}tran.in ) rm ./.GMT_TEMP_FILES/${st}tran.in
if ( $fq == lf ) foreach event (`ls $stdir/$st/rftn/*a=1.0.eqr`)
if ( $fq == lf ) set scale = .5
if ( $fq == hf ) foreach event (`ls $stdir/$st/rftn/*a=2.5.eqr`)
if ( $fq == hf ) set scale = 1
if ( $fq == ff ) foreach event (`ls $stdir/$st/rftn/*a=5.0.eqr`)
if ( $fq == ff ) set scale = 1.5

	# Set up the naming convention
    set rftmp=`basename -s .eqr $event`
    set eqt=${rftmp}.eqt

    # Obtain the ray parameter
    set baz=`saclst BAZ f $event | awk '{print $2}'`

    # Add the text file to the wig file
    awk -v baz=$baz '{print $1, baz, $2}' < ./.GMT_TEMP_FILES/${eqt}.txt >> ./.GMT_TEMP_FILES/${st}tran.in
    echo \> >> ./.GMT_TEMP_FILES/${st}tran.in
end


## Create the ray parameter lines
# if ( -e ./.GMT_TEMP_FILES/rayp_Ps ) rm ./.GMT_TEMP_FILES/rayp_Ps
foreach ray (`jot 100 .04000 .08100`)
set rayp_Ps=`echo 5.0 $H $k $ray | awk '{print $2 * ( (sqrt( (1/(($1/$3)*($1/$3)))-($4*$4) ) ) - (sqrt( (1/($1*$1)) - ($4*$4)) ) )}' `
set rayp_PpPs=`echo 5.0 $H $k $ray | awk '{print $2 * ( (sqrt( (1/(($1/$3)*($1/$3)))-($4*$4) ) ) + (sqrt( (1/($1*$1)) - ($4*$4)) ) )}' `
set rayp_PpSs=`echo 5.0 $H $k $ray | awk '{print $2 * 2 * ( (sqrt( (1/(($1/$3)*($1/$3)))-($4*$4) ) )  )}' `
echo  $rayp_Ps $ray  >> ./.GMT_TEMP_FILES/rapy_Ps
echo  $rayp_PpPs $ray  >> ./.GMT_TEMP_FILES/rapy_PpPs
echo  $rayp_PpSs $ray  >> ./.GMT_TEMP_FILES/rapy_PpSs
end

##### (3) Actually go into gmt and plot the figures #####
set RATE=`echo $eqr | awk -F=  '{print $2}'`
set BOX = -R$time_min/$time_max/.04/.081
set FRAME = -JX7/10

# Plot the back Azimuth RF
gmt pswiggle ./.GMT_TEMP_FILES/${st}baz.in $FRAME -R$time_min/$time_max/-20/380 -Z$scale -G20/20/150 -Bxa5f1+l"Time (s)" -Byf10,a30+l"Radial RF   Back Azimuth"  -BSneW -X3 -Y3c -P -K > $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}baz.in -J -R -Z$scale -G-255/0/0 -K -O >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}baz.in -J -R -Z$scale -W0.1p,0 -K -O >> $st.ps

# Plot the ray parameter RF
gmt pswiggle ./.GMT_TEMP_FILES/${st}.in $FRAME $BOX -Z$scale -G20/20/150 -Bxa5f1+l"Time (s)" -Bya.005+l"Ray parameter" -BSnWe+t"Station $st" -X0c -Y12c -O -K >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}.in -J -R -Z$scale -G-255/0/0 -K -O >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}.in -J -R -Z$scale -W0.1p,0 -K -O >> $st.ps

#Plot the ray parameter lines
gmt psxy ./.GMT_TEMP_FILES/rapy_Ps -J -R -W.5p,black -K -O >> $st.ps
gmt psxy ./.GMT_TEMP_FILES/rapy_PpPs -J -R -W.5p,black -K -O >> $st.ps
gmt psxy ./.GMT_TEMP_FILES/rapy_PpSs -J -R -W.5p,black -K -O >> $st.ps

# Plot the ray parameter BAZ RF
#gmt pswiggle ./.GMT_TEMP_FILES/${st}dist.in $FRAME -R$time_min/$time_max/20/100 -Z$scale -G20/20/150 -Bxa5f1+l"Time (s)" -Bya10+l"Epicentral Distance (\260)" -BSnEw+t"H=$H, Vp/Vs=$k" -X9c -Y0c -O -K >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}dist.in $FRAME -R$time_min/$time_max/20/100 -Z$scale -G20/20/150 -Bxa5f1+l"Time (s)" -Bya10+l"Epicentral Distance (\260)" -BSnEw+t -X9c -Y0c -O -K >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}dist.in -J -R -Z$scale -G-255/0/0 -K -O >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}dist.in -J -R -Z$scale -W0.1p,0 -K -O >> $st.ps

## Plot the ray parameter T RF
gmt pswiggle ./.GMT_TEMP_FILES/${st}tran.in $FRAME -R$time_min/$time_max/-20/380 -Z$scale -G20/20/150 -Bxa5f1+l"Time (s)" -Byf10,a30+l"Transverse RF   Back Azimuth" -BSnEw -X0c -Y-12c -O -K >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}tran.in -J -R -Z$scale -G-255/0/0 -K -O >> $st.ps
gmt pswiggle ./.GMT_TEMP_FILES/${st}tran.in -J -R -Z$scale -W0.1p,0 -K -O >> $st.ps
#



#echo -42 -2 "Time (sec)"    | gmt pstext -F+f9p,Helvetica-Bold,black+jLB+a0 $BOX $FRAME  -N -K -O >> $st.ps
#echo 10 -2 "Time (sec)"     | gmt pstext -F+f9p,Helvetica-Bold,black+jLB+a0 $BOX $FRAME  -N -K -O >> $st.ps
#echo -42 23 "$st \ $RATE"   | gmt pstext -F+f11p,Times-Bold,black+jLB+a0    $BOX $FRAME  -N -K -O >> $st.ps
#echo -13 20 "BAZ (\260)"    | gmt pstext -F+f8p,Helvetica-Bold,black+jLB+a0 $BOX $FRAME  -N -K -O >> $st.ps
##echo 0 0.5 "Average"       | gmt pstext -F+f7p,Times-Bold,black+jLB+a0     $BOX $FRAME  -N -K -O >> $st.ps



#rm -r .GMT_TEMP_FILES ; echo Deleting the temp files
