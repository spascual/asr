#!/bin#!/bin/bash
echo "Training using step-dnntrain"

echo "Model to test and type of test: [mono xwtri] [whole core sub]"
read -r model test_mode

if [ "$model" = "mono" ]; then 
	echo "GMM-HMM (best possible) used for alignment: MFC _D_A_Z FlatStart hmm324"
	read -r bank1 envs1 initiation hmm
else 
	echo "GMM-HMM triphone model: MFC _D_A_Z FlatStart 20 200 800"
	read -r bank1 envs1 initiation hmm roval tbval
	model1="$model-$roval-$tbval"
fi

echo "Parameters for the model we want to train"
echo "DEFAULTS – bank: MFC, layers: 3, nodes: 500 "
bank="MFC"
layers=3
nodes=500
echo "Use Sigle sil option: -SINGLESIL"
read sil
echo "list of features: _Z _D_Z _D_A_Z"
envs_list="_Z _D_Z _D_A_Z"
echo "list of contexts: 1 3 5 9 11"
cont_list="1 3 5 9 11"
echo "list to store experiments // experiment results: exp_single result_single"
read -r exp_list result_list
exp_list="data/"$exp_list""
result_list="data/"$result_list""



for envs in $envs_list
	do 
	for context in $cont_list
		do
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

# FOLDERS

		pracgmmexp='/home/sp838/MLSALT2/pracgmm/exp'
		pracdnn='/home/sp838/MLSALT2/pracdnn'
		align_folder="$bank1""$envsflag1"_"$initiation"
		dnn_folder="$model"-"$pre""$feature"-$context-$layers-$nodes
		HTE_file=$pracdnn/exp/HTE_folder/$dnn_folder/HTE.dnntrain

		rm -rf $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune

# TRAINING

		$pracdnn/tools/steps/step-dnntrain -DNNTRAINHTE $HTE_file -USEGPUID 0 $sil \
		$pracdnn/convert/$bankfolder/env/environment$envsflag \
		$pracgmmexp/$align_folder/align-$model-$hmm/align/timit_train.mlf \
		$pracgmmexp/$align_folder/$model/$hmm/MMF \
		$pracgmmexp/$align_folder/$model/hmms.mlist $pracdnn/exp/$dnn_folder/dnntrain

		echo "Final trained model at $layers.finetune /pracdnn/exp/$dnn_folder/dnntrain"

# TESTING

		echo "$pracdnn/tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $pracdnn/exp/$dnn_folder/dnntrain dnn"$layers".finetune $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune"

		$pracdnn/tools/steps/step-decode $testflag -INSWORD $option1 -GRAMMARSCALE $option2 $pracdnn/exp/$dnn_folder/dnntrain dnn"$layers".finetune $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune

		echo "Testing results are at folder $dnn_folder/decode-dnn"$layers".finetune"

		## Recording of resutls and experiment

		echo "$dnn_folder/decode-dnn"$layers".finetune $testflag -INSWORD $option1 -GRAMMARSCALE $option2"  >> "$exp_list".txt
		grep Acc $pracdnn/exp/$dnn_folder/decode-dnn"$layers".finetune/test/LOG >> "$result_list".txt

	done
done












