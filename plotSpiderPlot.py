import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.ticker import StrMethodFormatter, NullFormatter

# user specified inputs
#--------------------------
mult = 8  # multiplier between problem sizes
nNodes = [2**i for i in range(10)]
nCoresPerNode = 12
normFontSize = 12
bigFontSize = normFontSize + 2
smallFontSize = normFontSize - 2

fontName = "serif"
fontWeight = "normal"
lineWidth = 1

# case names
names = ["small","medium","large","large_plus"]
# names = ["small","medium","large"]
#--------------------------

# plots parameters
#------------------
font = {'family': fontName,
        'weight': fontWeight,
        'size': normFontSize}

matplotlib.rc('font', **font)
matplotlib.rc('lines', lw=lineWidth)
matplotlib.rc('text', usetex=False)
plt.rcParams['mathtext.fontset'] = 'stix'



# the directory name ordering is assumed [0] small, [1] medium, [3] large, ...
dirname = {}
for num, name in enumerate(names):
    dirname[name] = "{}/outputs/scalingData".format(name) 

legendText = ["Strong", "Ideal", "Weak"]

data = {}
for case_num, case_name in enumerate(dirname.keys()):
    data[case_name] ={}
    for num,colname in enumerate(["MPIprocs","threadsPerMPI","totalThreads","startTime","endTime","aveMean"]):
        data[case_name][colname] = np.loadtxt(dirname[case_name],skiprows=1,usecols=num+1)

    # compute relative problem size
    data[case_name]["relSize"] = mult**(case_num)/data[case_name]["MPIprocs"]
    if case_num ==1:
        relProbSize_1 = data[case_name]["relSize"]
        
    print("rel size: ", data[case_name]["relSize"])
    # compute the run index rIndex
    data[case_name]["rIndex"] = np.ones_like(data[case_name]["relSize"])* (case_num+1)

sameRelSizeData = {}
for targetProbSize in relProbSize_1:
    sameRelSizeData[targetProbSize] = {}
    sameRelSizeData[targetProbSize]["cores"]=[]
    sameRelSizeData[targetProbSize]["aveMean"]=[]
    for case_num, case_name in enumerate(dirname.keys()):
        for num, size in enumerate(data[case_name]["relSize"]): 
            if np.abs(size-targetProbSize)<= 0.0001:
                sameRelSizeData[targetProbSize]["cores"].append(data[case_name]["MPIprocs"][num])
                sameRelSizeData[targetProbSize]["aveMean"].append(data[case_name]["aveMean"][num])

print("same size data",sameRelSizeData)

f, ax = plt.subplots(nrows=1, ncols=1, sharex=False, sharey=False)
f.set_size_inches([4, 3.5])
ax.grid(which='minor', alpha=0.19)

print("Strong Scaling: ")
print("----------------")

maxMeanTime= 0
minMeanTime= 0
maxCoreCount= 0 
for case_num, case_name in enumerate(dirname.keys()):
    # show the user what is being plotted:
    cores = data[case_name]["MPIprocs"]
    meanTime = data[case_name]["aveMean"]

    maxMeanTime = max(maxMeanTime,np.max(meanTime))
    minMeanTime = min(minMeanTime,np.min(meanTime))

    maxCoreCount = max(maxCoreCount,np.max(cores))
    
    print("scalingStudy:          {}".format(case_name))
    print("Run:                   {}".format(data[case_name]["rIndex"][0]))
    print("Cores:                 {}".format(cores))
    print("meanTime per timestep: {}".format(meanTime))
    print("-----------------------------------------------------------")

    # plot the meanTime vs #cores  
    ax.loglog(cores,meanTime,color='k',marker='o')

    # plot the power law
    # plaw = lambda b,x=1: (b*x)**(-1) 
    # ax.loglog(cores,plaw(cores),color='k')

for size in sameRelSizeData.keys():
    cores = sameRelSizeData[size]["cores"]
    meanTime = sameRelSizeData[size]["aveMean"]
    ax.loglog(cores,meanTime,'--',color='k')

maxMeanTime *=2
maxCoreCount*=2
minMeanTime /=2

ax.yaxis.set_major_formatter(StrMethodFormatter('{x:.2f}'))
ax.yaxis.set_minor_formatter(NullFormatter())

x_ticks = [2**i for i in range(1,int(np.log(maxCoreCount)/np.log(2))+1)]

ax.set_xticks(x_ticks)   
ax.set_xticklabels(x_ticks)
ax.xaxis.set_minor_formatter(NullFormatter())

ax.set_xlabel(r'Processors', fontsize=bigFontSize)
ax.set_ylabel(r'Mean Time Per Timestep (s)', fontsize=bigFontSize)

# ax.set_ylim(top=maxMeanTime)
ax.set_xlim(right=maxCoreCount)

plt.tight_layout()
plt.savefig("./scaling.png")
plt.close()
# print(data) 