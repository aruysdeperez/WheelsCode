#Last edited on August 11, 2020

#SPROCKET_5:

#This stage of the workflow involves checking a minimal code to see if it contains a sprocket.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#NOTE: The conditions that I say each function is testing for may not match with the condition
#stated in the theorem. This is because this script was written before we had finalized our
#definition for a sprocket, and so some conditions might have been re-numbered.

#WORKFLOW:
#(1) Take all intersections of maximal codewords of C
#(2*) Filter out all intersections that are contained in C.
#For each max-intersection tau not contained in C:
#	(3) Compute Lk, the link of tau in Delta(C)
#	(4) Take all triples of faces of Lk (order doesn't matter)
#	(5) Filter out all triples whose union is in Lk
#	(6) Filter out all triples not satisfying condition [P(i)]
#	For each remaining triple {a,b,c}:
#		For the permutations (a,b,c), (a,c,b), and (b,a,c):
#			(7) Check to see if condition D2(iii) (minus
#				the part about sigma_j \cup tau in
#				Delta(C) for j=1,2,3) is satisfied


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (1) Functions: Getting the intersections of maximal 
#codewords

def getMaxCodewords(S):
	return [Set(list(i)) for i in S.facets()]

def getAllIntersections(L):
	if len(L) == 1:
		return L
	else:
		L1 = getAllIntersections(L[1:len(L)])
		L2 = [L[0].intersection(i) for i in L1]
		newL = [L[0]]+L2+L1
		return [i for i in Set(newL)]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (2) Functions: Filtering out the intersections of
#maximal codewords that are codewords

def filterCodewords(L,C):
#	Edit August 7: change from 'i not in C' to 'list(i) not in C'
#	Otherwise wouldn't do any filtering
	return [i for i in L if list(i) not in C]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (3) Functions: n/a because SageMath already has a 
#function for taking the link 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (4) and (5) Functions: Taking all the faces of the link
#and organizing them into triples for which the union of the
#elements in each triple is not contained in the link

def getFaces(S):
	faceList = []
	for i in range(-1,S.dimension()+1):
		faceList = faceList+[Set(list(j)) for j in S.faces()[i]]
	return faceList

#August 7, 2020: Previously the triples consisted only of (sigma1, sigma2, sigma3), with each sigmai
#disjoint from tau. I'm concerned that this is too strict and we might miss some sprockets. So, I'm
#adding this new function that will change the set of candidates from just the set of faces of the 
#link of tau, to {alpha U beta | alpha a face of Lk(tau), beta a subset of tau}. The function expandFaces
#defined adds in these extra faces.

#Inputs are -LkfaceList, a list of Sets of integers
#	representing the faces of the link
#	    -tau, a Set of integers
#	    -SfaceList, a list of Sets of integers
#	representing the faces of the entire simplicial complex	
def expandFaces(LkfaceList,tau,SfaceList):
	tauSubsets = [Set(i) for i in tau.subsets()]
	expandedList = []
	for i in LkfaceList:
		for j in tauSubsets:
			#this if statement is to make sure that 
			#union of the link face with the subset of tau is still a face of
			#the overall simplicial complex
			if (i.union(j) in SfaceList):
				expandedList.append(i.union(j))
	return [i for i in Set(expandedList)] 


def getTriplesforTau(faceList):
	TriplesforTau = []
	for i in faceList:
		for j in faceList:
			if not (i.issubset(j) or j.issubset(i)):
				for k in faceList:
					if not (i.issubset(k) or k.issubset(i) or j.issubset(k) or k.issubset(j)):
						ijk = (i.union(j)).union(k)
						if ijk not in faceList:
							TriplesforTau.append(Set([i,j,k]))
	return [i for i in Set(TriplesforTau)]



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (6) Functions: Filter out those triples failing to
#satisfy condition [P(i)]: that is, either their union is not
#contained in Delta(C) or there exists some codeword
#that contains the union of two but not the union of all three.

def testForInS(triple,faceListS):
	sigma = (triple[0].union(triple[1])).union(triple[2])
	return sigma in faceListS

def filterTriplesInS(triples,faceListS):
	return [i for i in triples if testForInS(i,faceListS)]

