
`timescale 1ns/1ps

module tb_qnn_accumulator;

    reg clk = 0;
    reg rst = 0;
    reg clear = 0;
    reg en = 0;

    reg signed [31:0] value_in = 0;
    wire signed [31:0] value_out;

    integer checks = 0;

    qnn_accumulator dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .en(en),
        .value_in(value_in),
        .value_out(value_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting accumulator tests");

        // Test 1: Reset
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        if (value_out !== 32'sd0)
            $fatal(1, "FAIL: Reset");
        checks = checks + 1;

        // Test 2: Add 12
        @(negedge clk);
        rst = 0;
        en = 1;
        value_in = 12;

        @(posedge clk);
        #1;
        if (value_out !== 32'sd12)
            $fatal(1, "FAIL: Add 12");
        checks = checks + 1;

        // Test 3: Add -5; expected result = 7
        @(negedge clk);
        value_in = -5;

        @(posedge clk);
        #1;
        if (value_out !== 32'sd7)
            $fatal(1, "FAIL: Add -5");
        checks = checks + 1;

        // Test 4: Disable enable; value must hold at 7
        @(negedge clk);
        en = 0;
        value_in = 100;

        @(posedge clk);
        #1;
        if (value_out !== 32'sd7)
            $fatal(1, "FAIL: Enable hold");
        checks = checks + 1;

        // Test 5: Clear accumulator
        @(negedge clk);
        clear = 1;

        @(posedge clk);
        #1;
        if (value_out !== 32'sd0)
            $fatal(1, "FAIL: Clear");
        checks = checks + 1;

        $display("ACCUMULATOR TESTS PASSED: %0d checks", checks);
        $finish;
    end

    initial begin
        #200;
        $fatal(1, "FAIL: Testbench timeout");
    end

endmodule
