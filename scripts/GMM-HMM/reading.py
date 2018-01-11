import numpy as np
import pandas as pd
import itertools
import sys 
results = []
result = []
param = []
result_list , exp_list = sys.argv[1] , sys.argv[2]
with open(result_list) as input_text:
    for line in input_text:
        items = [item for item in line.split(",",1)]
        items[0] = float(items[0].strip('WORD: %Corr='))
        #errors = items[1].split(" ",2)[2].split(",",5)
        items[1] = float(items[1].split(" ",2)[1].strip('Acc='))
        result.append(items)


with open(exp_list) as input_text2:
    for line in input_text2:
        items2 = [item for item in line.split(" ",5)]
        if items2[0].split("/",1)[0].split("_",5)[0] == 'MFC': 
            TEMP = len(items2[0].split("/",1)[0].split("_",5))-4
        else:
            TEMP = len(items2[0].split("/",1)[0].split("_",5))-3
        TEMP1 = ['Z', 'D', 'D2' ]
        if items2[0].split("/",2)[1].split("-",4)[1] == "xwtri": #
            TEMP2 = [items2[0].split("/",2)[1].split("-",4)[1], #model xwtri
                    items2[0].split("/",2)[1].split("-",4)[2], #roval
                    items2[0].split("/",2)[1].split("-",4)[3], #tbval
                    items2[0].split("/",2)[1].split("-",4)[-1]] # hmm84

        else:
            TEMP2 = [items2[0].split("/",2)[1].split("-",4)[1], 0.0, 0.0,
                    items2[0].split("/",2)[1].split("-",4)[-1]]

        items2 = [items2[0].split("/",1)[0].split("_",5)[0],
                  items2[0].split("/",1)[0].split("_",5)[-1],
                  TEMP1[TEMP],items2[1], TEMP2[0], 
                  TEMP2[-1], TEMP2[1], TEMP2[2],
                  float(items2[3]), float(items2[5].strip("\n"))]
        param.append(items2)


if len(result) == len(param):

    for i in range(len(result)):
            results.append(param[i] + result[i])

    results = np.asarray(results)
    df = pd.DataFrame(results)
    df[[11,10,9,6,7,8]] = df[[11,10,9,6,7,8]].astype(float)
    df_sorted = df.sort_values(by=[11], ascending=[False])

    df_sorted.columns = ['BANK', 'INIT', 'ENV',
                    'TEST','MODEL','HMM', 'RO',
                    'TB','INS','GRAM',
                    'CORR','ACC']
    print(df_sorted)
    df_sorted.to_csv("{}.csv".format(result_list.strip('.txt')))

else: 
    print('Lists dont have the same size')

