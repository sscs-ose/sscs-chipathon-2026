
# Digital Building Blocks Track Resources

1. The purpose of this track is to learn about how digital standard cells are created at the level of individual building blocks.  This includes questions such as:

    - What gates are needed to make a complete standard cell library?
    - How do synthesis tools make use of the available set of standard cells?
    - How do standard cell libraries target specific power or performance goals?
    - What are best practices to ensure correct placement and good routability?

2. Review the [Standard Cell Overview](./files/Chipathon_digital_track_overview.pdf) document.  This document will be used as the basis of the track's introductory/overview meeting on June 27, 2025.  It gives a general explanation of how standard cells are designed, and what tools are needed to create new standard cells (or entire standard cell libraries) and integrate them into a digital synthesis flow.  Note that this is a "lightweight" overview presentation and will (soon) be accompanied by a more in-depth presentation.

3. The github workflow template [GF180 Analog Design Workflow GitHub Repo Template](https://github.com/Jianxun/iic-osic-tools-project-template) can be used for all of the tracks, as it contains a docker image with all of the open source EDA tools we need for analog and mixed-signal circuit design.  This workflow template can be used to set up your project repo on GitHub; especially recommended for those who are new to docker and GitHub.  Check details on the MOSbias track documentation [MOSbius Chipathon 2025 Documentation GitHub Repo](https://github.com/JuanMoya/Chipathon2025_MOSbius_main_documentation).

4. Look at the GF 7-track standard cell library for GF180MCU, which can be found at
	[GF Standard Cells](https://github.com/fossi-foundation//globalfoundries-pdk-libs-gf180mcu_fd_sc_mcu7t5v0).  This is a good example of a small but full-featured standard cell set.  It has been used in the open-MPW shuttle runs sponsored by Google a few years ago.  It is made for 5V use only, so it is a "high voltage" logic family.

5. Look at the OSU (Oklahoma State University) standard cell library designed as an addition to the open PDK.  It is a 3.3V standard cell library.  [OSU Standard Cells](https://github.com/stineje/globalfoundries-pdk-libs-gf180mcu_osu_sc).

6. When looking at the standard cell libraries, note particularly what logic gates are being implemented, and in what drive strengths.  There is a "minimum set" of gates from which any design can be synthesized, but the more gates exist in a library, the better the tools can optimize layout for any given design.  The OSU standard cell set is larger than the "minimum set" but considerably smaller than a full-featured set like the GF 5V standard cells.

7. The goal of the Digital Building Blocks track will be to study the OSU standard cell library in depth, determine what additional cells would be most likely to aid synthesis, and design and characterize these cells, ultimately creating a library addendum to the OSU standard cell set and contributing it back to the repository.  In the process, we will learn how standard cells are designed, how they are characterized, and how to generate all of the files that are needed by synthesis, place and route tools.

8. Synopsys Cloud has been made available for Chipathon 2025.  Details on access to Synopsys Cloud will be worked out soon.  Open source tools do not yet have a complete flow for characterizing standard cells and generating liberty files.  We will look at what is missing and what is possible using open source EDA tools, but we will make use of Synopsys tools to do the "heavy lifting" and ensure that we have output that we can sign off on.

9. At the end of the track, we should be able to do a side-by-side comparison of various digital circuits synthesized with the original standard cell set and with the augmented standard cell set, and measure gains in area efficiency, performance, or whatever it is that we have chosen as our goal.
4. For the main part of this track, we will look at the
