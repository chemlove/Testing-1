#!/bin/bash
#PBS -q fas_devel
#PBS -l mem=4gb
#PBS -l walltime=01:00:00
#PBS -m abe
#PBS -M yq47@yale.edu
#PBS -l nodes=1:ppn=1
#PBS -d /home/fas/jorgensen/yq47/Documents/MIF/test3
#PBS -o phenol.o.log
#PBS -e phenol.e.log
#
mkdir mifphenolCAP-Q.mc
cd mifphenolCAP-Q.mc
cp ../mifphenolCAP-Q.z fepzmat
cp ../fepcmd ./fepcmd
cp ../feppar .
cp ../feppar0 .
#
# execute MC
#
#csh fepcmd >& log-orig &
tcsh -c "source ~/.cshrc; tcsh fepcmd >& log-orig "
cd ..
exit
