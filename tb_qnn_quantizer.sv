
`timescale 1ns/1ps

module tb_qnn_quantizer;

    reg signed [31:0] value_in;
    wire signed [7:0] value_out;

    integer checks = 0;

    qnn_quantizer #(
        .SHIFT(0)
    ) dut (
        .value_in(value_in),
        .value_out(value_out)
    );

    initial begin
        $display("Starting quantizer tests");

        // Test 1: Zero input
        value_in = 0;
        #10;
        if (value_out !== 8'sd0)
            $fatal(1, "FAIL: Zero input");
        checks = checks + 1;

        // Test 2: Positive value
        value_in = 12;
        #10;
        if (value_out !== 8'sd12)
            $fatal(1, "FAIL: Positive value");
        checks = checks + 1;

        // Test 3: Negative value
        value_in = -12;
        #10;
        if (value_out !== -8'sd12)
            $fatal(1, "FAIL: Negative value");
        checks = checks + 1;

        // Test 4: Positive saturation to 127
        value_in = 1000;
        #10;
        if (value_out !== 8'sd127)
            $fatal(1, "FAIL: Positive saturation");
        checks = checks + 1;

        // Test 5: Negative saturation to -128
        value_in = -1000;
        #10;
        if (value_out !== -8'sd128)
            $fatal(1, "FAIL: Negative saturation");
        checks = checks + 1;

        // Test 6: Maximum positive INT8 boundary
        value_in = 127;
        #10;
        if (value_out !== 8'sd127)
            $fatal(1, "FAIL: Maximum positive boundary");
        checks = checks + 1;

        // Test 7: Minimum negative INT8 boundary
        value_in = -128;
        #10;
        if (value_out !== -8'sd128)
            $fatal(1, "FAIL: Minimum negative boundary");
        checks = checks + 1;

        $display("QUANTIZER TESTS PASSED: %0d checks", checks);
        $finish;
    end

    initial begin
        #100;
        $fatal(1, "FAIL: Testbench timeout");
    end

endmodule
