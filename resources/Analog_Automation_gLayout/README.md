# gLayout Track Resources

- [Brief Overview of the gLayout](./files/gLayout_Overview.pdf)
- 🤖 [GitHub Repo](https://github.com/ReaLLMASIC/gLayout)
- :eyes: [Getting Started](https://docs.google.com/document/d/e/2PACX-1vT1jADYn6HAjlp1b3KB7T0nAkxzmT5GXo7NzFjxZ47M9s9H3oyHdoU39wxUscF8DtTNeQ3Egeo_1e1s/pub)
  - [IIC-OSIC Docker Image setup](../IIC-OSIC-TOOLS/README.md)
  - [gLayout Specific Setup](./files/gLayout_Install.md)
- :books: [gLayout Tutorials](https://github.com/ReaLLMASIC/gLayout/tree/main/tutorial)
  - [Flipped Voltage Follower (FVF)](https://github.com/ReaLLMASIC/gLayout/blob/main/tutorial/glayout_tutorial_FVF_part1.ipynb)
  - [Inverter (INV)](https://github.com/ReaLLMASIC/gLayout/blob/main/tutorial/glayout_tutorial_INV_part1.ipynb)
- :pushpin: Design Challenge
  - [Detailed Requirements](./Challenge.md)
  - [Kickoff Slides](https://docs.google.com/presentation/d/11iUuCnZQZhC-76pMEIqsWOjoYRWxP6tA/edit?slide=id.g369dd00d293_0_563#slide=id.g369dd00d293_0_563)
- 🦾 [Contribution Guidelines](https://docs.google.com/presentation/d/e/2PACX-1vRYHpcxItcbHfINOcBYVJ0q8JRr79yXTh8uxrhY4bHtAs3voaiZQN49snRvW8E6vg/pub?slide=id.g36c8198f0d5_0_37)
  - [Fork the gLayout Repo]() 
  - [Contribute]()
  - [Create Merge Request]()

## gLayout

### A PDK-agnostic layout automation framework for analog circuit design.

gLayout is a powerful layout automation tool that generates DRC-clean circuit layouts for any technology implementing the gLayout framework. It is implemented as an easy-to-install Python package with all dependencies available on PyPI.

Key features:

- PDK-agnostic layout generation
  - Generic layer mapping
  - Technology-independent design rules
  - Support for multiple PDKs (sky130, gf180)
  - DRC-clean layout generation
- Basic Cell Generators
  - Via stack generation
  - Transistor generation (NMOS/PMOS)
  - Guard ring generation
  - And more...
- Natural language processing for circuit design
  - Convert natural language descriptions to layouts
  - Support for standard components
  - Custom component definitions
- Integration with Klayout for visualization and verification

## Citation

If you use gLayout in your research, please cite our papers:

```bibtex
@article{hammoud2024human,
  title={Human Language to Analog Layout Using gLayout Layout Automation Framework},
  author={Hammoud, A. and Goyal, C. and Pathen, S. and Dai, A. and Li, A. and Kielian, G. and Saligane, M.},
  journal={Accepted at MLCAD},
  year={2024}
}

@article{hammoud2024reinforcement,
  title={Reinforcement Learning-Enhanced Cloud-Based Open Source Analog Circuit Generator for Standard and Cryogenic Temperatures in 130-nm and 180-nm OpenPDKs},
  author={Hammoud, A. and Li, A. and Tripathi, A. and Tian, W. and Khandeparkar, H. and Wans, R. and Kielian, G. and Murmann, B. and Sylvester, D. and Saligane, M.},
  journal={Accepted at ICCAD},
  year={2024}
}
```
