#!/bin/bash
echo "Training using step-dnntrain"

echo "Context in/dependent system: mono xwtri"
read model

if [ "$model" = "mono" ]; then 
	echo "GMM-HMM (best possible) used for alignment: MFC _D_A_Z FlatStart hmm324"
	read -r bank1 envs1 initiation hmm
else 
	echo "GMM-HMM triphone model: MFC _D_A_Z FlatStart 20 200 800"
	read -r bank1 envs1 initiation hmm roval tbval
	model1="$model-$roval-$tbval"
fi

echo "Parameters for the model we want to train"
echo "Bank and feature type (vary this): MFC _D_A_Z"
read -r bank envs 

echo "DNN Parameters context, layers, nodes: 1 1 500"
read -r context layers nodes

echo "Use Sigle sil option: -SINGLESIL"
read sil
# some formating

if [ "$bank" = "MFC" ]; then 
	bankfolder='mfc13d'
	envsflag='_E'$envs
	pre='M'
else
	bankfolder='fbk25d'
	envsflag=$envs
	pre='F'
fi

if [ $bank1 = "MFC" ];then
	envsflag1='_E'$envs1
else
	envsflag1=$envs1
fi

if [ "$envs" = "_Z" ];then
	feature='Z'
elif [ "$envs" = "_D_Z" ]; then
	feature='D'
else
	feature='D2'
fi


# Folder
pracgmmexp='/home/sp838/MLSALT2/pracgmm/exp'
pracdnn='/home/sp838/MLSALT2/pracdnn'
align_folder="$bank1""$envsflag1"_"$initiation"
dnn_folder="$pre""$feature"-$context-$layers-$nodes
HTE_file=$pracdnn/exp/HTE_folder/$dnn_folder/HTE.dnntrain

echo "model used in alignment from $align_folder"
echo "model trained at $dnn_folder"

	
$pracdnn/tools/steps/step-dnntrain -DNNTRAINHTE $HTE_file -USEGPUID 0 $sil \
$pracdnn/convert/$bankfolder/env/environment$envsflag \
$pracgmmexp/$align_folder/align-$model-$hmm/align/timit_train.mlf \
$pracgmmexp/$align_folder/$model/$hmm/MMF \
$pracgmmexp/$align_folder/$model/hmms.mlist $pracdnn/exp/$dnn_folder/dnntrain

echo "Final trained model at $layers+2.finetune /pracdnn/exp/$dnn_folder/dnntrain"

# The step-dnntrain command will create a complete DNN system including pre-training and fine- tuning stages with the supplied alignments based on the initial GMM-HMM MMF specified. 



