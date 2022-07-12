#!/bin/bash

# script for calling listif.pl and looping throught dataset of Ab-Ag complexes
date
echo "Start ..."

mkdir interface_residue_lists
no_pdbs=$(ls complexes | wc -l)
for i in $( seq 1 $no_pdbs )
do
	./listif.pl ./complexes/$i.pdb ./antibody_pdbs/Ab_$i.pdb ./antigen_pdbs/Ag_$i.pdb > ./interface_residue_lists/$i.txt
	echo $i
done

echo "Done!"
date 


