#!/usr/bin/python

import math

pairfile = file ('pairfile','w')
Polymerall=64+1

epsilon_pp=1.129989
sigma_pp=4.7
cutdis_pp=2.1*sigma_pp
welldis_pp=pow(2,1/6.0)*sigma_pp

epsilon_nn=0.25*epsilon_pp
sigma_nn=9.2
cutdis_nn=2.1*sigma_nn

epsilon_np=4.0*epsilon_pp
sigma_np=(sigma_nn+sigma_pp)/2.0
cutdis_np=2.1*sigma_np

print >> pairfile, "pair_style hybrid lj/cut 19.32 soft 10.0"
print >> pairfile, "pair_modify shift yes"
print >> pairfile, "pair_coeff * * lj/cut %f %f %f" % (epsilon_pp, sigma_pp, cutdis_pp)
print >> pairfile, "";
for i in range ( 1,Polymerall ):
	print >> pairfile, "pair_coeff %d %d lj/cut %f %f %f" % (i, i, epsilon_pp, sigma_pp, welldis_pp)
	#print >> pairfile, "pair_coeff %d 65 soft 0.5" % (i)
	#print >> pairfile, "fix %d all adapt 1 pair soft a %d 65  v_prefactor" % (i,i)
	#print >> pairfile, "";
print >> pairfile, "";
print >> pairfile, "pair_coeff * %d lj/cut %f %f %f" % (Polymerall, epsilon_np, sigma_np, cutdis_np)
print >> pairfile, "pair_coeff %d %d lj/cut %f %f %f" % (Polymerall, Polymerall, epsilon_nn, sigma_nn, cutdis_nn)
print >> pairfile, "pair_coeff * %d soft 0.5" % (Polymerall)
print >> pairfile, "fix SphSP all adapt 1 pair soft a * %d v_prefactor" % (Polymerall)
pairfile.close()



