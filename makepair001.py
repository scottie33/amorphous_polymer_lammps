#!/usr/bin/python

import math

pairfile = file ('pairfile','w')
Polymerall=38+1
sigma_nn=37.6 # 4.6 6.1 or 9.2
sigma_pp=4.7
#sigma_np=(sigma_nn+sigma_pp)/2.0
sigma_np=(sigma_nn+sigma_pp)/2.0

print " sigma_nn : %f" % (sigma_nn)
print " sigma_pp : %f" % (sigma_pp)
print " sigma_np : %f" % (sigma_np)
print " polymer chain : %d " % (Polymerall-1)

eV2KCal=23.061 # eV - > kcal/mol
epsilon_pp=0.049*eV2KCal
cutdis_pp=pow(2.0,1.0/6.0)*sigma_pp
welldis_pp=pow(2.0,1.0/6.0)*sigma_pp

epsilon_nn=0.25*epsilon_pp
cutdis_nn=pow(2.0,1.0/6.0)*sigma_nn

epsilon_np=4.0*epsilon_pp
cutdis_np=pow(2.0,1.0/6.0)*sigma_np

bond_length=4.7
bond_coeff1=0.25*eV2KCal
bond_coeff2=0.0
bond_coeff3=0.50*bond_coeff1

#print >> pairfile, "pair_style hybrid lj/cut 19.32 soft 10.0"
print >> pairfile, "bond_style      class2"
print >> pairfile, "bond_coeff	1 %f %f %f %f #kcal/mol" % (bond_length, bond_coeff1, bond_coeff2, bond_coeff3)
print >> pairfile, " "
print >> pairfile, "pair_style lj/cut 19.32"
print >> pairfile, "pair_modify shift yes"
#print >> pairfile, "pair_coeff * * lj/cut %f %f %f" % (epsilon_pp, sigma_pp, cutdis_pp)
print >> pairfile, "pair_coeff * * %f %f %f" % (epsilon_pp, sigma_pp, cutdis_pp)
print >> pairfile, "";
for i in range ( 1,Polymerall ):
	#print >> pairfile, "pair_coeff %d %d lj/cut %f %f %f" % (i, i, epsilon_pp, sigma_pp, welldis_pp)
	print >> pairfile, "pair_coeff %d %d %f %f %f" % (i, i, epsilon_pp, sigma_pp, welldis_pp)
	#print >> pairfile, "pair_coeff %d 65 soft 0.5" % (i)
	#print >> pairfile, "fix %d all adapt 1 pair soft a %d 65  v_prefactor" % (i,i)
	#print >> pairfile, "";
print >> pairfile, "";
#print >> pairfile, "pair_coeff * %d lj/cut %f %f %f" % (Polymerall, epsilon_np, sigma_np, cutdis_np)
print >> pairfile, "pair_coeff * %d %f %f %f" % (Polymerall, epsilon_np, sigma_np, cutdis_np)
#print >> pairfile, "pair_coeff %d %d lj/cut %f %f %f" % (Polymerall, Polymerall, epsilon_nn, sigma_nn, cutdis_nn)
print >> pairfile, "pair_coeff %d %d %f %f %f" % (Polymerall, Polymerall, epsilon_nn, sigma_nn, cutdis_nn)
#print >> pairfile, "pair_coeff * %d soft 0.5" % (Polymerall)
#print >> pairfile, "fix SphSP all adapt 1 pair soft a * %d v_prefactor" % (Polymerall)
print >> pairfile, "group pp type <= %d" % (Polymerall-1)
print >> pairfile, "group np type %d" % (Polymerall)
pairfile.close()



