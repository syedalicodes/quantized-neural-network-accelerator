
module qnn_dense_layer #(
    parameter INPUTS = 4,
    parameter INDEX_W = (INPUTS <= 2) ? 1 : $clog2(INPUTS)
) (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic signed [INPUTS*8-1:0] inputs_packed,
    input  logic signed [INPUTS*8-1:0] weights_packed,
    input  logic signed [31:0] bias,
    output logic busy,
    output logic done,
    output logic signed [31:0] result
);

    localparam [1:0] IDLE   = 2'd0,
                     MAC    = 2'd1,
                     FINISH = 2'd2;

    logic [1:0] state;
    logic [INDEX_W-1:0] index;

    logic signed [7:0] current_x;
    logic signed [7:0] current_w;
    logic signed [15:0] product;
    logic signed [31:0] sum;

    always_comb begin
        current_x = inputs_packed[index*8 +: 8];
        current_w = weights_packed[index*8 +: 8];
        product = $signed(current_x) * $signed(current_w);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state  <= IDLE;
            index  <= '0;
            sum    <= 32'sd0;
            result <= 32'sd0;
            busy   <= 1'b0;
            done   <= 1'b0;
        end
        else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        index <= '0;
                        sum   <= bias;
                        busy  <= 1'b1;
                        state <= MAC;
                    end
                end

                MAC: begin
                    sum <= sum + {{16{product[15]}}, product};

                    if (index == INPUTS-1)
                        state <= FINISH;
                    else
                        index <= index + 1'b1;
                end

                FINISH: begin
                    result <= sum;
                    done   <= 1'b1;
                    busy   <= 1'b0;
                    state  <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                end
            endcase
        end
    end

endmodule
