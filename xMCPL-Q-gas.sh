#!/bin/bash
#PBS -q fas_devel
#PBS -l mem=4gb
#PBS -l nodes=1:ppn=1,walltime=01:00:00

#PBS -m abe
#PBS -M yue.qian@yale.edu
#PBS -o q.o${PBS_JOBID}.log
#PBS -e q.e${PBS_JOBID}.log
# switch to the working directory 
echo  Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
#

mkdir $1.mc
cd $1.mc
cp ../$1.z fepzmat
cp ../soscmd ./soscmd
cp ../feppar .
cp ../feppar0 .
#
# execute MC
#
tcsh -c "source ~/.cshrc; tcsh soscmd >& $1.o${PBS_JOBID}.log"
cd ..
exit
