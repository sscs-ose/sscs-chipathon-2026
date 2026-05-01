.PHONY: clean extract

default: extract

all: default

clean:
	-@rm -f *.cif *.sim *.gds *.ext *.spice *.lef
	-@rm -rf ./cif/ ./sim/ ./gds/ ./ext/ ./spice/ ./ngspice/
	-@rm MAGIC.LOG
	-@rm log.txt

extract: 
	python3 ext4mag.py --move --extract_ngspice --add_headers --lef