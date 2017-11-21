import sys
import math
import matplotlib.pyplot as plt
import numpy as np

###read in data from the output file###
file = open("newdelg")
li=[]
lf=[]
dg=[]
sg=[]
elg=0.00
delg=[]
z=[]
DelW=0.00
Vb=0.00
firstline = file.readline()
zi,zf=firstline.split()

zi=float(zi)
zf=float(zf)
for line in file:
	dli,dlf,ddg,dsg=line.split()
	li.append(dli)
	lf.append(dlf)
	dg.append(ddg)
	sg.append(dsg)

win=len(li)
for i in range (0,win):
    li[i]= float(li[i])
    lf[i]= float(lf[i])
    dg[i]=float(dg[i])
    sg[i]=float(sg[i])
    z.append(lf[i]*(zf-zi)+zi)

for i in range(0,win):
    elg=elg+float(dg[i])
    delg.append(elg)

ind=np.where(delg==np.min(delg))
ind_bound=int(ind[0])
print "the lowest point is",z[ind_bound],(np.amin(delg))
delg=delg+abs(np.amin(delg))
plt.plot(z,delg,'r-')
plt.xlabel('R('r'$\AA$'')')
plt.ylabel(r'$\Delta$''G(R) (kcal/mol)')
plt.xlim([3.0,12])
plt.ylim([0,2])
plt.plot([3.0,12],[0.47,0.47],'b--')
plt.title('PMF Calculation for Methane dimer in water')
plt.show()
#plt.savefig('Ar.png',dpi=800)
var = raw_input("The bound-unbound cutoff would be number...: ")
ind_unbound = int(var)
print "the point would locate at", z[ind_unbound],delg[ind_unbound]
#var1 =sys.argv[1] 
#var2 =sys.argv[2] 

### start integration###

for i in range (ind_unbound,win):
    DelW=DelW+math.exp(-delg[i]/0.592)*(0.01*(zf-zi))*z[i]**2

Vu=4*math.pi/3*(z[win-1]**3-z[ind_unbound]**3)
DelW=math.log(DelW/Vu*4*math.pi)*0.592
print "depth DelW:", DelW


for i in range (ind_bound,ind_unbound):
    Vb=Vb+4*math.pi*math.exp(-delg[i]/0.592)*(0.01*(zf-zi))*z[i]**2

print "Vb and Vu", Vb, Vu

DELG_ST= -0.592*(math.log(Vb/1661))+DelW
print "delta G from PMF after correction",DELG_ST
