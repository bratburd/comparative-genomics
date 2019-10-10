#run prokka on all genomes
#--locustag <give locus tag to specified genome>
#--outdir <name directory after species name>
#--prefix <give locus tag again>

import sys
import os

usage = 'input tab delimited file with locus tag,strain name and file name. 2. folder with files to be annotated'

argv = sys.argv[1:]

if len(argv) == 2:
	locus_tag = argv.pop(0)
	input_folder = argv.pop(0) 
else:
	sys.exit(usage)

locus_tag_dict = {}
with open (locus_tag,'r') as lt:
	for ln in lt:
		ln = ln.replace('\n','')
		locus = ln.split('\t')[0]
		strain = ln.split('\t')[1]
		filename = ln.split('\t')[2]
		locus_tag_dict[filename] = []
		locus_tag_dict[filename].append(locus)
		locus_tag_dict[filename].append(strain)

#this has not been optimized for multithreading
all_files = os.listdir(input_folder)
for a in all_files:
	if a in locus_tag_dict:
		os.system('prokka {0}/{1} --locustag {2} --outdir {3} --prefix {3} --compliant'.format(input_folder, a, locus_tag_dict[a][0], locus_tag_dict[a][1]))



