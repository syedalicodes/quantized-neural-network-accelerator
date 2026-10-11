# Quantized Neural Network Accelerator on FPGA

**An INT8 MAC-Based FPGA Accelerator Prototype Using SystemVerilog and Xilinx Vivado**

## Overview

This project explores the design and implementation of a quantized neural network accelerator using RTL design techniques and FPGA development tools. The goal is to investigate how fixed-point arithmetic and hardware-level optimization can support efficient neural network computation on FPGA platforms.

The current implementation includes an INT8 signed multiply-accumulate (MAC) unit, an accumulator, a ReLU activation module, an INT8 quantizer, a parameterized dense-layer module, and a controller. Individual modules are verified using self-checking SystemVerilog testbenches.

The design has been synthesized and implemented using Xilinx Vivado 2018.2 for the **Xilinx Zynq-7000 `xc7z020clg400-1` target device**.

> **Project status:** RTL module verification and FPGA implementation completed for the current MAC-based top-level design. Full neural-network integration and MNIST inference validation are in progress.

## Objectives

- Design an INT8 signed multiply-accumulate unit using SystemVerilog.
- Develop reusable arithmetic and neural-network building blocks.
- Verify individual RTL modules using self-checking testbenches.
- Synthesize and implement the current design using Xilinx Vivado.
- Evaluate FPGA resource utilization and timing.
- Extend the architecture toward a complete quantized neural network for MNIST digit classification.

## Architecture

The current top-level architecture instantiates the MAC module.

```text
Inputs: INT8 Data and Weight
             |
             v
      +--------------+
      |   qnn_top    |
      |              |
      |  +---------+ |
      |  | INT8 MAC| |
      |  +---------+ |
      |       |      |
      +-------|------+
              v
       32-bit Accumulator
              |
              v
        Valid / Result
```

Additional RTL modules have been developed separately for future integration into the complete neural-network datapath.

## RTL Modules

| Module | Description |
|---|---|
| `qnn_int8_mac.sv` | Signed INT8 multiplication and 32-bit accumulation |
| `qnn_accumulator.sv` | Enabled accumulator with reset and clear functionality |
| `qnn_relu.sv` | Rectified Linear Unit activation |
| `qnn_quantizer.sv` | Fixed-point shifting and signed INT8 saturation |
| `qnn_dense_layer.sv` | Parameterized serial dot-product computation with bias |
| `qnn_controller.sv` | Control state machine for computation sequencing |
| `qnn_top.sv` | Current top-level module integrating the MAC |

## Verification and Simulation

The project includes six self-checking SystemVerilog testbenches.

| Testbench | Verification focus | Result |
|---|---|---|
| `tb_qnn_int8_mac.sv` | Signed multiplication, accumulation, reset, clear and enable behavior | PASS — 8 checks |
| `tb_qnn_accumulator.sv` | Addition, reset, clear and enable behavior | PASS — 5 checks |
| `tb_qnn_relu.sv` | Negative, zero and positive input handling | PASS |
| `tb_qnn_quantizer.sv` | Signed shifting and INT8 saturation | PASS — 7 checks |
| `tb_qnn_dense_layer.sv` | Three-input dot product and bias computation | PASS — result −15 |
| `tb_qnn_top.sv` | Top-level MAC integration and accumulator behavior | PASS — 5 checks |

All six testbenches passed in the reported Vivado simulations. These results verify the tested behaviors of the individual modules and current top-level MAC integration; they do not yet verify complete MNIST inference.

## FPGA Implementation

**Development environment**

- HDL: SystemVerilog
- FPGA toolchain: Xilinx Vivado 2018.2
- Target device: `xc7z020clg400-1`
- Simulation: Vivado XSim
- Implementation: Synthesis, placement and routing

### Resource utilization

The reported implementation uses the following resources:

| Resource | Used | Available |
|---|---:|---:|
| Slice LUTs | 96 | 53,200 |
| Slice registers | 33 | 106,400 |
| Bonded I/O | 54 | 125 |

These figures describe the current MAC-based top-level implementation, not the complete neural-network architecture.

### Timing summary

| Metric | Reported value |
|---|---:|
| Worst Negative Slack (WNS) | +6.975 ns |
| Total Negative Slack (TNS) | 0.000 ns |
| Worst Hold Slack (WHS) | +0.088 ns |
| Failing setup endpoints | 0 |

Vivado reported that all user-specified timing constraints were met for this implementation. The reported timing is specific to the current design and its constraints.

## Repository Structure

```text
quantized-neural-network-accelerator/
├── rtl/
│   ├── qnn_int8_mac.sv
│   ├── qnn_accumulator.sv
│   ├── qnn_relu.sv
│   ├── qnn_quantizer.sv
│   ├── qnn_dense_layer.sv
│   ├── qnn_controller.sv
│   └── qnn_top.sv
├── testbench/
│   ├── tb_qnn_int8_mac.sv
│   ├── tb_qnn_accumulator.sv
│   ├── tb_qnn_relu.sv
│   ├── tb_qnn_quantizer.sv
│   ├── tb_qnn_dense_layer.sv
│   └── tb_qnn_top.sv
├── constraints/
│   └── qnn_fpga_constraints.xdc
├── reports/
│   ├── utilization.png
│   ├── timing_summary.png
│   ├── design_hierarchy.png
│   ├── device_implementation.png
│   ├── implementation_status.png
│   └── mac_waveform.png
├── README.md
└── .gitignore
```

*The structure above is the intended repository organization. Some folders or screenshots may not yet be present in the uploaded repository.*

## How to Run the Simulations

1. Open the project in Xilinx Vivado.
2. Confirm that the SystemVerilog design files are added under **Design Sources**.
3. Add the testbench files under **Simulation Sources**.
4. Select the required testbench as the simulation top.
5. Run **Run Behavioral Simulation**.
6. Check the Tcl Console for the self-checking test results.

Repeat the process for each testbench.

## Current Limitations

- The current `qnn_top` instantiates the MAC rather than the complete neural-network datapath.
- The dense layer, controller, ReLU and quantizer still require integration and end-to-end verification.
- Trained MNIST weights and biases have not yet been validated through the complete RTL inference path.
- Full-dataset classification accuracy, accelerator latency, throughput and power have not yet been measured.
- The current synthesis and timing reports do not represent the final integrated accelerator.

## Future Work

1. Integrate the controller, MAC, dense layer, activation and quantization stages.
2. Train a compact multilayer perceptron (MLP) for MNIST digit classification.
3. Quantize the trained model's weights, biases and activations consistently.
4. Export model parameters for use in the RTL design.
5. Compare RTL inference results against a software INT8 reference.
6. Evaluate MNIST classification accuracy and numerical error.
7. Re-run synthesis and implementation on the complete design.
8. Document resource utilization, timing, latency and throughput.

## Learning Outcomes

This project provides practical experience in:

- RTL design using SystemVerilog
- Signed fixed-point arithmetic
- Multiply-accumulate datapath design
- FSM-based control and hardware sequencing
- Self-checking testbench development
- FPGA synthesis, placement and routing
- Resource utilization and timing analysis
- Quantized neural-network hardware architecture

## Author

**Syed Ali U Khan**

Electronics and Communication Engineering — Microelectronic System Design

Interests: VLSI Design, RTL Design, FPGA Architecture, Digital Design Verification and Hardware Acceleration.

---

*This project is under active development. Results and documentation will be updated as the complete neural-network datapath and MNIST inference flow are implemented and verified.*
