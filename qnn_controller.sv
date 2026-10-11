
module qnn_controller (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic last,
    output logic busy,
    output logic clear_acc,
    output logic mac_en,
    output logic done
);

    localparam [1:0] IDLE     = 2'd0,
                     RUN      = 2'd1,
                     COMPLETE = 2'd2;

    logic [1:0] state;

    always_ff @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            busy      <= 1'b0;
            clear_acc <= 1'b0;
            mac_en    <= 1'b0;
            done      <= 1'b0;
        end
        else begin
            clear_acc <= 1'b0;
            mac_en    <= 1'b0;
            done      <= 1'b0;

            case (state)
                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        clear_acc <= 1'b1;
                        busy      <= 1'b1;
                        state     <= RUN;
                    end
                end

                RUN: begin
                    busy   <= 1'b1;
                    mac_en <= 1'b1;

                    if (last)
                        state <= COMPLETE;
                end

                COMPLETE: begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                end
            endcase
        end
    end

endmodule
