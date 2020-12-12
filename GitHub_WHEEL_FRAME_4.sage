#Last edited on August 11, 2020

#WHEEL_FRAME_4:

#This stage of the workflow involves checking a minimal code to see if it contains a wheel frame.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def enumFaces(S):
	faceList = [Set([j for j in i]) for i in sorted(S.face_iterator())]
	return faceList

def disjointTriples(setList):
	disjoint_triples = []
	for a in setList:
		for b in setList:
			if (a!=b) and (a.intersection(b)).is_empty():
				for c in setList:
					if (a!=c) and (b!=c):
						if (a.intersection(c)).is_empty() and (b.intersection(c)).is_empty():
							disjoint_triples.append(Set([a,b,c]))
	disjoint_triples = [i for i in Set(disjoint_triples)]
	return disjoint_triples

def gotUnion(A,B,setList):
	return A.union(B) in Set(setList)

def cond1(sigma1,sigma2,tau,faceList):
	return (gotUnion(sigma1, tau, faceList) and gotUnion(sigma2,tau,faceList))

def cond2(sigma1,sigma2,tau,C,n):
	neurons = Set(range(1,n+1))
	top = neurons.difference(sigma1.union(sigma2))
	bottom = tau
	for i in C:
		iset = Set(i)
		if (iset.issubset(top) and iset.issuperset(bottom)):
			return False
	return True
	
def cond3A(sigma1,sigma2,tau,faceList,C):
	if (not gotUnion(sigma1,sigma2,faceList)):
		return False
	sigmaU = sigma1.union(sigma2)
	L1 = [s for s in faceList if s.issubset(sigmaU)]
	L2 = [s for s in L1 if not (s.issubset(sigma1) or s.issubset(sigma2))]
	L3 = [s for s in L2 if s.union(tau) in faceList] 
	for c in C:
		d = Set(c)
		if (not sigmaU.issubset(d)):
			for sigma in L3:
				if (sigma1.union(sigma)).issubset(d): 
					return False
		 		if (sigma2.union(sigma)).issubset(d):
					return False
	return True

def cond4(sigma1, sigma2, tau, faceList):
	return (not gotUnion(sigma1.union(sigma2),tau,faceList))

def checkWheel(sigma1,sigma2,tau,faceList,C,n):
	return (cond1(sigma1,sigma2,tau,faceList) and
		cond2(sigma1,sigma2,tau,C,n) and
		cond3A(sigma1,sigma2,tau,faceList,C) and
		cond4(sigma1,sigma2,tau,faceList))

def checkCodeforWheel(C):
	S = SimplicialComplex(C)
	n = len(S.vertices())
	Sfaces = enumFaces(S)
	trips = disjointTriples(Sfaces)
	found = False
	for i in trips:
		firSig = i[0]
		secSig = i[1]
		Tau = i[2]
		if checkWheel(firSig,secSig,Tau,Sfaces,C,n):
			found = True
			break
		firSig = i[0]
		secSig = i[2]
		Tau = i[1]
		if checkWheel(firSig,secSig,Tau,Sfaces,C,n):
			found = True
			break
		firSig = i[2]
		secSig = i[1]
		Tau = i[0]
		if checkWheel(firSig,secSig,Tau,Sfaces,C,n):
			found = True
			break
	if found:
		return 1
	else:
		return 0

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

def WHEEL_FRAME(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	load(filePath+listName+'_DECOMPOSE_3.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1):
			j['wheelframe'] = checkCodeforWheel(j['C'])
			if j['wheelframe'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WHEEL_FRAME_4.sage','codeList')

def WHEEL_FRAME_Pure(d,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']

	listName = listNames[d-1]

	load(filePath+listName+'_DECOMPOSE_3.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1):
			j['wheelframe'] = checkCodeforWheel(j['C'])
			if j['wheelframe'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WHEEL_FRAME_4.sage','codeList')

def WHEEL_FRAME_Pure_2D(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

	load(filePath+listName+'_DECOMPOSE_3.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1):
			j['wheelframe'] = checkCodeforWheel(j['C'])
			if j['wheelframe'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WHEEL_FRAME_4.sage','codeList')