
module qnn_int8_mac (
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic clear_acc,
    input  logic signed [7:0] x,
    input  logic signed [7:0] w,
    output logic signed [31:0] acc,
    output logic valid
);

    logic signed [15:0] product;

    assign product = $signed(x) * $signed(w);

    always_ff @(posedge clk) begin
        if (rst) begin
            acc   <= 32'sd0;
            valid <= 1'b0;
        end
        else if (clear_acc) begin
            acc   <= 32'sd0;
            valid <= 1'b0;
        end
        else begin
            valid <= 1'b0;

            if (en) begin
                acc   <= acc + {{16{product[15]}}, product};
                valid <= 1'b1;
            end
        end
    end

endmodule