def checkCover(phi,psi,C):
	for c in C:
		d = Set(c)
		if phi.issubset(d):
			if not(psi.issubset(d)):
				return False
	return True

def condi(triple,C):
	sigma = (triple[0].union(triple[1])).union(triple[2])
	if not(checkCover(triple[0].union(triple[1]),sigma,C)):
		return False
	elif not(checkCover(triple[0].union(triple[2]),sigma,C)):
		return False
	elif not(checkCover(triple[1].union(triple[2]),sigma,C)):
		return False
	else:
		return True

def filterForCondi(triples,C):
	return [i for i in triples if condi(i,C)]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#STEP (7) Functions: Checking condition [S(iii)]

def checkCover2(phi,psi1,psi2,C):
	for c in C:
		d = Set(c)
		if phi.issubset(d):
			if not(psi1.issubset(d) or psi2.issubset(d)):
				return False
	return True
	 
def getRhos(sigmatau,faceListS,C):
	return [j for j in faceListS if checkCover(sigmatau,j,C)]

def getRhoPairs(rho1s,rho3s,tau,C):
	rhoPairs = []
	for i in rho1s:
		temp = [j for j in rho3s if checkCover2(tau,i,j,C)]
#I proved that if we set rho1=rho3 and it satisfies condition (iii) for (sigma1,sigma2,sigma3,tau)
#and code C, then (sigma1,sigma2,sigma3,tau) is not a wheel of C [Prop 5.3 from wheels paper]. Thus, we may assume for our
#rhopairs below that rho1 != rho3.
		rhoPairs = rhoPairs+ [Set([i,j]) for j in temp if Set([i,j]).cardinality()==2]
	return [k for k in Set(rhoPairs)]

def condiii(sigma1,sigma2,sigma3,tau,faceListS,C):
	rho1s = getRhos(sigma1.union(tau),faceListS,C)
	rho3s = getRhos(sigma3.union(tau),faceListS,C)
	rhoPairs = getRhoPairs(rho1s,rho3s,tau,C)
	for i in rhoPairs:
		rhoU = i[0].union(i[1])
		theU = rhoU.union(tau)
		if checkCover(theU,sigma2,C):
			#print(i)
			return True
	return False
			
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#This function integrates all the previous steps together. I have
#changed it from before so that if a wheel is found, only a true value
#is returned, and not the wheel itself

def wheelCheck2_0(C):
	S = SimplicialComplex(C)
	maxCodewords = getMaxCodewords(S)
	taus = getAllIntersections(maxCodewords)
	taus = filterCodewords(taus,C)
	faceListS = getFaces(S)
	for tau in taus:
		tauLink = S.link(Simplex(tau))
		faceListLk = getFaces(tauLink)
#August 7, 2020: add in the new expandFaces function here
		faceListLk = expandFaces(faceListLk, tau, faceListS)
		tauTriples = getTriplesforTau(faceListLk)
		tauTriples = filterTriplesInS(tauTriples,faceListS)
		tauTriples = filterForCondi(tauTriples,C)
		for trip in tauTriples:
			if condiii(trip[0],trip[1],trip[2],tau,faceListS,C):
				return 1
			elif condiii(trip[1],trip[2],trip[0],tau,faceListS,C):
				return 1
			elif condiii(trip[2],trip[0],trip[1],tau,faceListS,C):
				return 1
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

def SPROCKET(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	load(filePath+listName+'_WHEEL_FRAME_4.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['sprocket'] = wheelCheck2_0(j['C'])
			if j['sprocket'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_SPROCKET_5.sage','codeList')

def SPROCKET_Pure(d,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']

	listName = listNames[d-1]

	load(filePath+listName+'_WHEEL_FRAME_4.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['sprocket'] = wheelCheck2_0(j['C'])
			if j['sprocket'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_SPROCKET_5.sage','codeList')


def SPROCKET_Pure_2D(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

	load(filePath+listName+'_WHEEL_FRAME_4.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['sprocket'] = wheelCheck2_0(j['C'])
			if j['sprocket'] == 1:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_SPROCKET_5.sage','codeList')