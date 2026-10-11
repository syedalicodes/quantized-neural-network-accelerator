
module qnn_relu #(
    parameter WIDTH = 32
) (
    input  logic signed [WIDTH-1:0] data_in,
    output logic signed [WIDTH-1:0] data_out
);

    always_comb begin
        if (data_in < 0)
            data_out = '0;
        else
            data_out = data_in;
    end

endmodule
