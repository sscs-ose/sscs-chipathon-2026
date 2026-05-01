import subprocess
import traceback
import shutil
import sys
import os
import argparse

class extspice():
	def __init__(self):
		self.files = os.listdir()
		self.commandLineParser()

	def commandLineParser(self):
		parser = argparse.ArgumentParser(description='Extracts spice files from xschem schematics.')
		parser.add_argument('files', metavar='files', type=str, nargs='*', help='Schematic files to extract spice from.') 
		parser.add_argument('-m', '--move', action='store_true', help='Moves extracted spice files to the spice directory.')

		self.args = parser.parse_args()

	def moveFiles(self):
		names = ['.spice']
		files = os.listdir()

		for f in files:
			for s in names:
				if s in f and '.swp' not in f:
					if not os.path.exists(s.split(".")[1]):
						os.mkdir(s.split(".")[1])
					shutil.move(f'./{f}', f'./{s.split(".")[1]}/{f}')
	
	def runXschem(self):
		for f in self.files:
			if '.sch' in f and '.swp' not in f:
				print(f'Current schematic file: {f}')
				try:
					print(f'Extracting spice from {f.split(".")[0]}.')
					subout = subprocess.Popen([f'xschem -n -o . ./{f} -q'], shell=True) 
					subout.wait()
				except Exception:
					print(traceback.print_exc())

if __name__ == '__main__':
	extspice = extspice()

	if(len(extspice.args.files) > 0):
		extspice.files = extspice.args.files

	extspice.runXschem()

	if extspice.args.move:
		extspice.moveFiles()
