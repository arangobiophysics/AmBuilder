#!/usr/bin/env python
import numpy as np
import requests
import pandas as pd

def get_boundary(pdbfile):
	"""
	Extract the OPM dummy atom boundaries. All dummy atoms have a single negative and
	positive z value which will be returned.
	Inputs:
		pdbfile - filepath to pdbfile
	Outputs:
		returns list of boundary or <None>
	"""

	try:
		bound = [line for line in open(pdbfile).readlines() if line[17:20].strip() == 'DUM'][:2]
		zneg = float(bound[0].split()[-1])
		zpos = float(bound[1].split()[-1])
		return [zneg, zpos]
	except IndexError:
		print('No membrane boundaries detected! Will proceed with whole structure.')
		return None


def filter_coordinates(coords, lower, upper):
	"""
	Filters coordinates based on whether they lie within the bounds of the membrane.
	Inputs:
		coords - a list of strings from the pdb file
		lower - boundary of the lower leaflet in z
		upper - boundary of the upper leaflet in z
	Outputs:
		filtered - coordinate lines which lie between (lower, upper)
	"""

	filtered = []
	for coord in coords:
		z = float(coord[46:54].strip())
		if z > lower and z < upper:
			filtered.append(coord)
	return filtered


def extract_information(pdbfile):
	"""
	Function to preprocess pdb files. Extracts coordinates, residue type, atom type.
	Further incorporates chemical features such as hydrophobicity. Currently does not
	support .cif files, maybe in the future it will but for now only pdbs are accepted.
	Inputs:
		pdbfile - filepath to pdb file (e.g. /path/to/pdbfile.pdb)
	Outputs:
		info - a numpy matrix that contains all relevant geometric and chemical features
	"""
	# extract lines with atomic coords; check for OPM membrane and filter if detected
	# this requires some more work to ensure nucleic acids are handled/ignored
	coordlines = [line for line in open(pdbfile).readlines() if line[:4] == "ATOM"]
	boundary = get_boundary(pdbfile)
	if boundary != None:
		coordlines = filter_coordinates(coordlines, boundary[0], boundary[1])

	# initialize np array and fill with relevant information
	info = np.zeros((len(coordlines),6))
	# non-neutral histidine species
	histidines = ['HSE','HSD','HIE','HID']
	# non-protein segnames; includes membrane, water model, ions
	nonprotein = ['MEMB','TIP3','SOD','POT','CLA']

	for i, l in enumerate(coordlines):
		# check if non-protein segment, if so we are done
		if l[72:76].strip() in nonprotein: # this implementation will not work
			break   # for pdbs only MD trajs

		x,y,z = l[30:38].strip(),l[38:46].strip(),l[46:54].strip()
		# check if residue is an alternately protonated histidine
		residue = l[17:20].strip()
		if residue in histidines:
			residue = 'HIS'

		resname = get_resname(residue)
		atomtype = get_atomtype(l[13:17].strip())
		hydrophobicity = get_hydrophobicity(residue)
		info[i] = np.append(np.array([x,y,z,atomtype,hydrophobicity]),resname)
	
	# normalize cartesian coordinates
	info[:,:3] = normalize_coords(info[:,:3])
	return info


def get_resname(restype):
	"""
	One hot encode residue type. Currently only considers a single protonation state
	for histidine and other such charged residues. This information may need to be
	encoded separately and just the residue encoded here.
	Inputs:
		restype - the 3 letter code of an amino acid residue
	Outputs:
		a one hot vector of shape (1,20)
	"""
	canonical_restypes = ["ARG","LYS","ASP","ASN","GLU","GLN","HIS","PRO","TYR",
						  "TRP","SER","THR","GLY","ALA","MET","CYS","PHE","LEU",
						  "VAL","ILE"]

	df = pd.DataFrame(canonical_restypes, columns=['Types'])
	# create one hot vector for each restype based on dummy screen
	df = df.join(pd.get_dummies(df, columns=['Types'], prefix=['Type_is']))

	return df[df['Types'] == restype].iloc[:,1:].to_numpy()[0]


def get_atomtype(atomtype, refined=False):
	"""
	Encoding of atomtypes. Should this be one hot as well?
	Inputs:
		atomtype - string, the name of the atomtype (e.g. "CA")
		refined - boolean, whether to discriminate based on subtypes
					(e.g. "CA" versus "CB")
	Outputs:
		_type - the numerical value for the corresponding atomtype
	"""
	if refined:
		atomtypes = {}
		_type = atomtypes[atomtype]
	else:
		atomtypes = {"C":0,"N":0.25,"O":0.5,"H":0.75,"S":1}
		_type = atomtypes[atomtype[0]]

	return _type


