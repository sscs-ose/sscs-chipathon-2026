import subprocess
import traceback
import shutil
import os
import argparse

class ext4mag():
	def __init__(self):
		self.cwd = os.getcwd()

		# os.chdir('../../char/techfiles')

		# self.pdkspice = os.getcwd() 
		# os.chdir(self.cwd)

		self.commandLineParsing()

		self.cellList = os.listdir(self.args.directory)

		temporaryCellList = self.cellList.copy()

		for l in temporaryCellList:
			if (('.mag' not in l) or ('.swap' in l) or ('Makefile' in l) or ('magicrc' in l)):
				i = self.cellList.index(l)
				self.cellList.pop(i)

		first_hit = False
		directory = ''

        # Cycles through the files inputted on the command line. 
		for arg in self.args.files:
			if ('.mag' in arg) and (not first_hit):
				self.cellList = []
				self.cellList.append(arg.split('/')[-1])
				directory = arg.split('/')[:-1]
				first_hit = True
			if ('.mag' in arg) and (first_hit):
				self.cellList.append(arg.split('/')[-1])
		
		if len(self.cellList) == 0:
			print('No magic files found.')
			exit()

		self.cellList.sort()

		# Removes duplicates from the list of cells.
		self.cellList = list(set(self.cellList))

		# Joins the directory back together into a string. 
		if (directory != ''):
			directory = "/".join(directory)

		for i, cell in enumerate(self.cellList):
			if (directory != ''):
				self.cellList[i] = directory + '/' + cell
			else:
				self.cellList[i] = self.args.directory + cell

		self.files = self.cellList.copy()
		print(self.files)

	def commandLineParsing(self):
		parser = argparse.ArgumentParser(description='Extracts files from magic files.')
		parser.add_argument('files', metavar='files', type=str, nargs='*', help='Magic files to be extracted.')
		parser.add_argument('-m', "--move", help='Move extracted files to their respective subdirectory folders (i.e. gds, spice, etc.).', action='store_true')
		parser.add_argument('-ap', "--add_parameters", help='Adds the necessary paramters to the top of the HSPICE and NGSPICE files for liberate to pull in the correct models.', action='store_true')
		parser.add_argument('-ng', "--extract_ngspice", help='Extracts the NGSPICE files for use with LVS / simulation.', action='store_true')
		parser.add_argument('-t', "--top_subcircuit", help='Turns the subcircuit top on or off in the extracted ngspice netlist. -t [off|on].', type=str, default='on')
		parser.add_argument('-ah', "--add_headers", help='Adds licensing headers to all non-binary files.', action='store_true')
		parser.add_argument('-d', "--directory", help='Changes the directory to one specified to locate magic files. [default = ./]', type=str, default='./')
		parser.add_argument('-l', "--lef", help='Generates the lef and combines all macros into a single file.', action='store_true')

		self.args = parser.parse_args()

	def moveFiles(self):
		names = ['.sim', '.spice', '.gds', '.ext', '.cif', '.lef']
		files = os.listdir()

		for f in files:
			for s in names:
				if s in f and '.magicrc' not in f:
					if not os.path.exists(s.split(".")[1]):
						os.mkdir(s.split(".")[1])
					shutil.move(f'./{f}', f'./{s.split(".")[1]}/{f}') # Moves the files with the matching file extension to the appropriate directory.
				if f == 'klayout_script.py':
					shutil.move(f'./{f}', f'./gds/{f}') # Moves the files with the matching file extension to the appropriate directory.
					
	
	def runMagic(self):
		for f in self.files:
			if ('.mag' in f) and ('magicrc' not in f):
				print(f'Current magic file: {f}')
				string='drc off\nextract all\next2sim -y 6\next2spice subcircuit top on\next2spice -F -y 6 -f hspice\next2sim merge aggressive\next2sim -y 6 -R -C -o ' + f.split(".")[0] + '.sim\ncif\ncalma\nquit -noprompt\n'

				try:
					path_name = f.split(".")[-2]
					print(f'Extracting files from {path_name}.')
					subout = subprocess.run(['magic -dnull -noconsole ' + str(f) +  ' 1> MAGIC.LOG 2>&1'], shell=True, input=string.encode()) 
				except Exception:
					print(traceback.print_exc())

	def runExtractLEF(self):
		for f in self.files:
			if ('.mag' in f) and ('magicrc' not in f):
				print(f'Running LEF extraction on magic file: {f}')
				# string='drc off\nproperty LEFsite unithd\nlef write\nquit -noprompt\n'
				string='drc off\nlef write -toplayer\nquit -noprompt\n'

				try:
					path_name = f.split(".")[-2]
					print(f'Extracting files from {path_name}.')
					subout = subprocess.run(['magic -dnull -noconsole ' + str(f) +  ' 1> MAGIC.LOG 2>&1'], shell=True, input=string.encode()) 
				except Exception:
					print(traceback.print_exc())
		
		top_level = open('merged.lef', 'w')

		top_level.write('')

		top_level.write('VERSION 5.7 ;\n')
		top_level.write('BUSBITCHARS "[]" ;\n')
		top_level.write('DIVIDERCHAR "/" ;\n\n')

		for f in self.files:
			if ('.mag' in f):
				print(f'Opening LEF file: {f.replace(".mag", ".lef")}')
				fr = open(f.replace(".mag", ".lef"), 'r')
				lines = fr.readlines()

				macro_true = False
	
				for line in lines:
					if 'END LIBRARY' in line:
						top_level.write('\n\n')
						break
					if 'MACRO ' in line:
						macro_true = True
						top_level.write(line)
					elif macro_true and 'FOREIGN' in line:
						forgein_line = line
					elif macro_true and 'ORIGIN' in line:
						top_level.write(line.replace(".000", ""))
						top_level.write(forgein_line)
					elif macro_true and 'via ' in line:
						top_level.write(line.replace("via ", "via1 "))
					elif macro_true:
						top_level.write(line)
		top_level.write('END LIBRARY')

	def extractNgspice(self):
		for f in self.files:
			if ('.mag' in f) and ('magicrc' not in f):
				print(f'Current magic file for ngspice extraction: {f}')
				string=f'drc off\nextract\next2spice lvs\next2spice\nquit -noprompt\n'

				try:
					path_name = f.split(".")[-2]
					print(f'Extracting files from {path_name}.')
					subout = subprocess.run(['magic -dnull -noconsole ' + str(f) +  ' 1> MAGIC.LOG 2>&1'], shell=True, input=string.encode()) 
				except Exception:
					print(traceback.print_exc())
		
		if ( not os.path.exists('ngspice')):
			os.mkdir('ngspice')
		if ( not os.path.exists('ext')):
			os.mkdir('ext')

		files = os.listdir()

		# Modifies the models to be correct with the model file.
		#subout = subprocess.run(["sed -i 's/03v3/03p3/g' *.spice"], shell=True)

		for f in files:
			if ((('.spice' in f) and ('.ext' not in f)) and (not os.path.isdir(f))):
				shutil.move(f'./{f}', f'./ngspice/{f}')
			if ((('.ext' in f) and ('.spice' not in f)) and (not os.path.isdir(f))):
				shutil.move(f'./{f}', f'./ext/{f}')
	

	def addParamstoSpice(self, dir):
		param = f'.inc \"{self.pdkspice}/design.hspice\"\n.lib \"{self.pdkspice}/sm141064.hspice\" typical\n\n.GLOBAL VDD\n.GLOBAL VSS\n\n'

		os.chdir(f'{self.cwd}/{dir}')

		# Changes the model nomenclature to match the nomenclature of the hspice file.
		subout = subprocess.run(["sed -i 's/03v3/03p3/g' *.spice"], shell=True)

		files = os.listdir()

		for f in files:	
			if('.swp' in f):
				continue
			with open(f, 'r+') as out:
				lines = out.readlines()

				lines.insert(2, param)

				out.seek(0) #Sets the first line as the current location of the file ready to overwrite.

				for line in lines:
					out.write(line)
		os.chdir(self.cwd)
	
	def labelAdjust(self): #This function adjusts the cell labels to only reside on the metal 2 layer. Possible future iterations may not need this function.
		for f in self.files:
			if (('.mag' in f) and ('.swp' not in f) and ('.swo' not in f) and ('magicrc' not in f)):
				print(f'Current magic file: {f}')
				with open(f, 'r+') as out: 
					lines = out.readlines()
					for i, line in enumerate(lines):
						if ('rlabel via1' in line):
							print(f'Replacing label rlabel via1 in {f} on line {i}')
							newline = line
							newline = newline.replace('rlabel via1', 'rlabel metal2')
							lines[i] = newline
						else:
							continue

					out.seek(0)

					for line in lines:
						out.write(line)

	def addHeaders(self):
		files = os.listdir()
		mag = '# Copyright 2022 Google LLC\n#\n# Licensed under the Apache License, Version 2.0 (the "License");\n# you may not use this file except in compliance with the License.\n# You may obtain a copy of the License at\n#\n#      http://www.apache.org/licenses/LICENSE-2.0\n#\n# Unless required by applicable law or agreed to in writing, software\n# distributed under the License is distributed on an "AS IS" BASIS,\n# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n# See the License for the specific language governing permissions and\n# limitations under the License.\n'
		for f in files:
			if (('.mag' in f) and ('.swp' not in f) and ('.swo' not in f)):
				print(f'Adding header to current magic file {f}')
				with open(f, 'r+') as out:
					lines = out.readlines()
					
					for i, line in enumerate(lines):
						if i == 0 and 'magic' in line: #Checks to make sure the magic file doesn't already contain the header.
							lines.insert(0, mag)
							break
						else:
							break

					out.seek(0)

					for line in lines:
						out.write(line)
		
		if self.moveFiles:
			os.chdir('./spice')

		files = os.listdir()
		spice = '* Copyright 2022 Google LLC\n*\n* Licensed under the Apache License, Version 2.0 (the "License");\n* you may not use this file except in compliance with the License.\n* You may obtain a copy of the License at\n*\n*      http://www.apache.org/licenses/LICENSE-2.0\n*\n* Unless required by applicable law or agreed to in writing, software\n* distributed under the License is distributed on an "AS IS" BASIS,\n* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n* See the License for the specific language governing permissions and\n* limitations under the License.\n'

		for f in files:
			if (('.spice' in f) and ('.swp' not in f) and ('.swo' not in f)):
				print(f'Adding header to current spice file {f}')
				with open(f, 'r+') as out:
					lines = out.readlines()
					for i, line in enumerate(lines):
						if i == 0 and '* HSPICE' in line: #checks to make sure the spice deck doesn't already contain the header.
							del lines[0]
							lines.insert(0, spice)
							break
						else:
							break
					out.seek(0)

					for line in lines:
						out.write(line)
		
		os.chdir('../')

		if self.moveFiles:
			os.chdir('./ngspice')

		files = os.listdir()
		spice = '* Copyright 2022 Google LLC\n*\n* Licensed under the Apache License, Version 2.0 (the "License");\n* you may not use this file except in compliance with the License.\n* You may obtain a copy of the License at\n*\n*      http://www.apache.org/licenses/LICENSE-2.0\n*\n* Unless required by applicable law or agreed to in writing, software\n* distributed under the License is distributed on an "AS IS" BASIS,\n* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n* See the License for the specific language governing permissions and\n* limitations under the License.\n\n'

		for f in files:
			if (('.spice' in f) and ('.swp' not in f) and ('.swo' not in f)):
				print(f'Adding header to current spice file {f}')
				with open(f, 'r+') as out:
					lines = out.readlines()
					for i, line in enumerate(lines):
						if i == 0 and '* NGSPICE' in line: #checks to make sure the spice deck doesn't already contain the header.
							lines.insert(0, spice)
							break
						else:
							break
					out.seek(0)

					for line in lines:
						out.write(line)

		os.chdir('../')
		
		print('Finished adding the headers.')

	def spiceConverge(self): #This function adjusts the cell labels to only reside on the metal 2 layer. Possible future iterations may not need this function.
		os.chdir('./ngspice')
		files = os.listdir()
		files.sort()

		# output_file_name = files[-1].split('__')[0]
		output_spice_file = open(f'merged.spice', 'w')
  
		for f in files:
			print(f'Current spice file: {f}')
			if (('spice' in f) and ('.swp' not in f) and ('.swo' not in f) and ('.py' not in f) and ('.ext' not in f) and (f'merged.spice' not in f)):
				with open(f, 'r') as input_spice_file: 
					output_spice_file.write(f"****BOF - {f}" + "\n\n")
					lines = input_spice_file.readlines()
					output_spice_file.writelines(lines)
					output_spice_file.write("\n\n")
					output_spice_file.write(f"****EOF - {f}\n")
		
		os.chdir('../')

	def mergeGDS(self): # Merges the individual cell GDS files into a single GDS file using calibredrv tcl script generated here (merge.tcl). 
		os.chdir(f'./gds/')

		with open(f'merge.tcl', 'w') as f:

			f.write('layout filemerge -append  \\\n')

			for cell in self.cellList:
				cell = cell.replace(".mag", "")
				f.write(f'  -in {os.getcwd()}/{cell}.gds \\\n')

			f.write(f'  -out merged.gds')
		
		subout = subprocess.run(['calibredrv ./merge.tcl'], shell=True)

		os.remove('./merge.tcl')
		# Must add the full path for the files in order for the shutil function to overwrite already
		# existing files.
		shutil.move(os.path.join('./', 'merged.gds'), os.path.join('../', 'merged.gds'))
		os.chdir('../')

	def mergeGDSKlayout(self): # Merges the individual cell GDS files into a single GDS file using calibredrv tcl script generated here (merge.tcl). 
		os.chdir('./gds')

		with open(f'klayout_script.py', 'w') as f:

			f.write('import pya\n\n')

			cell_string = 'cells = ['

			for iter, cell in enumerate(self.cellList[1:]):
				cell = (cell.replace(".mag", ".gds")).replace("./", "")
				if iter == 0:
					cell_string += f'\'{cell}\''
				else:
					cell_string += f',\'{cell}\''
        
			cell_string += ']'

			f.write(cell_string + '\n\n')

			f.write('layout = pya.Layout()\n')
			f.write(f'lmap = layout.read("{(self.cellList[0].replace(".mag", ".gds")).replace("./", "")}")\n')
			f.write('TOP = layout.top_cell()\n')
			f.write('load_options = pya.LoadLayoutOptions()\n')
			f.write('load_options.text_enabled = True\n')
			f.write('load_options.set_layer_map(lmap, True)\n\n')

			f.write('for cell in cells:\n')
			f.write('	layout.read(f"{cell}", load_options)\n\n')

			f.write('layout.write("merged.gds")\n')

		subout = subprocess.run(['klayout -b -r ./klayout_script.py'], shell=True)
		shutil.move(os.path.join('./', 'merged.gds'), os.path.join('../', 'merged.gds'))
		shutil.move(os.path.join('./', 'klayout_script.py'), os.path.join('../', 'klayout_script.py'))
		os.chdir('../')

