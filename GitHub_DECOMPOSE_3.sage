#Last edited on August 11, 2020

#DECOMPOSE:

#This stage of the workflow involves checking the minimal codes to see if they are indecomposable.
#Unlike previous versions of this workflow, we will not include any information on what the code
#decomposes into if it is reduced.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#These are the functions used to check to see if the minimal code of a dictionary from
#our '..._REDUCE_1.sage' file is indecomposable. Note the following:
#	1) We check that the embeddingAtom is indeed an atom. That is, it is in C. The previous
#	version did not make this check.
#	2) We've simplified the output. The output is now whether or not a code is indecomposable. If the
#	code is decomposable, we no longer bother with showing how it decomposes.
#	3) It might look a little confusing for determining which of 0 or 1 signals decomposable.
#	To make things in line with the output from REDUCE_2, where we ignore dictionaries for which the
#	entry is 0, we make it so that indecomposable codes have the dictionary entry of 1. 

def checkEmbedded(S,C):
	C = [Set(c) for c in C]
	D = [c for c in C if not((S.intersection(c)).is_empty())]
	D = [i.difference(S) for i in D]
	embeddingAtom = D[0]
	D = [embeddingAtom == i for i in D]
	if (len(D) == sum(D)):
		if embeddingAtom in C:
			return 1
		else:
			return 0
	else:
		return 0

def checkDecomposable(C,n=6):
	theSubsets = list(Set(range(1,n+1)).subsets())
	theSubsets.remove(Set([]))
	theSubsets.remove(Set(range(1,n+1)))
	for i in theSubsets:
		isDecomposable = checkEmbedded(i,C)
		if isDecomposable == 1:
			return 0
	return 1

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#This function is for writing the finished codes back to a file.

def writeList(L,Lpath,Lname):
	f = open(Lpath,'w')
	f.write(Lname+'=[')
	if (len(L)>0):
		f.write(str(L[0]))
		for i in range(1,len(L)):
			f.write(',\r\n'+str(L[i]))
	f.write(']')
	f.close()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Main:

def DECOMPOSE(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	load(filePath+listName+'_REDUCE_2.sage')

	for j in codeList:
		j['indecomposable'] = checkDecomposable(j['C'])
	writeList(codeList, filePath+listName+'_DECOMPOSE_3.sage','codeList')

def DECOMPOSE_Pure(d,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']

	listName = listNames[d-1]

	load(filePath+listName+'_REDUCE_2.sage')

	for j in codeList:
		j['indecomposable'] = checkDecomposable(j['C'])
	writeList(codeList, filePath+listName+'_DECOMPOSE_3.sage','codeList')

def DECOMPOSE_Pure_2D(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

	load(filePath+listName+'_REDUCE_2.sage')

	for j in codeList:
		j['indecomposable'] = checkDecomposable(j['C'])
	writeList(codeList, filePath+listName+'_DECOMPOSE_3.sage','codeList')