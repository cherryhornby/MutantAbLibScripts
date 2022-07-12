#!/bin/bash

# script for generating text files of paths to ab-ag complexes in the database and info on each pdb (chain number for separating pdbs into ab and ag)

# FIRST STEP
# Select complexes from antibody dataset
ABPATH="/serv/data/af2/cleanpdbstructures/unique/"
grep -rwl 'CHAIN A' $ABPATH > complexes_file.txt

# SECOND STEP

# find number of chains for each pdb
touch pdb_info.txt
i=1
while read -r line 
	do
		pdbcount $line $i
		cat $i >> pdb_info.txt
		rm $i
		i=$(($i+1))
done <  complexes_file.txt


