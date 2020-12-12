#Last modified August 15, 2020

#PREP:

#NOTE: The aim is to provide a streamlined workflow where all the functions from all the different files
#we use are gathered together, with comments removed. If there are questions, I mention the original files
#where you can see the functions with their comments.
#ALSO NOTE: We may not use all the functions from each file we're referencing, so not all of the functions may have been copied over.

#	We use functions from Caitlin Lienkaemper's 'obstructions.sage' file

load('/media/sf_Sage_Code/Wheels/CaitlinLienkaemperCode/obstructions.sage')

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Functions for Step One: For fixed m, generate the connected simplicial complexes on 6 neurons and with m facets, and initialize the dictionaries


def tuple2stoList2s(tuple2List):
	return [[list(j) for j in i] for i in tuple2List]

def upNeurCodeword(codeword):
	return [i+1 for i in codeword]

def upNeurCode(code):
	return [upNeurCodeword(i) for i in code]

def upNeurCodeList(codelist):
	return [upNeurCode(i) for i in codelist]

def getSCsbyDimension(n,m,d,pure_only):
	if pure_only:
		nmd_hgs = list(hypergraphs.nauty(m,n,multiple_sets=False,vertex_min_degree=1,uniform=d+1,connected=True))
	else:
		nmd_hgs = list(hypergraphs.nauty(m,n,multiple_sets=False,vertex_min_degree=1,set_max_size=d+1,set_min_size=1,connected=True))
	nmd_scs = [i for i in nmd_hgs if max_only_check(i)]
	return nmd_scs

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Functions for Step Two: Compute the mandatory codewords of each simplicial complex, get the minimal code, and determine if (quasi-)solved.

def isContract(Delta,f):
	currentLink = Delta.link(f)
	return is_trivial_c(currentLink.homology())

def getMandWords(S):
	maxWords = Set([Set(i) for i in S])
#	setmaxInts = intersections_c(maxWords)
#~~~~~~~~~~~~~~~~~~~~~~~~~
#August 15, 2020: the intersections_c command is valid for finding the max-intersection faces,
#however it takes too long on codes that have lots of maximal codewords; therefore I'm replacing
#it with the following:
	Delta = SimplicialComplex(maxWords)
	#enumerate faces of simplicial complex
	Deltafaces = [Set([j for j in i]) for i in Delta.face_iterator()]
	#get all the non-maximal faces of the simplicial complex
	notMax = [i for i in Deltafaces if i not in maxWords]
	setmaxInts = []
	for i in notMax:
		#for each non-maximal i, determine which max codewords contain
		#i, and intersect them; if the intersection is equal to i, then
		#is is a max-intersection face
		tempMax = Set([1,2,3,4,5,6])
		for j in maxWords:
			if i.issubset(j):
				tempMax = tempMax.intersection(j)
		if i==tempMax:
			setmaxInts.append(i)
	setmaxInts = Set(setmaxInts)
#~~~~~~~~~~~~~~~~~~~~~~~~~
	mandWords = []
#	Delta = SimplicialComplex(maxWords)
	for i in setmaxInts:
		if not isContract(Delta,Simplex(i)):
			mandWords.append(i)
	return([Set(mandWords),setmaxInts-Set(mandWords)])


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Functions for Step Three: Write the dictionaries to a list

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

