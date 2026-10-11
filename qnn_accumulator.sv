
module qnn_accumulator (
    input  logic clk,
    input  logic rst,
    input  logic clear,
    input  logic en,
    input  logic signed [31:0] value_in,
    output logic signed [31:0] value_out
);

    always_ff @(posedge clk) begin
        if (rst || clear)
            value_out <= 32'sd0;
        else if (en)
            value_out <= value_out + value_in;
    end

endmodule
