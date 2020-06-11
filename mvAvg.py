"""
Smooths dispersion curves via moving average and Savgol filtering 

Usage: python mvAvg.py Net_Sta

Reads a .pvelUnSmoothed and .gvelUnSmoothed file and outputs the smoothed dispersion curves
.pvelSavgol and .pvelSmoothed
"""

from scipy.signal import savgol_filter
import sys

net_sta = sys.argv[1]
phase_input = []
phase = []
group_input = []
group = []
split = net_sta.split('_')
net = split[0]
sta = split[1]

with open(f'{net}/{sta}/joint/{sta}.pvelUnSmoothed') as f:
    for line in f.readlines():
        phase_input.append(line.split())

with open(f'{net}/{sta}/joint/{sta}.gvelUnSmoothed') as f:
    for line in f.readlines():
        group_input.append(line.split())

for i, val in enumerate(phase_input):
    if i%2 == 0:
        try:
            avg_vel = (float(val[1]) + float(phase_input[i-1][1]) + float(phase_input[i+1][1]))/3
            period = float(val[0])
            phase.append([period, avg_vel])
        except:
            continue

for i, val in enumerate(group_input):
    if i%2 == 0:
        try:
            avg_vel = (float(val[1]) + float(group_input[i-1][1]) + float(group_input[i+1][1]))/3
            period = float(val[0])
            group.append([period, avg_vel])
        except:
            print(i, val)

with open(f'{net}/{sta}/joint/{sta}.gvelSmoothed', 'w') as f:
    for i in group:
        f.write(f'{i[0]} {round(i[1], 4)}\n')

with open(f'{net}/{sta}/joint/{sta}.pvelSmoothed', 'w') as f:
    for i in phase:
        f.write(f'{i[0]} {round(i[1], 4)}\n')

group_vel = [i[1] for i in group_input]
phase_vel = [i[1] for i in phase_input]
group_hat = savgol_filter(group_vel, 9, 3)
phase_hat = savgol_filter(phase_vel, 9, 3)
sav_group = [[per[0], group_hat[i]] for i, per in enumerate(group_input) if i%2==0]
sav_phase = [[per[0], phase_hat[i]] for i, per in enumerate(phase_input) if i%2==0]

with open(f'{net}/{sta}/joint/{sta}.gvelSavgol', 'w') as f:
    for i in sav_group:
        f.write(f'{i[0]} {round(i[1], 4)}\n')

with open(f'{net}/{sta}/joint/{sta}.pvelSavgol', 'w') as f:
    for i in sav_phase:
        f.write(f'{i[0]} {round(i[1], 4)}\n')
