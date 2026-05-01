.PHONY: lvs purge 

export DESIGN_TRACK?=12t
export DESIGN?=gf180_sc_osu_${DESIGN_TRACK}

default: lvs

all: purge lvs 

purge:
	-@rm -rf lvs/
	-@rm -rf *_lvs*

lvs: 
	python3 extlvs.py --move -s ../xschem/ -l ../magic/ngspice/ 
	rm -rf ${DESIGN_TRACK}_lvs
	mv -f lvs/ ${DESIGN_TRACK}_lvs/
