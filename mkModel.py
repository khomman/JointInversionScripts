"""
Generate a starting model for Joint Inversion code.  Currently contains a sedimentary layering,
Crust layers, upper mantle layering, and lower mantle layering scheme
"""
import numpy as np
import matplotlib.pyplot as plt


starting_vel_sed = 4.5
ending_vel_sed = 5.75
sed_thick = 0.25
sed_depth = 4.0
sed_smooth = 7.0

starting_vel_crust = 6.0
ending_vel_crust = 7.35
moho_depth = 40.0
crust_thick = 2.0
crust_smooth = 7.0

starting_mantle_vel = 7.9
bottom_upper_mantle = 65.0
upper_mantle_thick = 2.0
upper_mantle_smooth = 7.0

bottom_mantle = 300.0
mantle_thick = 5.0
mantle_smooth = 7.0

sed_layers = sed_depth/sed_thick
crust_layers = (moho_depth-sed_depth)/crust_thick
upper_mantle_layers = (bottom_upper_mantle-sed_depth-moho_depth)/upper_mantle_thick
mantle_layers = (bottom_mantle-sed_depth-moho_depth-upper_mantle_layers)/mantle_thick

basement_vp = np.linspace(starting_vel_sed, ending_vel_sed, num=sed_layers)
crust_vp = np.linspace(starting_vel_crust, ending_vel_crust, num=crust_layers) 
upper_mantle_vp = np.linspace(starting_mantle_vel, starting_mantle_vel, num=upper_mantle_layers)
mantle_vp = np.linspace(starting_mantle_vel, starting_mantle_vel, num=mantle_layers)

# Brochers Empirical regressino to get Vs
basement_vs = 0.7858 - 1.2344*basement_vp + 0.7949*basement_vp**2 - 0.1238*basement_vp**3 + 0.0064*basement_vp**4
crust_vs = 0.7858 - 1.2344*crust_vp + 0.7949*crust_vp**2 - 0.1238*crust_vp**3 + 0.0064*crust_vp**4
#mantle_vs = 0.7858 - 1.2344*mantle_vp + 0.7949*mantle_vp**2 - 0.1238*mantle_vp**3 + 0.0064*mantle_vp**4
mantle_vs = np.full(len(mantle_vp), 4.5)
upper_mantle_vs = np.full(len(upper_mantle_vp), 4.5)

# Nafe-Drake empirical relation to get rho
basement_rho = 1.6612*basement_vp - 0.4721*basement_vp**2 + 0.0671*basement_vp**3 - 0.0043*basement_vp**4 + 0.000106*basement_vp**5
crust_rho = 1.6612*crust_vp - 0.4721*crust_vp**2 + 0.0671*crust_vp**3 - 0.0043*crust_vp**4 + 0.000106*crust_vp**5
mantle_rho = 1.6612*mantle_vp - 0.4721*mantle_vp**2 + 0.0671*mantle_vp**3 - 0.0043*mantle_vp**4 + 0.000106*mantle_vp**5
upper_mantle_rho = 1.6612*upper_mantle_vp - 0.4721*upper_mantle_vp**2 + 0.0671*upper_mantle_vp**3 - 0.0043*upper_mantle_vp**4 + 0.000106*upper_mantle_vp**5

basement_smooth = np.full(len(basement_vp), sed_smooth)
basement_thick = np.full(len(basement_vp), sed_thick)
basement_conf = np.full(len(basement_vp), 0)

crust_smooth = np.full(len(crust_vp), crust_smooth)
crust_thick = np.full(len(crust_vp), crust_thick)
crust_conf = np.full(len(crust_vp), 0)

upper_mantle_smooth = np.full(len(upper_mantle_vp), upper_mantle_smooth)
upper_mantle_thick = np.full(len(upper_mantle_vp), upper_mantle_thick)
upper_mantle_conf = np.full(len(upper_mantle_vp), 0)

mantle_smooth = np.full(len(mantle_vp), mantle_smooth)
mantle_thick = np.full(len(mantle_vp), mantle_thick)
mantle_conf = np.full(len(mantle_vp), 0)

basement = np.column_stack((basement_vp,basement_vs, basement_rho, basement_thick, basement_smooth, basement_vs, basement_conf)) 
crust = np.column_stack((crust_vp, crust_vs, crust_rho, crust_thick, crust_smooth, crust_vs, crust_conf))
upper_mantle = np.column_stack((upper_mantle_vp, upper_mantle_vs, upper_mantle_rho, upper_mantle_thick, upper_mantle_smooth, upper_mantle_vs, upper_mantle_conf))
mantle = np.column_stack((mantle_vp, mantle_vs, mantle_rho, mantle_thick, mantle_smooth, mantle_vs, mantle_conf))

model = np.concatenate((basement, crust, upper_mantle, mantle))
id = [i for i in range(1, len(model)+1)]
model = np.insert(model, 0, id, axis=1)

np.savetxt('autoModel.0', model, header= f'{id[-1]} Gradient over PREM (z > 300 km)', fmt=['%3d', '%8.4f', '%7.4f', '%7.4f', '%7.4f', '%7.4f', '%7.4f', '%7.4f'])