def get_hydrophobicity(restype, scale_type="kd"):
	"""
	Compute hydrophobicity based on desired hydrophobicity scale.
	Inputs:
		restype - 3 letter code for amino acid type
		scale_type - type of hydrophobicity scale to use, defaults to kyte-doolittle
			kd: combination of several experimental datasets
			engleman: based on energy of partitioning amino chains btwn aqueous and membrane
			eisenberg: hydrophobic dipole moment and free energy to move from interior to surface
			hoop: based on water solubility of amino acids
			janin: statistical measure of tendency to be found inside protein rather than surface
	Outputs:
		normalized hydrophobicity score for amino acid
	"""

	if scale_type == "kd":
		hydrophobicity_table = {"ARG":-4.0,"LYS":-3.9,"ASP":-3.5,"ASN":-3.5,"GLU":-3.5,"GLN":-3.5,
								"HIS":-3.2,"PRO":-1.6,"TYR":-1.3,"TRP":-0.9,"SER":-0.8,"THR":-0.7,
								"GLY":-0.4,"ALA":1.8,"MET":1.8,"CYS":2.5,"PHE":2.8,"LEU":3.8,
								"VAL":4.2,"ILE":4.5}
	elif scale_type == "engleman":
		hydrophobicity_table = {"ARG":-12.3,"LYS":-8.8,"ASP":-9.2,"ASN":-4.8,"GLU":-8.2,"GLN":-4.1,
                                "HIS":-3.0,"PRO":-0.2,"TYR":-0.7,"TRP":1.9,"SER":0.6,"THR":1.2,
                                "GLY":1.0,"ALA":1.6,"MET":3.4,"CYS":2.0,"PHE":3.7,"LEU":2.8,
                                "VAL":2.6,"ILE":3.1}
	elif scale_type == "eisenberg":
		hydrophobicity_table = {"ARG":-1.80,"LYS":-1.10,"ASP":-0.72,"ASN":-0.64,"GLU":-0.62,"GLN":-0.69,
                                "HIS":-02.40,"PRO":-0.07,"TYR":0.02,"TRP":0.37,"SER":-0.26,"THR":-0.18,
                                "GLY":0.16,"ALA":0.25,"MET":0.26,"CYS":0.04,"PHE":0.61,"LEU":0.53,
                                "VAL":0.54,"ILE":0.73}
	elif scale_type == "hoop":
		hydrophobicity_table = {"ARG":3.0,"LYS":3.0,"ASP":3.0,"ASN":0.2,"GLU":3.0,"GLN":0.2,
                                "HIS":-0.5,"PRO":0.0,"TYR":-2.3,"TRP":-3.4,"SER":0.3,"THR":-0.4,
                                "GLY":0.0,"ALA":-0.5,"MET":-1.3,"CYS":-1.0,"PHE":-2.5,"LEU":-1.8,
                                "VAL":-2.5,"ILE":-1.8}
	elif scale_type == "janin":
		hydrophobicity_table = {"ARG":-1.4,"LYS":-1.8,"ASP":-0.6,"ASN":-0.5,"GLU":-0.7,"GLN":-0.7,
                                "HIS":-0.1,"PRO":-0.3,"TYR":-0.4,"TRP":0.3,"SER":-0.1,"THR":-0.2,
                                "GLY":0.3,"ALA":0.3,"MET":0.4,"CYS":0.9,"PHE":0.5,"LEU":0.5,
                                "VAL":0.6,"ILE":0.7}


	norm_term = max(hydrophobicity_table.values()) - min(hydrophobicity_table.values())
	return (hydrophobicity_table[restype] + abs(min(hydrophobicity_table.values())))/norm_term


def normalize_coords(xyz):
	"""
	Normalize the xyz coordinates of a structure. The resulting mean should be 0
	and the std. dev. should be 1.0.
	Inputs:
		xyz - a 3 col numpy array of all the coordinates
	Outputs:
		xyz - same array but normalized as described above
	"""

	for i in range(xyz.shape[1]):
		xyz[:,i] = (xyz[:,i] - np.mean(xyz[:,i])) / np.std(xyz[:,i])

	return xyz


def fetch(pdbid):
	"""
	Check the OPM database for a given pdbid, if it exists download it to the
	current working directory.
	Inputs:
		pdbid - the 4 letter code for pdb ID without the file extension
	Outputs:
		None - downloads pdb with dummy atoms marking membrane boundary
	"""
    
	url = 'https://lomize-group-opm.herokuapp.com/primary_structures/pdbid'
    r = requests.get(f'{url}/{pdbid}')
    if r.status_code != 200:
        return 'PDB not found in OPM database.'

    print('PDB Found! Accessing structural data from OPM.')

    download_url = 'https://opm-assets.storage.googleapis.com/pdb'
    dl = requests.get(f'{download_url}/{pdbid}.pdb')
    open(f'{pdbid}_opm.pdb','wb').write(dl.content)
    print('PDB Downloaded to current working directory.')
