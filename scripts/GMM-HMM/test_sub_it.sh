#!/bin/bash
echo "Testing using step-decode"

### Inputs for the future loops
echo "Choose model of sound: mono or xwtri"
read model #Change later for triphones
echo "Enter env you want to examine: FBK or MFC"
read bank
echo "Numb of Gaussians to examine: 8 12 16 20 24 28 32"
read gmms

echo "Insword list to test: -2.5 -5 -10"
read ins_list

initiation='FlatStart'
envs='_D_A_Z'
numb=4
option1=-12.5
option2=0
testflag='-SUBTRAIN' # For this overview of testing we dont care about testing whole set yet

echo "list to store experiments: FBK_init"
read exp_list

### Start with the loops

## 1 Parameter with least impact in decision: 

#loop on type of initiation: [FlatStart or Init]"


	#echo "Choose environment type: (_E)_Z, (_E)_D_Z or (_E)_D_A_Z"
if [ $bank = "MFC" ];then
	envsflag='_E'$envs
else
	envsflag=$envs
fi

## 2 
# Loop on Number of Gaussian components:
#for gmm in $gmms
#	do



## 3 Non decision parameter with most impact in accuracy
	#for option1 in $ins_list
	#	do 


## 4 Parameter in which we are deciding now: 

for gmm in $gmms
    do 
#Excute:	
    folder="$bank""$envsflag"_"$initiation"
    echo "Output models from experiment are at folder exp/$folder/$model"
    rm -rf $folder/decode-$model-hmm$gmm$numb

    echo "../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model hmm$gmm$numb $folder/decode-$model-hmm$gmm$numb"
    ../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model hmm$gmm$numb $folder/decode-$model-hmm$gmm$numb
    echo "Testing results are at folder exp/$folder/decode-$model-hmm$gmm$numb"

## Saving results

    echo "$folder/decode-$model-hmm$gmm$numb $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> data/exp_"$exp_list".txt
    grep Acc $folder/decode-$model-hmm$gmm$numb/test/LOG >> data/result_"$exp_list".txt
		#done
	#done

done