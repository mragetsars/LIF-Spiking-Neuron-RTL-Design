module MUX_2 #(
    parameter WIDTH = 12
)(
    input  wire signed [WIDTH-1:0] in_0,
    input  wire signed [WIDTH-1:0] in_1,
    input  wire                    sel,
    output reg  signed [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            1'b0:    out = in_0;
            1'b1:    out = in_1;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule
