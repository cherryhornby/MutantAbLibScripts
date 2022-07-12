#!/bin/bash

# script for creating pdbs of the antibody and antigen for each complex for the binding interface selection step
date
echo "Start..."

mkdir antibody_pdbs
mkdir antigen_pdbs
mkdir chains

no_pdbs=$(ls complexes | wc -l)
for i in $( seq 1 $no_pdbs )
do
	echo "separating pdb $i ..."
	chain_no=$(awk '/REMARK 950 CHAIN/{print NR}' ./complexes/$i.pdb)
	N=$(echo $chain_no | wc -w)
	for j in $(seq 1 $N)
	do
		pdbgetchain -n $j ./complexes/$i.pdb ./chains/$j.pdb
	done
	cat ./chains/1.pdb ./chains/2.pdb > ./antibody_pdbs/Ab_$i.pdb
	sed -i '/REMARK/d' ./antibody_pdbs/Ab_$i.pdb
	sed -i '/MASTER/d' ./antibody_pdbs/Ab_$i.pdb
	sed -i '/END/d' ./antibody_pdbs/Ab_$i.pdb
	echo 'END' >> ./antibody_pdbs/Ab_$i.pdb
	echo "antibody $i done ..."
	A=$(awk '/CHAIN A/{print NR}' ./complexes/$i.pdb)
	n_chains_a=$(echo $A | wc -l)
	if [ $n_chains_a==1 ]
	then
		mv ./chains/3.pdb ./antigen_pdbs/Ag_$i.pdb
		sed -i '/REMARK/d' ./antigen_pdbs/Ag_$i.pdb
		sed -i '/MASTER/d' ./antigen_pdbs/Ag_$i.pdb
	elif [ $n_chains_a==2 ]
	then
		mv ./chains/3.pdb ./antigen_pdbs/3.pdb
		mv ./chains/4.pdb ./antigen_pdbs/4.pdb
		cat ./antigen_pdbs/3.pdb ./antigen_pdbs/4.pdb > ./antigen_pdbs/Ag_$i.pdb
		sed -i '/REMARK/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/MASTER/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/END/d' ./antigen_pdbs/Ab_$i.pdb
		echo 'END' >> ./antigen_pdbs/Ab_$i.pdb
		rm ./antigen_pdbs/3.pdb
		rm ./antigen_pdbs/4.pdb
	elif [ $n_chains_a==3 ]
	then
		mv ./chains/3.pdb ./antigen_pdbs/3.pdb
		mv ./chains/4.pdb ./antigen_pdbs/4.pdb
		mv ./chains/5.pdb ./antigen_pdbs/5.pdb
		cat ./antigen_pdbs/3.pdb ./antigen_pdbs/4.pdb ./antigen_pdbs/5.pdb > ./antigen_pdbs/Ag_$i.pdb
		sed -i '/REMARK/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/MASTER/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/END/d' ./antigen_pdbs/Ab_$i.pdb
		echo 'END' >> ./antigen_pdbs/Ab_$i.pdb
		rm ./antigen_pdbs/3.pdb
		rm ./antigen_pdbs/4.pdb
		rm ./antigen_pdbs/5.pdb
	elif [ $n_chains_a==4 ]
	then
		mv ./chains/3.pdb ./antigen_pdbs/3.pdb
		mv ./chains/4.pdb ./antigen_pdbs/4.pdb
		mv ./chains/5.pdb ./antigen_pdbs/5.pdb
		mv ./chains/6.pdb ./antigen_pdbs/6.pdb
		cat ./antigen_pdbs/3.pdb ./antigen_pdbs/4.pdb ./antigen_pdbs/5.pdb ./antigen_pdbs/6.pdb > ./antigen_pdbs/Ag_$i.pdb
		sed -i '/REMARK/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/MASTER/d' ./antigen_pdbs/Ab_$i.pdb
		sed -i '/END/d' ./antigen_pdbs/Ab_$i.pdb
		echo 'END' >> ./antigen_pdbs/Ab_$i.pdb
		rm ./antigen_pdbs/3.pdb
		rm ./antigen_pdbs/4.pdb
		rm ./antigen_pdbs/5.pdb
		rm ./antigen_pdbs/6.pdb
	fi
	rm ./chains/*pdb*	
	echo "antigen $i done ..."	
done 

echo "Done!"
date
