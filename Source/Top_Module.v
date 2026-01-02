module Top_Module #(
    parameter                     V_WIDTH        = 12,
    parameter [V_WIDTH-1:0]       V_INIT         = {V_WIDTH{1'b0}},
    parameter                     S_WIDTH        = 8,
    parameter [S_WIDTH-1:0]       S_INIT         = {S_WIDTH{1'b0}},
    parameter                     COUNTER_WIDTH  = 3,
    parameter [COUNTER_WIDTH-1:0] COUNTER_INIT   = {COUNTER_WIDTH{1'b0}},
    parameter                     LUT_ADDR_WIDTH = 3,
    parameter                     LUT_DATA_WIDTH = 12,
    parameter                     LUT_MEM_PATH   = "Weights.mif"
)(
    input  wire                      clk,
    input  wire                      rst,
    input  wire                      start,
    input  wire signed [V_WIDTH-1:0] Vrest,
    input  wire signed [V_WIDTH-1:0] Vth,
    input  wire                      v_rest_load,
    input  wire                      v_th_load,
    input  wire signed [S_WIDTH-1:0] input_spike,
    output wire                      spike_out,
    output wire                      valid
);

    wire       s_load;
    wire       v_load;
    wire       x_load;
    wire       v_rest_init;
    wire       v_th_init;
    wire       s_init;
    wire       v_init;
    wire       x_init;
    wire       i_init;
    wire       s_shift;
    wire       i_en;
    wire       v_sel;
    wire [1:0] a_sel;
    wire       b_sel;
    wire [1:0] alu_sel;
    wire       spike_load;
    wire       spike_init;
    wire       i_co;

    Controller ctrl (
        .clk         (clk),
        .rst         (rst),
        .start       (start),
        .i_co        (i_co),
        .spike_out   (spike_out),
        .s_load      (s_load),
        .v_load      (v_load),
        .x_load      (x_load),
        .v_rest_init (v_rest_init),
        .v_th_init   (v_th_init),
        .s_init      (s_init),
        .v_init      (v_init),
        .x_init      (x_init),
        .i_init      (i_init),
        .s_shift     (s_shift),
        .i_en        (i_en),
        .v_sel       (v_sel),
        .a_sel       (a_sel),
        .b_sel       (b_sel),
        .alu_sel     (alu_sel),
        .spike_load  (spike_load),
        .spike_init  (spike_init),
        .valid       (valid)
    );

    Datapath #(
        .V_WIDTH        (V_WIDTH),
        .S_WIDTH        (S_WIDTH),
        .COUNTER_WIDTH  (COUNTER_WIDTH),
        .LUT_ADDR_WIDTH (LUT_ADDR_WIDTH),
        .LUT_DATA_WIDTH (LUT_DATA_WIDTH),
        .LUT_MEM_PATH   (LUT_MEM_PATH)
    ) dp (
        .clk         (clk),
        .rst         (rst),
        .Vrest       (Vrest),
        .Vth         (Vth),
        .input_spike (input_spike),
        .v_rest_load (v_rest_load),
        .v_th_load   (v_th_load),
        .s_load      (s_load),
        .v_load      (v_load),
        .x_load      (x_load),
        .v_rest_init (v_rest_init),
        .v_th_init   (v_th_init),
        .s_init      (s_init),
        .v_init      (v_init),
        .x_init      (x_init),
        .i_init      (i_init),
        .s_shift     (s_shift),
        .i_en        (i_en),
        .v_sel       (v_sel),
        .a_sel       (a_sel),
        .b_sel       (b_sel),
        .alu_sel     (alu_sel),
        .spike_load  (spike_load),
        .spike_init  (spike_init),
        .spike_out   (spike_out),
        .i_co        (i_co)
    );

endmodule
