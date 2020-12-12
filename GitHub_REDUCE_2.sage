#Last edited on August 11, 2020



#REDUCE

#This stage of the workflow involves checking the minimal codes to see if they are reduced.
#Unlike previous versions of this workflow, we will not include any information on what 
#the code reduces to, only if it is reduced.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#These are the functions used to check to see if the minimal code of a dictionary from
#our 'PREP_1.sage' file is reduced.

def checkNeurRedun(C,n,i):
	S = [Set(c) for c in C]
	sigma = Set([j for j in range(1,n+1) if j!=i])
	for c in S:
		if i in c:
			sigma = sigma.intersection(c)
	for c in S:
		if (sigma.issubset(c) and not(i in c)):
			return [False, sigma]
	return [True, sigma]

def checkAllNeurRedun(C,n):
	for i in range(1,n+1):
		checkfori = checkNeurRedun(C,n,i)
		if checkfori[0]:
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

#Important Note: Dictionaries in which the 'reduced' entry is 1 are those codes that 
#are reduced. Meaning these are the codes we want to continue examining for wheels.
#It's the dictionaries for which 'reduced' is 0 that we discard.

def REDUCE(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	load(filePath+listName+'_PREP_1.sage')

	for j in codeList:
		j['reduced'] = checkAllNeurRedun(j['C'],6)
	writeList(codeList, filePath+listName+'_REDUCE_2.sage','codeList')

def REDUCE_Pure(d,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']
	
	listName = listNames[d-1]

	load(filePath+listName+'_PREP_1.sage')

	for j in codeList:
		j['reduced'] = checkAllNeurRedun(j['C'],6)
	writeList(codeList, filePath+listName+'_REDUCE_2.sage','codeList')

def REDUCE_Pure_2D(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

	load(filePath+listName+'_PREP_1.sage')

	for j in codeList:
		j['reduced'] = checkAllNeurRedun(j['C'],6)
	writeList(codeList, filePath+listName+'_REDUCE_2.sage','codeList')