module ALU #(
    parameter WIDTH = 12
) (
    input  wire signed [WIDTH-1:0]   A,
    input  wire signed [WIDTH-1:0]   B,
    input  wire        [1:0]         fn_sel,
    output reg  signed [WIDTH-1:0]   X,
    output reg                       cmp_out
);

    always @(*) begin
        case (fn_sel)
            2'b00:   X = A + B;
            2'b01:   X = A - B;
            2'b10:   X = {WIDTH{cmp_out}};
            2'b11:   X = A >>> 1;
            default: X = {WIDTH{1'b0}};
        endcase
    end

    always @(*) begin
        if (fn_sel == 2'b10) begin
            cmp_out <= (B > A);
        end
    end

endmodule
