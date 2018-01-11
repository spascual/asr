#Step 1 
echo "Type of initiation: [FlatStart or Init]"
read initiation


#Step 3
echo "Choose waveform parametrisation: FBK or MFC"
read bank

#Step 4
echo "Choose environment type: _Z, (_E)_D_Z or (_E)_D_A_Z"
read envsflag

 folder="$bank""$envsflag"_"$initiation"

echo "Select a model to test!"

#Step 2
echo "Number of Gaussian components: "
read gmm
echo "Number of HRest iterations:"
read numb

echo "Testing results are at folder exp/$folder/decode-mono-hmm$gmm$numb/test/LOG"


#Visualise results 
#sed -n '20,40p;41q' 
#tail readme.txt
#grep 
#tail $folder/decode-mono-hmm$gmm$numb/test/LOG

echo $folder/decode-mono-hmm$gmm$numb >> exp_list.txt
grep Acc $folder/decode-mono-hmm$gmm$numb/test/LOG >> result_list.txt

