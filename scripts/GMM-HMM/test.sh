#!/bin/bash
echo "Testing using step-decode"

# type of test
echo "Model to test and type of test: [mono xwtri] [whole core sub]"
read -r model test_mode


if [ "$model" = "xwtri" ]; then 
	echo "ROVAL and TBVAL values: 200 800"
	read -r roval tval
	model="$model-$roval-$tval"
fi


echo "Mono/triphone model used: MFC _D_A_Z FlatStart hmm84"
read -r bank envs initiation hmm


echo "Select a test parameters!"

echo "Select testing options: -INSWORD -GRAMMARSCALE"
read -r option1 option2


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

# result storage

echo "list to store experiments // experiment results: exp_list result_list"
read -r exp_list result_list
exp_list="data/"$exp_list""
result_list="data/"$result_list""

folder="$bank""$envsflag"_"$initiation"
echo "Test results are stored at exp/$folder/$model"


#Excute:


echo "../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model $hmm $folder/decode-$model-$hmm"

../tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $PWD/$folder/$model $hmm $folder/decode-$model-$hmm

echo "Testing results are at folder exp/$folder/decode-$model-$hmm"

## Recording of resutls and experiment

echo "$folder/decode-$model-$hmm $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> "$exp_list".txt
grep Acc $folder/decode-$model-$hmm/test/LOG >> "$result_list".txt

echo $result_list
echo $exp_list
python reading.py "$result_list".txt "$exp_list".txt


