#!/bin/bash
#PBS -q fas_devel
#PBS -l mem=4gb
#PBS -l nodes=1:ppn=1,walltime=01:00:00

#PBS -m abe
#PBS -M yue.qian@yale.edu
#PBS -o phenol.o${PBS_JOBID}.log
#PBS -e phenol.e${PBS_JOBID}.log
# switch to the working directory 
echo  Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
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
tcsh -c "source ~/.cshrc; tcsh fepcmd >& log-orig "
cd ..
exit
