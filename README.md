# WheelsCode
SageMath scripts used to detect wheels in neural codes.

-The following scripts are a workflow used on a combinatorial object called a 'neural code'.
For the purposes of this project/repository, we can think of a neural code on n neurons as
a collection of subsets of {1,2,...,n}. The purpose of the workflow is to check neural codes
for a phenomenon called a 'wheel'.

-The scripts act on a list of dictionaries. For each dictionary, one of the entries is 
a simplicial complex. Another entry is the 'minimal code' of that simplicial complex. There 
are other entries that are added and modified by the workflow, such as an entry flagging
whether or not a wheel has been found in the minimal code.

-Each file corresponds to a step taken in the search for the wheels. The steps correspond to
different stages in the processing of a list of dictionaries, and must be done in 
order according to their number. That is, we begin a search of a particular set of neural codes
by specifying a set of simplicial complexes and having PREP_1 generate them. We feed the output
file from PREP_1 into REDUCE_2, then the output file from REDUCE_2 to DECOMPOSE_3, and so on...

-Each of the scripts' tasks can be quickly summarized as follows:
  PREP_1: Generate list of dictionaries, with each dictionary containing a unique simplicial complex
  and its minimal code. Filter out dictionaries in which the minimal code contains all intersections of
  maximal codewords.
  REDUCE_2: Check remaining dictionaries to see if the minimal code is 'reduced', as defined by the paper "Morphisms
  of Neural Codes" by Amzi Jeffs. Filter out dictionaries for which the minimal code is not reduced.
  DECOMPOSE_3: Check remaining dictionaries to see if the minimal code is 'indecomposable', as defined by the paper
  "Wheels: a new criterion for convexity for non-convexity of neural codes" by Laura Matusevich, Anne Shiu,
  and Alexander Ruys de Perez. Filter out dictionaries for which the minimal code is not indecomposable.
  WHEEL_FRAME_4: Check remaining dictionaries to see if the minimal code contains a type of wheel known as a 
  'wheel frame'.
  SPROCKET_5: Check remaining dictionaries to see if the minimal code contains a type of wheel known as a 
  'sprocket'.
  WIRE_WHEEL_6: Check remaining dictionaries to see if the minimal code contains a type of wheel known as a 
  'wire wheel'.
  
Note: Information about wheels, as well as the three types of wheel mentioned above, can be found in the paper "Wheels: 
a new criterion for convexity for non-convexity of neural codes".
Note: Once the workflow found a wheel in a particular minimal code, it ignored that code for further searches. I.e. if
a wheel frame was found in code C during Step 4, in Steps 5 and 6 the script would not search C for a sprocket or a wire wheel.

-Each script contains three different main functions. These different functions are due to computational difficulties. We had 
hoped to process all simplicial complexes on 6 vertices, but this proved too much. Therefore, we restricted our process to smaller
sets of simplicial complexes. The default main function, whose name was the step's name, was for when the list consisted of those dictionaries
for which the simplicial complex had precisely 6 neurons and m facets. The function whose name was the step's name with "PURE" appended,
was for when the simplicial complexes generated were pure of a particular dimension d. The last function, whose name had "PURE_2D" appended,
was for the special case when we had to generate those simplicial complexes that were pure when the dimension was 2.

-There are still some parts of the script that need to be generalize. In particular, the paths used to store the files have been hard-coded in.

