module LUT #(
    parameter ADDR_WIDTH = 3,
    parameter DATA_WIDTH = 12,
    parameter PATH       = "Weights.mif"
)(
    input  wire                         clk,
    input  wire        [ADDR_WIDTH-1:0] addr,
    output reg  signed [DATA_WIDTH-1:0] out
);

    reg signed [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    initial begin
        if (PATH != "") begin
            $readmemb(PATH, mem);
        end else begin
            mem[3'b000] = 12'sb000000000110;
            mem[3'b001] = 12'sb000000011111;
            mem[3'b010] = 12'sb000000000111;
            mem[3'b011] = 12'sb000000001100;
            mem[3'b100] = 12'sb000000010001;
            mem[3'b101] = 12'sb000000101100;
            mem[3'b110] = 12'sb000000100010;
            mem[3'b111] = 12'sb000000011100;
        end
    end

    always @(*) begin
        out <= mem[addr];
    end

endmodule