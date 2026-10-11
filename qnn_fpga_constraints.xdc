
# ============================================================
# Quantized Neural Network Accelerator on FPGA
# Target part: xc7z020clg400-1 (Zynq-7000)
# Clock target: 100 MHz
# ============================================================

# Main clock: 10 ns period = 100 MHz
create_clock -name clk -period 10.000 [get_ports clk]

# Clock uncertainty for timing analysis
set_clock_uncertainty 0.200 [get_clocks clk]

# ============================================================
# IMPORTANT:
# This is a clock-only timing constraint.
# Add PACKAGE_PIN and IOSTANDARD assignments only after
# identifying the exact development board and its pinout.
# ============================================================
