#pull out homolog consensus sequences from output file

import sys
import os
argv = sys.argv[1:]

usage = """
<list of homologs, one per line>
<all_groups.faa output from pyparanoid>
<output name>
"""

if len(argv) == 3:
	input_list = argv.pop(0)
	all_homologs = argv.pop(0)
	output = argv.pop(0)
else:
	sys.exit(usage)


input_dict = {}
with open (input_list,'r') as il:
	for ln in il:
		input_dict[ln.replace('\n','')] = ''


with open(all_homologs,'r') as ah:
	flag = ''
	for ln in ah:
		if '>' in ln:
			locus = ln.split('-')[0].replace('>','')
			flag = locus
		else:
			if flag in input_dict:
				input_dict[flag] += ln.replace('\n','')
			#else:
			#	continue
				

with open (output,'w') as out:
	for i in input_dict:
		out.write('>' + i + '\n' + input_dict[i] + '\n')
