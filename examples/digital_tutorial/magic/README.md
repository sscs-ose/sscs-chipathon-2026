Set your `PDK_ROOT` environment variable to reach the appropriate PDK files. For example, the following `bash` command is used to set the environment variable to the appropriate value to ensure the use of the right PDK files:

```bash
    export PDK_ROOT=/opt/open_pdks/share/pdk
```

Run the following command to extract all necessary files from your Magic files:
```bash
	python3 ext4mag.py --move --extract_ngspice --add_headers --lef
```

Alternatively, please run `make` as it extracts all of your magic files by default.

To clean the directory, you may run:   

```bash
    make clean
```