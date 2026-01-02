module MUX_3 #(
    parameter WIDTH = 12
)(
    input  wire signed [WIDTH-1:0] in_0,
    input  wire signed [WIDTH-1:0] in_1,
    input  wire signed [WIDTH-1:0] in_2,
    input  wire        [1:0]       sel,
    output reg  signed [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in_0;
            2'b01: out = in_1;
            2'b10: out = in_2;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule
