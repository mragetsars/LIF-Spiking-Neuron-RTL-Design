module Shift_Register #(
    parameter             WIDTH = 8,
    parameter [WIDTH-1:0] INIT  = {WIDTH{1'b0}}
) (
    input  wire                    clk,
    input  wire                    rst,
    input  wire signed [WIDTH-1:0] in,
    input  wire                    init,
    input  wire                    load,
    input  wire                    shift,
    output wire                    one_bit_out
);

    reg [WIDTH-1:0] data;

    initial data = {WIDTH{1'b0}};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= {WIDTH{1'b0}};
        end else if (init) begin
            data <= INIT;
        end else if (load) begin
            data <= in;
        end else if (shift) begin
            data <= {1'b0, data[WIDTH-1:1]};
        end
    end

    assign one_bit_out = data[0];

endmodule
