
model="~/MLSALT2/pracgmm/exp/MFC_E_D_A_Z_FlatStart/mono"
hmm="hmm204"
system="gmm-mono"
echo "grammar scale list: 0 2 4 8 16 32"
read grammar_list
# echo "insertion penalty: -8 -4 -2 0"
# read ins_list

echo "Type of test: whole core sub"
read test_mode

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

folder="$bank""$envsflag"_"$initiation"
echo "Test results are stored at exp/$folder/$model"

ins=-12.5
for grammar in $grammar_list; do 

	../../tools/steps/step-decode $testflag \
	-DECODEHTE ~/MLSALT2/pracgmm/exp/bigram/HTE.phoneloop \ 
	-INSWORD $ins -GRAMMARSCALE $grammar \
	$model $hmm \ 
	$folder/decode-$system-$hmm

done


