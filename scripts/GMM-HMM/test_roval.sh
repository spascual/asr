#!/bin/bash
echo "Testing using step-decode"

echo "Type of test: whole core sub"
read test_mode


mode='xwtri'
option1=-10
option2=0


echo "triphones based on: MFC _D_A_Z FlatStart"
read -r bank envs initiation

# formating

if [ "$test_mode" = "sub" ]; then 
	testflag='-SUBTRAIN'
elif [ "$test_mode" = "core" ]; then
	testflag='-CORETEST'
else
	testflag=''
fi

if [ $bank = "MFC" ];then
	envsflag='_E'$envs
else
	envsflag=$envs
fi

# lists for the loops

echo "List of Hmms to test: hmm84 hmm124 hmm164 hmm204 hmm324"
read hmm_list

echo "List of TBVAL used: 800 1000 1200 2000"
read tbval_list

roval='200'

echo "list to store experiments // experiment results: exp_tbval result_tbval"
read -r exp_list result_list

exp_list="data/"$exp_list""
result_list="data/"$result_list""


# Start the 3 loops here

for hmm in $hmm_list
	do

	for tbval in $tbval_list
		do

# result storage 

		model="$mode-$roval-$tbval"

		folder="$bank""$envsflag"_"$initiation"
		echo "Test results are stored at exp/$folder/$model"

		#Excute:
		rm -rf $folder/decode-$model-$hmm

		echo "../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model $hmm $folder/decode-$model-$hmm"

		../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model $hmm $folder/decode-$model-$hmm

		echo "Testing results are at folder exp/$folder/decode-$model-$hmm"

		## Recording of resutls and experiment

		echo "$folder/decode-$model-$hmm $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> "$exp_list".txt
		grep Acc $folder/decode-$model-$hmm/test/LOG >> "$result_list".txt

	done
done


echo $result_list
echo $exp_list
# python reading.py "$result_list".txt "$exp_list".txt














