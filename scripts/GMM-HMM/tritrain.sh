#!/bin/bash
echo "Training triphones (based on monophone models) using step-xwtri"

echo "Monophone model used: MFC _D_A_Z FlatStart"
read -r bank envs initiation 

echo "Modify triphone parameters!"
echo "Number of Max Gaussian components: "
read gmms

echo "list of TBVAL values (outlier states removal): 900 1400 1600"
read tbval_list
echo "fixed ROVAL value: 100"
read roval


gmmfolder='/home/sp838/MLSALT2/pracgmm'

# Format fixing 

if [ $bank = "MFC" ];then
	envsflag='_E'$envs
else
	envsflag=$envs
fi

# We are using hmm14 monophone model ls since Tb only valid for 1 mix diagonal covar models

folder="$bank""$envsflag"_"$initiation"
echo "Monophone model used is hmm14 from $folder with results:"
grep Acc $folder/decode-mono-hmm14/test/LOG

## Excute:
for tbval in $tbval_list
	do 

	echo "../tools/steps/step-xwtri -NUMMIXES $gmms -ROVAL $roval -TBVAL $tbval \ $PWD/$folder/mono hmm14 $folder/xwtri/$roval-$tbval"

	../tools/steps/step-xwtri -NUMMIXES $gmms -ROVAL $roval -TBVAL $tbval \ $PWD/$folder/mono hmm14 $folder/xwtri-$roval-$tbval

	echo "Trained triphone models are at folder exp/$folder/xwtri-$roval-$tbval"

done