def PREP(m,Lpath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['FourFac','FiveFac','SixFac','SevenFac','EightFac','NineFac','TenFac']

	listName = listNames[m-4]

	#Step One:

	mySCs = getSCsbyDimension(6,m,5,False)
	mySCs = tuple2stoList2s(mySCs)
	mySCs = upNeurCodeList(mySCs)
	dictList = []
	counter = 0
	for i in mySCs:
		counter = counter+1
		dictList.append({'sc':i,'wheel':0,'id':listName+str(counter)})

	#Step Two:
	
	counter = 0
	for i in dictList:
		counter = counter+1
		[mand,nonmand] = getMandWords(i['sc'])
		mandWords = [list(j) for j in mand]
		nonmandWords = [list(j) for j in nonmand]
		i['C'] = i['sc']+mandWords
		if Set([Set(j) for j in nonmand]) == Set([]):
			i['solved'] = 1
			i['quasisolved'] = 1
		elif Set([Set(j) for j in nonmand]) == Set([Set([])]):
			i['solved'] = 0
			i['quasisolved'] = 1
		else:
			i['solved'] = 0
			i['quasisolved'] = 0

	#Step Three:
	
	writeList(dictList,Lpath+listName+'_PREP_1.sage','codeList')

def PREP_Pure(d,Lpath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['Pure1D','Pure2D','Pure3D','Pure4D','Pure5D']

	listName = listNames[d-1]

#The main thing we have to change from the original PREP is the input of the number of facets. The nauty() function
#is tricky in that while you can specify the number of neurons (6) and specify that all the hyper-edges have 
#the same cardinality (d+1, where d is the current dimension of pure codes we're looking at), you also have to
#specify the number of hyper-edges. Therefore, instead of getting all the hypergraphs for pure of dim d in one 
#execution, we have to determine the highest number of hyper-edges a hypergraph on 6 vertices with only hyper-edges
#of size d+1 can have, and then iterate m from 1 to that max number,
#executing nauty(n= 6, no. of hyper-edges = m, size of all hyper-edges = d+1), at each iteration.  

#dim 1: facets have 2 verts, total no. of facets pure s.c. on 6 verts with dim 1 can have is (6 choose 2) = 15
#dim 2: facets have 3 verts, total no. of facets pure s.c. on 6 verts with dim 2 can have is (6 choose 3) = 20  
#dim 3: facets have 4 verts, total no. of facets pure s.c. on 6 verts with dim 3 can have is (6 choose 4) = 15
#dim 4: facets have 5 verts, total no. of facets pure s.c. on 6 verts with dim 4 can have is (6 choose 5) = 6
#dim 5: facets have 6 verts, total no. of facets pure s.c. on 6 verts with dim 5 can have is (6 choose 6) = 1

	edgeMaxes = [15, 20, 15, 6, 1]

	edgeMax = edgeMaxes[d-1]

	#Step One:
	mySCs = []
	for m in range(1,edgeMax+1):
		tempSCs = getSCsbyDimension(6,m,d,True)
		tempSCs = tuple2stoList2s(tempSCs)
		tempSCs = upNeurCodeList(tempSCs)
		mySCs = mySCs+tempSCs
	dictList = []
	counter = 0
	for i in mySCs:
		counter = counter+1
		dictList.append({'sc':i,'wheel':0,'id':listName+str(counter)})

	#Step Two:
	
	counter = 0
	for i in dictList:
		counter = counter+1
		[mand,nonmand] = getMandWords(i['sc'])
		mandWords = [list(j) for j in mand]
		nonmandWords = [list(j) for j in nonmand]
		i['C'] = i['sc']+mandWords
		if Set([Set(j) for j in nonmand]) == Set([]):
			i['solved'] = 1
			i['quasisolved'] = 1
		elif Set([Set(j) for j in nonmand]) == Set([Set([])]):
			i['solved'] = 0
			i['quasisolved'] = 1
		else:
			i['solved'] = 0
			i['quasisolved'] = 0

	#Step Three:
	
	writeList(dictList,Lpath+listName+'_PREP_1.sage','codeList')


def PREP_Pure_2D(m,Lpath = '/media/sf_Sage_Code/Wheels/August4_Formal_Workflow_for_Paper/'):

	listNames = ['Pure2D_1Fac','Pure2D_2Fac','Pure2D_3Fac','Pure2D_4Fac','Pure2D_5Fac','Pure2D_6Fac','Pure2D_7Fac','Pure2D_8Fac','Pure2D_9Fac','Pure2D_10Fac','Pure2D_11Fac','Pure2D_12Fac','Pure2D_13Fac','Pure2D_14Fac','Pure2D_15Fac','Pure2D_16Fac','Pure2D_17Fac','Pure2D_18Fac','Pure2D_19Fac','Pure2D_20Fac']

	listName = listNames[m-1]

#Idea is to follow the workflow started by PREP_Pure, generating each set of pure codes with m facets. However,
#instead of bundling all these m-specific facet sets together into one big set, we will send each set through
#the workflow by itself. 

	#Step One:
	mySCs = getSCsbyDimension(6,m,2,True)
	mySCs = tuple2stoList2s(mySCs)
	mySCs = upNeurCodeList(mySCs)
	dictList = []
	counter = 0
	for i in mySCs:
		counter = counter+1
		dictList.append({'sc':i,'wheel':0,'id':listName+str(counter)})

	#Step Two:
	
	counter = 0
	for i in dictList:
		counter = counter+1
		[mand,nonmand] = getMandWords(i['sc'])
		mandWords = [list(j) for j in mand]
		nonmandWords = [list(j) for j in nonmand]
		i['C'] = i['sc']+mandWords
		if Set([Set(j) for j in nonmand]) == Set([]):
			i['solved'] = 1
			i['quasisolved'] = 1
		elif Set([Set(j) for j in nonmand]) == Set([Set([])]):
			i['solved'] = 0
			i['quasisolved'] = 1
		else:
			i['solved'] = 0
			i['quasisolved'] = 0

	#Step Three:
	
	writeList(dictList,Lpath+listName+'_PREP_1.sage','codeList')

		
