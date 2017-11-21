#!/bin/bash
#PBS -q fas_devel
#PBS -l mem=4gb
#PBS -l nodes=1:ppn=8,walltime=01:00:00

#PBS -m abe
#PBS -M yue.qian@yale.edu
#PBS -o q.o${PBS_JOBID}.log
#PBS -e q.e${PBS_JOBID}.log
# switch to the working directory 
echo  Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
#

for j in {1..7}
do
    mkdir $1.sos$j
    cd $1.sos$j
    k=$(($j-1))

    sed "s/@ i = 0/@ i = ${k}/g" ../soscmd > soscmd${j}_ANH
    cp ../$1.z ./fepzmat
    cp ../feppar0 ./
    cp ../feppar  ./
    tcsh -c "source ~/.cshrc; tcsh soscmd${j}_ANH >& $1.o${PBS_JOBID}.log"

cd ..
done

exit
