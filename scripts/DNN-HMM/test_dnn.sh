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


echo "Parameters for the model trained"
echo "Bank and feature type (vary this): MFC _D_A_Z"
read -r bank envs 

echo "DNN Parameters context, layers, nodes: 1 3 500"
read -r context layers nodes

echo "Use Sigle sil option: -SINGLESIL"
read sil

echo "Select a test parameters!"

echo "Select testing options -INSWORD -GRAMMARSCALE : -10 0"
read -r option1 option2

read op_list

 

# formating

if [ "$test_mode" = "sub" ]; then 
	testflag='-SUBTRAIN'
elif [ "$test_mode" = "core" ]; then
	testflag='-CORETEST'
else
	testflag=''
fi

if [ "$bank" = "MFC" ]; then 
	bankfolder='mfc13d'
	envsflag='_E'$envs
	pre='M'
else
	bankfolder='fbk25d'
	envsflag=$envs
	pre='F'
fi

if [ "$envs" = "_Z" ];then
	feature='Z'
elif [ "$envs" = "_D_Z" ]; then
	feature='D'
else
	feature='D2'
fi

# result storage

echo "list to store experiments // experiment results: exp_single result_single"
read -r exp_list result_list
exp_list="data/"$exp_list""
result_list="data/"$result_list""



pracdnn='/home/sp838/MLSALT2/pracdnn'
dnn_folder="mono"-"$pre""$feature"-$context-$layers-$nodes

echo "Test results are stored at $dnn_folder/decode-dnn"$layers".finetune"

## loop section
for option1 in op_list
	do

#Excute:
rm -rf $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune

echo "$pracdnn/tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $pracdnn/exp/$dnn_folder/dnntrain dnn"$layers".finetune $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune"

$pracdnn/tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $pracdnn/exp/$dnn_folder/dnntrain dnn"$layers".finetune $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune

echo "Testing results are at folder $dnn_folder/decode-dnn"$layers".finetune"

## Recording of resutls and experiment

echo "$dnn_folder/decode-dnn"$layers".finetune $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> "$exp_list".txt
grep Acc $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune/test/LOG >> "$result_list".txt

done
echo $result_list
echo $exp_list
# python reading.py "$result_list".txt "$exp_list".txt
