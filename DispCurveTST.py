import matplotlib.pyplot as plt
import sys
net = sys.argv[1]
sta = sys.argv[2]
save = 'y'
perLg = []
perRg = []
velLg = []
velRg = []
perRp = []
velRp = []
perLp = []
velLp = []

#Group Velocity Grabbing
with open("{}/{}/{}_{}_DispCurves.txt".format(net,sta,net,sta),"r") as f:
    for line in f.readlines():
        if line.split()[2] == 'U' and line.split()[1] == 'L':
            perLg.append(line.split()[5])
            velLg.append(line.split()[6])

        if line.split()[2] == 'U' and line.split()[1] == 'R':
            perRg.append(line.split()[5])
            velRg.append(line.split()[6])

        if line.split()[2] == 'C' and line.split()[1] == 'L':
            perLp.append(line.split()[5])
            velLp.append(line.split()[6])

        if line.split()[2] == 'C' and line.split()[1] == 'R':
            perRp.append(line.split()[5])
            velRp.append(line.split()[6])
#Phase Velocity Grabbing
# with open("PE/IUPA/TEST_DISP","r") as f:
#     for line in f.readlines():
#         if line.split()[2] == 'C' and line.split()[1] == 'L':
#             perLp.append(line.split()[5])
#             velLp.append(line.split()[6])
#
#         if line.split()[2] == 'C' and line.split()[1] == 'R':
#             perRp.append(line.split()[5])
#             velRp.append(line.split()[6])

plt.plot(perRg,velRg,'ro')
plt.plot(perRp,velRp,'bo')
plt.text(40,3.0,"Rayleigh Group",fontsize=14,color='red')
plt.text(40,2.9,"Rayleigh Phase",fontsize=14,color='blue')
plt.ylim(2.2,4.8)
plt.xlim(0,70)
plt.title("{}_{} Dispersion Curves".format(net,sta))
plt.xlabel('Period (s)')
plt.ylabel('Velocity (km/s)')
if save == 'y':
#plt.show()
    plt.savefig('{}/{}/{}_{}_Dispersion_plots.pdf'.format(net,sta,net,sta))
else:
    plt.show()
