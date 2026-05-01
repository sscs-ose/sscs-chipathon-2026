import subprocess
import traceback
import shutil
import os
import argparse

class extlvs():
	def __init__(self):
		self.current_directory = os.getcwd()
		self.pdk_root = os.environ.get('PDK_ROOT')
		self.design_track = os.environ.get('DESIGN_TRACK')
		self.run_dir = os.environ.get('RUN_DIR')

		self.commandLineParser()	

		self.layout_path = self.args.layout_directory
		self.source_path = self.args.source_directory

		os.chdir(self.layout_path)
		self.files = os.listdir()
		os.chdir(self.current_directory)
	
	def commandLineParser(self):
		parser = argparse.ArgumentParser(description='Runs LVS on extracted spice from magic and schematic files .')
		parser.add_argument('files', metavar='files', type=str, nargs='*', help='Schematic files to extract spice from.')
		parser.add_argument('-m', '--move', action='store_true', help='Moves extracted LVS reports to lvs directory.')
		parser.add_argument('-s', '--source_directory', type=str, help='Sets the source directory for the schematic spice files.', default=f'{self.run_dir}/lib/xschem/{self.design_track}/spice/')
		parser.add_argument('-l', '--layout_directory', type=str, help='Sets the layout directory for the layout spice files.', default=f'{self.run_dir}/lib/{self.design_track}/ngspice/')
		self.args = parser.parse_args()

	def moveFiles(self):
		names = ['.lvs.report']
		files = os.listdir()

		for f in files:
			for s in names:
				if s in f and '.swp' not in f:
					if not os.path.exists(s.split(".")[1]):
						os.mkdir(s.split(".")[1])
					shutil.move(f'./{f}', f'./{s.split(".")[1]}/{f}')
	
	def runLVS(self):
		for f in self.files:
			if '.spice' in f and '.swp' not in f and 'fill' not in f:
				print(f'Current lvs file(s): {f}')
				try:
					print(f'Running LVS on {f.split(".")[0]}')
					subout = subprocess.Popen([f'netgen -batch lvs \"{self.layout_path}{f} {f.split(".")[0]}\" \"{self.source_path}{f} {f.split(".")[0]}\" {self.pdk_root}/gf180mcuD/libs.tech/netgen/gf180mcuD_setup.tcl {f.split(".")[0]}.lvs.report'], shell=True) 
					subout.wait()
					mov = subprocess.Popen([f'mv comp.out {f.split(".")[0]}.lvs.txt'], shell=True)
					mov.wait()
				except Exception:
					print(traceback.print_exc())

if __name__ == '__main__':
	extlvs = extlvs()

	extlvs.runLVS()

	if extlvs.args.move:
		extlvs.moveFiles()
