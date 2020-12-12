######Below are the functions we used to classify neural codes on five neurons.#######

#given a set of sets, returns the intersection of all sets in that set.
def intersect_all_c(setList):
    first = setList[0]
    length = (setList).cardinality()
    for i in range (0, length):
        first = first.intersection(setList[i])
    return first

#given a set of sets, generates all intersections of collections of those sets, and returns those which are not already in the code
#if fed a set of maximal faces, will generate all intersectios of maximal faces
def intersections_c(setList):
    result= []
    subsets = Subsets(setList)
    for i in range(1, (subsets).cardinality()):
        result.append(intersect_all_c(subsets[i]))
    return Set(result)-setList

#given a homology, returns true if the homology group is trivial in every dimension
def is_trivial_c(homology):
    length = len(homology.viewvalues())
    trivial_complex = SimplicialComplex([range(0, length)])
    return homology == trivial_complex.homology()

#the function link_checker takes a neural code as an input and outputs the links of all intersections of elements in the code that are not in the code
def link_checker_c(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    links_to_check = intersections_c(code)
    bad_links = []
    homologies = []
    for i in range(0,(links_to_check).cardinality()):
        current_link = simplicial_complex.link(Simplex(links_to_check[i]))
        if (is_trivial_c(current_link.homology())==false):
            bad_links.append(current_link)
            homologies.append(current_link.homology())
    return (links_to_check, bad_links, homologies)

#this function takes a neural code as input and outputs true if has no local obstructions and false otherwise
def bool_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    if maximal.cardinality()==1:
        return true
    else:
        links_to_check = intersections_c(code)
        for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                return false
        return true

    
    
    
#Given a neural code, returns detailed information about it. Will not give the right result if the code does not contain the empty set. 
#to do: say whether a neural code has no local obstructions because it is closed under intersection of maximal codewords, or because the links of intersections of maximal codewords are contractible
def detailed_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    n_max = maximal.cardinality()
    if n_max == 1:
        print "The neural code " + str(code) + " is convex because it only has one maximal face."
        return true
    else:
        links_to_check = intersections_c(code)
        missing_codewords = []
        for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                missing_codewords.append(links_to_check[i])
        if (missing_codewords == []):
            print "The neural code " + str(code) + " has no local obstructions, and has maximal faces " + str(maximal) + " ."
            return true
        else:
            print "The neural code " + str(code) + " has a local obstruction. This could be remedied if the following codewords were added: " + str(missing_codewords)
           
#input: a neural code
#output: a list of faces required for that neural code to not have local obstructions
def another_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    n_max = maximal.cardinality()
    links_to_check = intersections_c(code)
    missing_codewords = []
    for i in range(0,(links_to_check).cardinality()):
        current_link = simplicial_complex.link(Simplex(links_to_check[i]))
        if (is_trivial_c(current_link.homology())==false):
            missing_codewords.append(links_to_check[i])
    return missing_codewords        
            
#input: a list of neural codes
#output: a list of lists of required codewords
def required_codewords(codes):
    result = []
    for code in codes:
        result.append(another_link_checker(code))
    return result

#input: a neural code
#output: a tuple containing (missing mandatory codewords, missing intersections of maximal codewords which are not mandatory, number of faces of the simplicial complex of the code which are neither maximal nor mandatory codewords)
#this is most useful to run on a neural code described only in terms of maximal faces--you then get the mandatory codewords, the non-mandatory intersections of maximal faces, and the number of optional facets of the simplicial complex--this lets you find the number of neural codes on the simplex with no local obstructions
def optional_max_inter(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    links_to_check = intersections_c(code)
    missing_codewords = []
    for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                missing_codewords.append(links_to_check[i])
    num_optional_faces = len([f for f in simplicial_complex.face_iterator()])-len(simplicial_complex.facets())-len(missing_codewords)
    return (missing_codewords, links_to_check.difference(Set(missing_codewords)), num_optional_faces)


#input: list of tuples of tuples
#output: list of sets of sets, each set of sets containing the empty set 
#converts output from nauty() into a format which works well with my neural code functions
def tuples_to_sets(the_list):
    outputlist = []
    for big_tuple in the_list:
        outerset = Set([])
        for small_tuple in big_tuple:
            innerset = Set(small_tuple)
            outerset = outerset.union(Set([innerset]))
            outerset = outerset.union(Set([Set([])]))
        outputlist.append(outerset)    
    return outputlist

#input: list of tuples of tuples, each tuple of tuple giving the maximal faces of a simplicial complex
#output: a latex table whose rows are, from left to right: 
#maximal faces of simplicial complex, mandatory codewords, optional intersections of maximal codewords, number of non maximal faces
def make_table(complex_list):
    complex_set = tuples_to_sets(complex_list)
    missing_codeword_list = []
    optional_codeword_list = []
    num_optional_list = []
    for current_complex in complex_set:
        current_tuple = optional_max_inter(current_complex)
        missing_codeword_list.append(current_tuple[0])
        optional_codeword_list.append(current_tuple[1])
        num_optional_list.append(current_tuple[2])
    return latex(table(columns=[complex_set, missing_codeword_list, optional_codeword_list, num_optional_list]))    
        
        
#input: a list of neural codes as tuples of tuples
#output: a list of intersections of maximal faces whose links are convex
def find_optional_max_inter(code_list):
    result = []
    for code in code_list:
        result.append(optional_max_inter(code))
    return result


#####Here are the functions we used to generate the set of simplicial complexes on five vertices. Nauty generates lists of hypergraphs, rather than of simplicial complexes, so we needed to sort through the output to find those hypergraphs which contained only maximal faces.#####


#input: two ordered tuples of integers, the smaller one listed first
#output: boolean, whether the smaller is contained in the larger
def containment_check(smaller, larger):
    counter_s = 0
    counter_l = 0
    while (counter_l < len(larger)):
        #print "counters: S-"+str(counter_s)+ "   L-" +str(counter_l)
        if (counter_s >= len(smaller)):
            return true
        elif (smaller[counter_s] == larger[counter_l]):
            counter_s = counter_s + 1
            counter_l = counter_l + 1
            if counter_s==len(smaller):
                return true
        elif (smaller[counter_s] < larger[counter_l]):
            #print "first false"
            return false
        elif (smaller[counter_s] > larger[counter_l]):
            counter_l = counter_l + 1  
    #print "second"        
    return false

#We used nauty() to enumerate hypergraphs up to isomorphism
#nauty(number_of_sets, number_of_vertices, vertex_min_degree=1,connected=True)
#to enumerate all simplicial complexes on n vertices, we let number_of_sets range from 1 to (n choose 2)/2, since a simplicial complex on n vertices cannot have more than (n choose 2)/2 facets


#input: tuple of tuples of integers. tuple of tuple is ordered by length; tuples of integers are in ascending order
#output: whether there are any containments in that tuple
def max_only_check(code):
    for i in range(0,len(code)):
        for j in range((i+1),len(code)):
            if (len(code[j])>len(code[i])):
                if (containment_check(code[i], code[j]) == true):
                    return false
    else:
        return true            

#input: a list of hypergraphs, presented as list of tuples of tuples, ordered as specified in max_only_check
#output: a tuple containing (a list of the simplicial complexes described in terms of maximal faces, "bad:", a list of hypergaphs that contain non-maximal faces )
def check_list_for_maximality(test):
    good_complexes = []
    bad_complexes = []
    for code in test:
        if max_only_check(code):
            good_complexes.append(code)
        else:
            bad_complexes.append(code)
    return (good_complexes, "bad: ", bad_complexes)   

#input: a list of hypergraphs, presented as list of tuples of tuples, ordered as specified in max_only_check
#output: the number of simplicial complexes, specified in terms of maximal elements, in that list
def numerical_check_list_for_maximality(test):
    num_simplicial_complexes = 0
    for code in test:
        if max_only_check(code):
            num_simplicial_complexes= num_simplicial_complexes+1
    return num_simplicial_complexes            











######Below are the functions we used to classify neural codes on five neurons.#######

#given a set of sets, returns the intersection of all sets in that set.
def intersect_all_c(setList):
    first = setList[0]
    length = (setList).cardinality()
    for i in range (0, length):
        first = first.intersection(setList[i])
    return first

#given a set of sets, generates all intersections of collections of those sets, and returns those which are not already in the code
#if fed a set of maximal faces, will generate all intersectios of maximal faces
def intersections_c(setList):
    result= []
    subsets = Subsets(setList)
    for i in range(1, (subsets).cardinality()):
        result.append(intersect_all_c(subsets[i]))
    return Set(result)-setList

#given a homology, returns true if the homology group is trivial in every dimension
def is_trivial_c(homology):
    length = len(homology.viewvalues())
    trivial_complex = SimplicialComplex([range(0, length)])
    return homology == trivial_complex.homology()

#the function link_checker takes a neural code as an input and outputs the links of all intersections of elements in the code that are not in the code
def link_checker_c(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    links_to_check = intersections_c(code)
    bad_links = []
    homologies = []
    for i in range(0,(links_to_check).cardinality()):
        current_link = simplicial_complex.link(Simplex(links_to_check[i]))
        if (is_trivial_c(current_link.homology())==false):
            bad_links.append(current_link)
            homologies.append(current_link.homology())
    return (links_to_check, bad_links, homologies)

#this function takes a neural code as input and outputs true if has no local obstructions and false otherwise
def bool_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    if maximal.cardinality()==1:
        return true
    else:
        links_to_check = intersections_c(code)
        for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                return false
        return true

    
    
    
#Given a neural code, returns detailed information about it. Will not give the right result if the code does not contain the empty set. 
#to do: say whether a neural code has no local obstructions because it is closed under intersection of maximal codewords, or because the links of intersections of maximal codewords are contractible
def detailed_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    n_max = maximal.cardinality()
    if n_max == 1:
        print "The neural code " + str(code) + " is convex because it only has one maximal face."
        return true
    else:
        links_to_check = intersections_c(code)
        missing_codewords = []
        for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                missing_codewords.append(links_to_check[i])
        if (missing_codewords == []):
            print "The neural code " + str(code) + " has no local obstructions, and has maximal faces " + str(maximal) + " ."
            return true
        else:
            print "The neural code " + str(code) + " has a local obstruction. This could be remedied if the following codewords were added: " + str(missing_codewords)
           
#input: a neural code
#output: a list of faces required for that neural code to not have local obstructions
def another_link_checker(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    n_max = maximal.cardinality()
    links_to_check = intersections_c(code)
    missing_codewords = []
    for i in range(0,(links_to_check).cardinality()):
        current_link = simplicial_complex.link(Simplex(links_to_check[i]))
        if (is_trivial_c(current_link.homology())==false):
            missing_codewords.append(links_to_check[i])
    return missing_codewords        
            
#input: a list of neural codes
#output: a list of lists of required codewords
def required_codewords(codes):
    result = []
    for code in codes:
        result.append(another_link_checker(code))
    return result

#input: a neural code
#output: a tuple containing (missing mandatory codewords, missing intersections of maximal codewords which are not mandatory, number of faces of the simplicial complex of the code which are neither maximal nor mandatory codewords)
#this is most useful to run on a neural code described only in terms of maximal faces--you then get the mandatory codewords, the non-mandatory intersections of maximal faces, and the number of optional facets of the simplicial complex--this lets you find the number of neural codes on the simplex with no local obstructions
def optional_max_inter(code):
    simplicial_complex = SimplicialComplex(code)
    maximal = simplicial_complex.facets()
    links_to_check = intersections_c(code)
    missing_codewords = []
    for i in range(0,(links_to_check).cardinality()):
            current_link = simplicial_complex.link(Simplex(links_to_check[i]))
            if (is_trivial_c(current_link.homology())==false):
                missing_codewords.append(links_to_check[i])
    num_optional_faces = len([f for f in simplicial_complex.face_iterator()])-len(simplicial_complex.facets())-len(missing_codewords)
    return (missing_codewords, links_to_check.difference(Set(missing_codewords)), num_optional_faces)


#input: list of tuples of tuples
#output: list of sets of sets, each set of sets containing the empty set 
#converts output from nauty() into a format which works well with my neural code functions
def tuples_to_sets(the_list):
    outputlist = []
    for big_tuple in the_list:
        outerset = Set([])
        for small_tuple in big_tuple:
            innerset = Set(small_tuple)
            outerset = outerset.union(Set([innerset]))
            outerset = outerset.union(Set([Set([])]))
        outputlist.append(outerset)    
    return outputlist

#input: list of tuples of tuples, each tuple of tuple giving the maximal faces of a simplicial complex
#output: a latex table whose rows are, from left to right: 
#maximal faces of simplicial complex, mandatory codewords, optional intersections of maximal codewords, number of non maximal faces
def make_table(complex_list):
    complex_set = tuples_to_sets(complex_list)
    missing_codeword_list = []
    optional_codeword_list = []
    num_optional_list = []
    for current_complex in complex_set:
        current_tuple = optional_max_inter(current_complex)
        missing_codeword_list.append(current_tuple[0])
        optional_codeword_list.append(current_tuple[1])
        num_optional_list.append(current_tuple[2])
    return latex(table(columns=[complex_set, missing_codeword_list, optional_codeword_list, num_optional_list]))    
        
        
#input: a list of neural codes as tuples of tuples
#output: a list of intersections of maximal faces whose links are convex
def find_optional_max_inter(code_list):
    result = []
    for code in code_list:
        result.append(optional_max_inter(code))
    return result


#####Here are the functions we used to generate the set of simplicial complexes on five vertices. Nauty generates lists of hypergraphs, rather than of simplicial complexes, so we needed to sort through the output to find those hypergraphs which contained only maximal faces.#####


#input: two ordered tuples of integers, the smaller one listed first
#output: boolean, whether the smaller is contained in the larger
def containment_check(smaller, larger):
    counter_s = 0
    counter_l = 0
    while (counter_l < len(larger)):
        #print "counters: S-"+str(counter_s)+ "   L-" +str(counter_l)
        if (counter_s >= len(smaller)):
            return true
        elif (smaller[counter_s] == larger[counter_l]):
            counter_s = counter_s + 1
            counter_l = counter_l + 1
            if counter_s==len(smaller):
                return true
        elif (smaller[counter_s] < larger[counter_l]):
            #print "first false"
            return false
        elif (smaller[counter_s] > larger[counter_l]):
            counter_l = counter_l + 1  
    #print "second"        
    return false

#We used nauty() to enumerate hypergraphs up to isomorphism
#nauty(number_of_sets, number_of_vertices, vertex_min_degree=1,connected=True)
#to enumerate all simplicial complexes on n vertices, we let number_of_sets range from 1 to (n choose 2)/2, since a simplicial complex on n vertices cannot have more than (n choose 2)/2 facets


#input: tuple of tuples of integers. tuple of tuple is ordered by length; tuples of integers are in ascending order
#output: whether there are any containments in that tuple
def max_only_check(code):
    for i in range(0,len(code)):
        for j in range((i+1),len(code)):
            if (len(code[j])>len(code[i])):
                if (containment_check(code[i], code[j]) == true):
                    return false
    else:
        return true            

#input: a list of hypergraphs, presented as list of tuples of tuples, ordered as specified in max_only_check
#output: a tuple containing (a list of the simplicial complexes described in terms of maximal faces, "bad:", a list of hypergaphs that contain non-maximal faces )
def check_list_for_maximality(test):
    good_complexes = []
    bad_complexes = []
    for code in test:
        if max_only_check(code):
            good_complexes.append(code)
        else:
            bad_complexes.append(code)
    return (good_complexes, "bad: ", bad_complexes)   

#input: a list of hypergraphs, presented as list of tuples of tuples, ordered as specified in max_only_check
#output: the number of simplicial complexes, specified in terms of maximal elements, in that list
def numerical_check_list_for_maximality(test):
    num_simplicial_complexes = 0
    for code in test:
        if max_only_check(code):
            num_simplicial_complexes= num_simplicial_complexes+1
    return num_simplicial_complexes            
