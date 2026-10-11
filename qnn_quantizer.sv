
module qnn_quantizer #(
    parameter SHIFT = 7
) (
    input  logic signed [31:0] value_in,
    output logic signed [7:0] value_out
);

    logic signed [31:0] scaled;

    always_comb begin
        scaled = value_in >>> SHIFT;

        if (scaled > 32'sd127)
            value_out = 8'sd127;
        else if (scaled < -32'sd128)
            value_out = -8'sd128;
        else
            value_out = scaled[7:0];
    end

endmodule
