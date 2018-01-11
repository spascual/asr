#!/bin/bash

gmmfolder='/home/sp838/MLSALT2/pracgmm'


echo "Monophone model to align: MFC _D_A_Z FlatStart"
read -r bank envs initiation hmm

if [ $bank = "MFC" ];then
	envsflag='_E'$envs
else
	envsflag=$envs
fi


folder="$bank""$envsflag"_"$initiation"

echo "List of hmms to align: hmm84  hmm124  hmm164  hmm204  hmm324"
read -r hmm_list

# execute:
for hmm in $hmm_list
	do
	$gmmfolder/tools/steps/step-align $gmmfolder/exp/$folder/mono $hmm \
	                                          $gmmfolder/exp/$folder/align-mono-$hmm

	echo "alignments are saved at $gmmfolder/exp/$folder/align-mono-$hmm"
done