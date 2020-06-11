# Script to automate Joint inversion calculation across many stations
# Edit the base variable to reflect the top-level location for Joint inversions
# The directory structure is expected be be
# -TopLevel
#   -Network1
#      -Sta1
#        -joint
#          -joint inversion files
#      -Sta2
#   -Network2
#
# You must also provide a "NetList" at the top level containing all networks you want to run, one per line
# and within each network directory a "StaList" file containing all stations you want to run, one per line
#

base=/Users/khomman/Documents/JointInversionPA

for net in `cat NetList`
do
  cd ${base}/$net
  for sta in `cat StaList`
  do
    cd ${base}/${net}/${sta}/joint
#    if [ -d "LF" ]; then
#      rm -r LF/
#    fi
#    if [ -d "HF" ]; then
#      rm -r HF/
#    fi
#    if [ -d "FF" ]; then
#      rm -r FF/
#    fi
    #cp ${base}/getrf.py .
    # Get starting model from the base directory
    cp ${base}/model.0 .
    
    # Get appropriate starting model if more than 1
    #model=`python /Users/khomman/Documents/JointInversionPA/determineModel.py ${net}_${sta}`
    #echo $model
    #cp /Users/khomman/Documents/JointInversionPA/${model}5224 model.0
#    mkdir FF
#    mkdir LF
#    mkdir HF
#
# Copy receiver functions from another locations using file "rftnLocs.txt"
#    python getrf.py ${net}_${sta}_
#    for rftn in `cat rftnLocs.txt`
#    do
#     cp $rftn .
#    done
#    mv *1.0.eq? LF
#    mv *2.5.eq? HF
#    mv *5.0.eq? FF
    #cp ${sta}.pvelSavgol ${sta}.pvel
    #cp ${sta}.gvelSavgol ${sta}.gvel
    cleanInversion.csh
    1_group_rayp.csh
    2_create_stack.csh 45
    2_create_stack.csh 56
    2_create_stack.csh 67
    2_create_stack.csh 78
    3_control_files_many_rayp.csh .5 .2
    4_prepare_disp_phase.csh
    jointsmth
    5_plot_ji_many_vaovao.csh
    #mv ${sta}_joint.ps ${sta}_joint.2.ps
    #cleanInversion.csh
    #3_control_files_many_rayp.csh .5 .1
    #4_prepare_disp_phase.csh
    #jointsmth
    #5_plot_ji_many_vaovao.csh
    #mv ${sta}_joint.ps ${sta}_joint.1.ps
    #cleanInversion.csh
    #3_control_files_many_rayp.csh .5 .3
    #4_prepare_disp_phase.csh
    #jointsmth
    #5_plot_ji_many_vaovao.csh
    #mv ${sta}_joint.ps ${sta}_joint.3.ps
    #cleanInversion.csh
    #3_control_files_many_rayp.csh .5 .4
    #4_prepare_disp_phase.csh
    #jointsmth
    #5_plot_ji_many_vaovao.csh
    #mv ${sta}_joint.ps ${sta}_joint.4.ps
    #cleanInversion.csh
    #3_control_files_many_rayp.csh .5 .5
    #4_prepare_disp_phase.csh
    #jointsmth
    #5_plot_ji_many_vaovao.csh
    #mv ${sta}_joint.ps ${sta}_joint.5.ps
  done
done
