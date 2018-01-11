#!/bin/bash
echo "Testing using step-decode"

### Inputs for the future loops

echo "Enter env you want to examine: FBK or MFC"
read bank
echo "List of context env to examine: _Z _D_Z _D_A_Z"
read env_list
echo "Numb of Gaussians to examine: 8 12 20"
read gmms

echo "Insword list to test: -2.5 -5 -10"
read ins_list


numb=4
option2=0
envs='_D_Z' # type: (_E)_Z, (_E)_D_Z or (_E)_D_A_Z
testflag='-CORETEST' # For this overview of testing we dont care about testing whole set yet

echo "list to store experiments: exp_list"
read exp_list
echo "list to store experiment results: results_list"
read result_list

### Start with the loops

## 1 Parameter with least impact in decision: 

#loop on type of initiation: [FlatStart or Init]"
for env in  $env_list 
	do
	
#loop on waveform parametrisation: FBK or MFC"
# for bank in 'FBK' 'MFC'
#do

#echo "Choose environment type: (_E)_Z, (_E)_D_Z or (_E)_D_A_Z"
	if [ $bank = "MFC" ];then
		envsflag='_E'$env
	else
		envsflag=$envs
	fi

	folder="$bank""$envsflag"_"$initiation"
	echo "Output models from experiment are at folder exp/$folder/mono"



## 2 
# Loop on Number of Gaussian components:
	for gmm in $gmms
		do



## 3 Non decision parameter with most impact in accuracy
		for option1 in $ins_list
			do 


## 4 Parameter in which we are deciding now: 

			for initiation in 'FlatStart' 'Init'
				do 
#Excute:	
		#rm -rf $folder/decode-mono-hmm$gmm$numb

				echo "../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/mono hmm$gmm$numb $folder/decode-mono-hmm$gmm$numb"
				# ../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/mono hmm$gmm$numb $folder/decode-mono-hmm$gmm$numb
				echo "Testing results are at folder exp/$folder/decode-mono-hmm$gmm$numb"

	## Saving results

			# echo "$folder/decode-mono-hmm$gmm$numb $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> "$exp_list".txt
			# grep Acc $folder/decode-mono-$hmm$/test/LOG >> "$result_list".txt
			done
		done
	done
done

echo $result_list
echo $exp_list
python looping.py "$result_list".txt "$exp_list".txt