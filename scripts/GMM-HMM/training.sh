#!/bin/bash
echo "Training using step-mono"

#Step 1 
echo "Type of initiation: [FlatStart or Init]"
read initiation

if [ "$initiation" = "FlatStart" ] ; then 
	flag1='-FLATSTART'
else
	flag1= 
fi

#Step 2
echo "Number of Max Gaussian components: "
read gmms

#Step 3
echo "Choose waveform parametrisation: FBK or MFC"
read bank

if [ "$bank" = "MFC" ]; then 
	bankfolder='mfc13d'
else
	bankfolder='fbk25d'
fi

#Step 4
echo "List of context env to Training: _Z _D_Z _D_A_Z"
read env_list

## Small loop: 
for env in  $env_list 
	do
	if [ $bank = "MFC" ];then
		envsflag='_E'$env
	else
		envsflag=$envs
	fi
	# rm "$bank""$envsflag"_"$initiation"
	folder="$bank""$envsflag"_"$initiation"
	echo "Output models from experiment are at folder exp/$folder/mono"
#Excute:
	echo "../tools/steps/step-mono $flag1 -NUMMIXES $gmms ../convert/$bankfolder/env/environment$envsflag \ "$bank""$envsflag"_"$initiation"/mono"

	# ../tools/steps/step-mono $flag1 -NUMMIXES $gmms ../convert/$bankfolder/env/environment$envsflag \ "$bank""$envsflag"_"$initiation"/mono
	echo "Trained monophone models eg: hmm10,..., hmm84 stored at folder "$bank""$envsflag"_"$initiation"/mono"

done





