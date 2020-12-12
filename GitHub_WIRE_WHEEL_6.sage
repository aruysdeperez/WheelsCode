#Last edited on August 11, 2020

#WIRE_WHEEL_6:

#This stage of the workflow involves checking a minimal code to see if it contains a wire wheel

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

def isSunflower(triple,C):
	sigma = (triple[0].union(triple[1])).union(triple[2])
	if not(checkCover(triple[0].union(triple[1]),sigma,C)):
		return False
	elif not(checkCover(triple[0].union(triple[2]),sigma,C)):
		return False
	elif not(checkCover(triple[1].union(triple[2]),sigma,C)):
		return False
	else:
		return True

def getTriples(Ccomp):
	triples = []
	for i in Ccomp:
		for j in Ccomp:
			for k in Ccomp:
				triples.append(Set([i,j,k]))
	triples = [q for q in Set(triples)]
	return [[q[0],q[1],q[2]] for q in Set(triples) if len(list(q))==3]
 
def findSunflowers(C,Delta,Ccomp,faceListDelta):
	triples = getTriples(Ccomp)
	triples = filterTriplesInS(triples,faceListDelta)
	return [i for i in triples if isSunflower(i,C)]	

def getFaces(Delta):
	DeltaFaces = []
	for i in range(-1,dim(Delta)+1):
		temp = [list(j) for j in Delta.faces()[i]]
		DeltaFaces = DeltaFaces+temp
	return Set([Set(sigma) for sigma in DeltaFaces])

def intVert(sigma, LinkFaces):
	found = 0
	for phi in LinkFaces:
		v = sigma.intersection(phi)
		if len(v) > 1:
			return 0
		elif not (v.is_empty()):
			found = 1
			break
	if found == 0:
		return 0
	else:
		intersections = [sigma.intersection(phi) for phi in LinkFaces]
		interbools = [(v==b or b.is_empty()) for b in intersections]
		if sum(interbools)==len(interbools):
			return v
		else:
			return 0

def check_TreeLink(C):

	CasSet = Set([Set(c) for c in C])
	Delta = SimplicialComplex(C)
	DeltaFacesasSet = getFaces(Delta)
	Ccomp = DeltaFacesasSet.difference(CasSet)

	sunflowers = findSunflowers(C,Delta,Ccomp,DeltaFacesasSet)

	possibleTaus = [cprime for cprime in Ccomp if dim(Delta.link(cprime))==1]

	for tau in possibleTaus:
		currLink = Delta.link(tau)
		edges = [list(j) for j in currLink.faces()[1]]
		G = Graph(edges)
		LinkFacesasSet = getFaces(currLink)
		for trip in sunflowers:
			sigma1 = trip[0]
			sigma2 = trip[1]
			sigma3 = trip[2]
			if (sigma1.union(tau) in DeltaFacesasSet and sigma2.union(tau) in DeltaFacesasSet and sigma3.union(tau) in DeltaFacesasSet): 
				v1 = intVert(sigma1,LinkFacesasSet)
				v2 = intVert(sigma2,LinkFacesasSet)
				v3 = intVert(sigma3,LinkFacesasSet)
				if (v1 != 0 and v2 != 0 and v3 !=0 and v1 != v2 and v1 != v3 and v2 != v3):
					x1 = v1[0]
					x2 = v2[0]
					x3 = v3[0]
					if x2 in Set(G.shortest_path(x1,x3)):
						return 1
					elif x1 in Set(G.shortest_path(x2,x3)):
						return 1
					elif x3 in Set(G.shortest_path(x1,x2)):
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

def WIRE_WHEEL(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	load(filePath+listName+'_SPROCKET_5.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['wirewheel'] = check_TreeLink(j['C'])
			if j['wirewheel'] != 0:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WIRE_WHEEL_6.sage','codeList')

def WIRE_WHEEL_Pure(d,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']

	listName = listNames[d-1]

	load(filePath+listName+'_SPROCKET_5.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['wirewheel'] = check_TreeLink(j['C'])
			if j['wirewheel'] != 0:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WIRE_WHEEL_6.sage','codeList')

def WIRE_WHEEL_Pure_2D(m,filePath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):
	
	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

	load(filePath+listName+'_SPROCKET_5.sage')
	counter = 0
	for j in codeList:
		counter = counter+1
		print(counter)
		if (j['quasisolved'] == 0 and j['reduced']==1 and j['indecomposable'] == 1 and j['wheel']==0):
			j['wirewheel'] = check_TreeLink(j['C'])
			if j['wirewheel'] != 0:
				j['wheel'] = 1
	writeList(codeList, filePath+listName+'_WIRE_WHEEL_6.sage','codeList')