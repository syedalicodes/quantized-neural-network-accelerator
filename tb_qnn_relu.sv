
`timescale 1ns/1ps

module tb_qnn_relu;

    reg signed [31:0] data_in;
    wire signed [31:0] data_out;

    qnn_relu #(
        .WIDTH(32)
    ) dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        data_in = -25;
        #1;
        if (data_out !== 0)
            $fatal(1, "Negative ReLU failed");

        data_in = 0;
        #1;
        if (data_out !== 0)
            $fatal(1, "Zero ReLU failed");

        data_in = 123;
        #1;
        if (data_out !== 123)
            $fatal(1, "Positive ReLU failed");

        $display("RELU TESTS PASSED");
        $finish;
    end

endmodule
