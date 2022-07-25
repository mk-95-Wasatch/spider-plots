import numpy as np 

names = ["small","medium","large","large_plus"]

def coreNum(names,multiplier=2,sizeMultiplier=8,minNum=2,maxNum=8191):
    perCase={}
    for num,name in enumerate(names):
        temp = multiplier* sizeMultiplier**(num+1)/np.array([2**i for i in range(int(np.log(maxNum)/np.log(2)- np.log(minNum)/np.log(2)))])
        if num ==0:
            trimmed = [val for val in temp if ((val<= maxNum) and (val >= minNum)) ]
            size = len(trimmed)
        perCase[name] = [val for val in list(temp[:size]) if ((val<= maxNum) and (val >= minNum))] 
    return perCase

print(coreNum(names))