
module qnn_top (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic en,
    input  logic clear_acc,
    input  logic signed [7:0] data_in,
    input  logic signed [7:0] weight_in,
    output logic signed [31:0] accumulator,
    output logic valid
);

    qnn_int8_mac u_mac (
        .clk(clk),
        .rst(rst),
        .en(en && start),
        .clear_acc(clear_acc),
        .x(data_in),
        .w(weight_in),
        .acc(accumulator),
        .valid(valid)
    );

endmodule
