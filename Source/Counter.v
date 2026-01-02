module Counter #(
    parameter             WIDTH = 3,
    parameter [WIDTH-1:0] INIT  = {WIDTH{1'b0}}
)  (
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    init,
    input  wire                    en,
    output wire signed [WIDTH-1:0] out,
    output wire                    co
);

    reg [WIDTH-1:0] data;

    initial data = {WIDTH{1'b0}};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= {WIDTH{1'b0}};
        end else if (init) begin
            data <= INIT;
        end else if (en) begin
            data <= data + 1'b1;
        end
    end

    assign out = data[WIDTH-1:0];
    assign co = (data == {WIDTH{1'b1}}) ? 1'b1 : 1'b0;

endmodule
