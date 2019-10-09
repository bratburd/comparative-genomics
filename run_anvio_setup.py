#batch run anvio setup

import os
import sys

usage = """<folder of input folders>""" #needs to be full path to folder, also currently set to run from anvio/ folder
argv = sys.argv[1:]
if len(argv) == 1:
	input_folder = argv.pop(0)
	#output = argv.pop(0)
else:
	sys.exit(usage)

all_files = os.listdir(input_folder)
for f in all_files:
	name_stub = f.split('.')[0].replace('-','_')
	os.system('anvi-script-reformat-fasta {0}{1} -l 200 -o ./reformat/{2}_reformat.fna --simplify-names'.format(input_folder,f,name_stub))
	os.system('anvi-gen-contigs-database -f ./reformat/{0}_reformat.fna -o ./db/{0}.db'.format(name_stub))
	os.system('anvi-run-hmms -T 16 -c db/{0}.db'.format(name_stub))
	os.system('anvi-run-ncbi-cogs -T 16 -c ./db/{0}.db'.format(name_stub))
