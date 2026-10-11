
`timescale 1ns/1ps

module tb_qnn_top;

    reg clk = 0;
    reg rst = 0;
    reg start = 0;
    reg en = 0;
    reg clear_acc = 0;

    reg signed [7:0] data_in = 0;
    reg signed [7:0] weight_in = 0;

    wire signed [31:0] accumulator;
    wire valid;

    integer checks = 0;

    qnn_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .en(en),
        .clear_acc(clear_acc),
        .data_in(data_in),
        .weight_in(weight_in),
        .accumulator(accumulator),
        .valid(valid)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting QNN top tests");

        // Test 1: Reset
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        if (accumulator !== 32'sd0 || valid !== 1'b0)
            $fatal(1, "FAIL: Reset");
        checks = checks + 1;

        // Test 2: Clear accumulator
        @(negedge clk);
        rst = 0;
        clear_acc = 1;

        @(posedge clk);
        #1;
        if (accumulator !== 32'sd0 || valid !== 1'b0)
            $fatal(1, "FAIL: Clear");
        checks = checks + 1;

        // Test 3: Multiply 7 by -3
        @(negedge clk);
        clear_acc = 0;
        start = 1;
        en = 1;
        data_in = 7;
        weight_in = -3;

        @(posedge clk);
        #1;
        if (accumulator !== -32'sd21 || valid !== 1'b1)
            $fatal(1, "FAIL: 7 * -3");

        checks = checks + 1;

        // Test 4: Accumulate another product: 2 * 5 = 10
        // Expected total: -21 + 10 = -11
        @(negedge clk);
        data_in = 2;
        weight_in = 5;

        @(posedge clk);
        #1;
        if (accumulator !== -32'sd11 || valid !== 1'b1)
            $fatal(1, "FAIL: Accumulation");

        checks = checks + 1;

        // Test 5: Disable operation; accumulator must hold
        @(negedge clk);
        en = 0;

        @(posedge clk);
        #1;
        if (accumulator !== -32'sd11 || valid !== 1'b0)
            $fatal(1, "FAIL: Enable hold");

        checks = checks + 1;

        $display("QNN TOP TESTS PASSED: %0d checks", checks);
        $finish;
    end

    initial begin
        #200;
        $fatal(1, "FAIL: Testbench timeout");
    end

endmodule
