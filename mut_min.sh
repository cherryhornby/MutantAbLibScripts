#!/bin/bash

# script for looping through each complex and antibody binding surface resiudes and mutating the side chains using mutmodel then running an energy minimisation
date
echo "Start..."
# part 1: mutate each anibody binding surface residue

mutants=LMFWKQESVIYHRNDT

for i in {101..200}
do
	mkdir ../data/mutants/$i/
	wtpath=../data/complexes/
	mutantpath=../data/mutants/$i/
	while read line; do
		chain_code=$(grep -Eo '[[:alpha:]]' <<<$line)
		aa_num=$(grep -Eo '[[:digit:]]*' <<<$line)
		mut1=$(echo ${mutants:0:1})
                mut2=$(echo ${mutants:1:1})
                mut3=$(echo ${mutants:2:1})
                mut4=$(echo ${mutants:3:1})
                mut5=$(echo ${mutants:4:1})
                mut6=$(echo ${mutants:5:1})
                mut7=$(echo ${mutants:6:1})
                mut8=$(echo ${mutants:7:1})
                mut9=$(echo ${mutants:8:1})
                mut10=$(echo ${mutants:9:1})
                mut11=$(echo ${mutants:10:1})
                mut12=$(echo ${mutants:11:1})
                mut13=$(echo ${mutants:12:1})
                mut14=$(echo ${mutants:13:1})
                mut15=$(echo ${mutants:14:1})
		mut16=$(echo ${mutants:15:1})

                mutmodel -m $chain_code$aa_num $mut1 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut1$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut2 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut2$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut3 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut3$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut4 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut4$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut5 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut5$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut6 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut6$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut7 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut7$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut8 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut8$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut9 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut9$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut10 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut10$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut11 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut11$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut12 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut12$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut13 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut13$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut14 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut14$aa_num.pdb
                mutmodel -m $chain_code$aa_num $mut15 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut15$aa_num.pdb
		mutmodel -m $chain_code$aa_num $mut16 -e 4 -l 8.0 -s 30.00 -t 1.0 -v $wtpath$i.pdb $mutantpath$chain_code_$mut16$aa_num.pdb
		echo "residue $aa_num mutated..."	
	done <../data/if_ab_res_list/$i.txt
	echo "complex $i done..."
done		

# part 2: energy minimsation fo mutants

# build topology for EM run
cd ../data/mutants/
for i in {101..200}
do
	echo "complex $i EM..."
	mkdir EM$i
	cd $i
	for file in *
	do
		filename=$(echo $file | cut -f 1 -d ".")
		# build topology for EM run
		gmx pdb2gmx -f $file -o preEM.pdb -missing -ignh << EOF
6
1
EOF

		# put complex in box
		gmx editconf -f preEM.pdb -o box.gro -c -d 1.0 -bt dodecahedron
                # run EM
		gmx grompp -f ../../../mutate_if_project/minim.mdp -c box.gro -p topol.top -o final_$filename.tpr -maxwarn 1
		gmx mdrun -v -deffnm final_$filename -c ../EM$i/minim_$file -e ../EM$i/energy_$filename.edr
		gmx energy -f ../EM$i/energy_$filename.edr -o ../EM$i/potential_$filename.xvg << EOF
10
EOF
		rm box.gro
		rm final_$filename.log
		rm final_$filename.trr
		rm preEM.pdb
		rm *posre*
		rm *topol*
	done
	echo "complex $i minimised..."
	cd ../
done
echo "Done!"
date		
	  
