
`timescale 1ns/1ps

module tb_qnn_dense_layer;

    localparam INPUTS = 3;

    reg clk = 0;
    reg rst = 0;
    reg start = 0;

    reg signed [INPUTS*8-1:0] inputs_packed;
    reg signed [INPUTS*8-1:0] weights_packed;
    reg signed [31:0] bias;

    wire busy;
    wire done;
    wire signed [31:0] result;

    qnn_dense_layer #(
        .INPUTS(INPUTS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .inputs_packed(inputs_packed),
        .weights_packed(weights_packed),
        .bias(bias),
        .busy(busy),
        .done(done),
        .result(result)
    );

    always #5 clk = ~clk;

    initial begin
        // Inputs: 2, -3, 4
        // Weights: 5, 6, -2
        // Bias: 1
        // Expected: (2*5) + (-3*6) + (4*-2) + 1 = -15

        inputs_packed = {8'h04, 8'hFD, 8'h02};
        weights_packed = {8'hFE, 8'h06, 8'h05};
        bias = 32'sd1;

        // Apply reset
        @(negedge clk);
        rst = 1'b1;

        @(negedge clk);
        rst = 1'b0;

        // Start dense-layer computation
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        // Wait for completion
        wait (done == 1'b1);
        #1;

        // Check result
        if (result !== -32'sd15) begin
            $fatal(1,
                "DENSE LAYER TEST FAILED: expected -15, got %0d",
                result);
        end

        $display(
            "DENSE LAYER TEST PASSED: result=%0d",
            result
        );

        $finish;
    end

    // Timeout protection
    initial begin
        #1000;
        $fatal(1, "DENSE LAYER TEST FAILED: timeout");
    end

endmodule