if __name__ == '__main__':
	ext4mag = ext4mag()
	
	ext4mag.labelAdjust() #Moves labels to metal 2 layer prior to extraction.

	if(len(ext4mag.args.files) > 0):
		ext4mag.files = ext4mag.args.files

	ext4mag.runMagic() #Runs magic extraction function.

	# Modify the models to be correct.
	#subout = subprocess.run(["sed -i 's/03v3/03p3/g' *.spice"], shell=True)
	# Extracts the LEF files from magic as opposed to abstract.
	if ext4mag.args.lef:
		ext4mag.runExtractLEF() #Extracts ngspice files from magic.

	if ext4mag.args.move:
		ext4mag.moveFiles() #Moves files to appropriate subdirectories (spice, ngspice, gds, etc.)
		# ext4mag.mergeGDS() #Merges all GDS files into one using calibredrv
		# ext4mag.mergeGDSKlayout() # Merges the cells using klayout script.

	if ext4mag.args.extract_ngspice:
		ext4mag.extractNgspice() #Extracts ngspice files from magic.

	# This is used for PEX extraction.
	if ext4mag.args.add_parameters:
		ext4mag.addParamstoSpice('spice') #Adds parameters to hspice files to accurately load in model files.

	if ext4mag.args.add_parameters and ext4mag.args.extract_ngspice:
		ext4mag.addParamstoSpice('ngspice') #Adds parameters to ngspice files to accurately load in model files.

	if ext4mag.args.move and os.path.isdir('ngspice'): # Only combine files when the ngspice folder is available.
		ext4mag.spiceConverge() #Combines all ngspice files into one file.
	
	if ext4mag.args.add_headers:
		ext4mag.addHeaders() #Adds licensing headers to all non-binary files.
