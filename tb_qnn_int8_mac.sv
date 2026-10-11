
`timescale 1ns/1ps

module tb_qnn_int8_mac;

    reg clk = 0;
    reg rst = 0;
    reg en = 0;
    reg clear_acc = 0;

    reg signed [7:0] x = 0;
    reg signed [7:0] w = 0;

    wire signed [31:0] acc;
    wire valid;

    integer checks = 0;

    qnn_int8_mac dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clear_acc(clear_acc),
        .x(x),
        .w(w),
        .acc(acc),
        .valid(valid)
    );

    always #5 clk = ~clk;

    task check_result;
        input integer expected_acc;
        input expected_valid;
        begin
            @(posedge clk);
            #1;

            if (acc !== expected_acc ||
                valid !== expected_valid) begin
                $display("FAIL: acc=%0d expected=%0d", acc, expected_acc);
                $fatal(1);
            end

            checks = checks + 1;
            $display("PASS: acc=%0d valid=%b", acc, valid);
        end
    endtask

    initial begin
        $display("Starting MAC tests");

        @(negedge clk);
        rst = 1;
        check_result(0, 0);

        @(negedge clk);
        rst = 0;
        en = 1;
        x = 3;
        w = 4;
        check_result(12, 1);

        @(negedge clk);
        x = -2;
        w = 5;
        check_result(2, 1);

        @(negedge clk);
        en = 0;
        x = 10;
        w = 10;
        check_result(2, 0);

        @(negedge clk);
        clear_acc = 1;
        check_result(0, 0);

        @(negedge clk);
        clear_acc = 0;
        en = 1;
        x = -128;
        w = -128;
        check_result(16384, 1);

        @(negedge clk);
        x = 127;
        w = -128;
        check_result(128, 1);

        @(negedge clk);
        x = 127;
        w = 127;
        check_result(16257, 1);

        $display("ALL TESTS PASSED: %0d checks", checks);
        $finish;
    end

endmodule
