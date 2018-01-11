#!/bin/bash
echo "Context in/dependent system: mono xwtri"
read model

echo "Bank and feature type (vary this): MFC _D_A_Z"
read -r bank envs 

echo "DNN Parameters context, layers, nodes"

echo "Fix nodes=500 and list of context: 1 5 9 13"
read context_list

echo "list of layers:"
read layers_list

for context in $context_list
	do 
	if [ "$bank" = "MFC" ]; then 
		bankfolder='mfc13d'
		envsflag='_E'$envs
		pre='M'
		if [ "$envs" = "_Z" ];then
			feature='Z'
			inlayer=$((context * 13))
		elif [ "$envs" = "_D_Z" ]; then
			feature='D'
			inlayer=$((context * 26))
		else
			feature='D2'
			inlayer=$((context * 39))
		fi
	else
		bankfolder='fbk25d'
		envsflag=$envs
		pre='F'
		if [ "$envs" = "_Z" ];then
			feature='Z'
			inlayer=$((context * 24))
		elif [ "$envs" = "_D_Z" ]; then
			feature='D'
			inlayer=$((context * 48))
		else
			feature='D2'
			inlayer=$((context * 72))
		fi
	fi

#context string
	temp=$((context-1))
	temp=$((temp/2))
	for i in $(seq  -$temp $temp) 
		do
		if [ "$i" = "-$temp" ]; then
			cont_str="$i"
		elif [ "$temp" = "0" ]; then
			cont_str="$i"
		else 
			cont_str="$cont_str,$i"
		fi
	done

	for layers in $layers_list
		do
		layers=$((layers - 2))
		substr=
		for j in $(seq 1 $layers)
			do
			add="X500"
			substr="$substr""$add"
		done
		
		dnn_str="$inlayer""$substr""X3000"
		echo "$dnn_str"
		echo "$cont_str"

	done
done

pracdnn="/home/sp838/MLSALT2/pracdnn"
dnn_folder="$model"-"$pre""$feature"-$context-$layers-$nodes
HTE_dir="$pracdnn/exp/HTE_folder/$dnn_folder/"

mkdir $HTE_dir
cp $pracdnn/exp/HTE.dnntrain $HTE_dir



done
