# OpAmp Design Challenge #1

Also, check out the [**📊3rd Weekly**](https://docs.google.com/presentation/d/e/2PACX-1vQwOCDO72NBn09BWiQVFil2mFRwZ__72UmFIUbe2BdGgr498ldONym0g9bURT5FMA/pub?slide=id.g369dd00d293_0_491) for more details and links to examples.

## Objectives

The goal of this challenge is to design an operational amplifier (op-amp) based on existing code. It's encouraged to use python-based design automation to optimize the design parameters such as transistor sizing and placement to achieve the desired specifications. There're no restrictions on the architecture or layout of the op-amp.

## Submission Deadline

The deadline for submitting the design is **July 11th, 2025**.

## Deliverables

Participants are required to submit a github repository containing all the necessary files for generating the layout of the op-amp and evaluating its performance.

The repository should be self-contained, including a readme file that provides clear instructions on how to run the design in a fresh Linux environment.

Please check out the provided tutorial Python Notebooks in the gLayout repository on how to set up the environment.

## Specifications

The design will be evaluated based on the following parameters under a 5pF open-loop load:

0. **Technology and Supply Voltage**: The op-amp should be built using the GF180MCU technology with a supply voltage of 1.8V.
1. **DC Gain**: The op-amp should have a voltage gain of at least 70dB.
2. **Phase Margin**: The op-amp should achieve a phase margin of at least 45 degrees.
3. **Common-Mode Rejection Ratio (CMRR)**: The op-amp should have a CMRR of at least 85 dB.
4. **Gain-Bandwidth Product (GBP)**: The op-amp should have a bandwidth of at least 1 MHz.
5. **Power Consumption**: The op-amp should consume less than 0.5 mW of power, including all the biasing components.
6. **Output Swing**: The op-amp should be able to provide a 1Vpp output swing.

It's encouraged to optimize the design for low power consumption or higher GBP while meeting the performance specifications.

## Evaluation Criteria

The following criteria will be used to benchmark the designs:

- Phase Margin (Higher is better)
- GBP (Higher is better)
- GBP divided by Power (Higher is better)
- Area (Lower is better)
