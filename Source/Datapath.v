module Datapath #(
    parameter                     V_WIDTH        = 12,
    parameter [V_WIDTH-1:0]       V_INIT         = {V_WIDTH{1'b0}},
    parameter                     S_WIDTH        = 8,
    parameter [S_WIDTH-1:0]       S_INIT         = {S_WIDTH{1'b0}},
    parameter                     COUNTER_WIDTH  = 3,
    parameter [COUNTER_WIDTH-1:0] COUNTER_INIT   = {COUNTER_WIDTH{1'b0}},
    parameter                     LUT_ADDR_WIDTH = COUNTER_WIDTH,
    parameter                     LUT_DATA_WIDTH = V_WIDTH,
    parameter                     LUT_MEM_PATH   = "Weights.mif"
) (
    input  wire                      clk,
    input  wire                      rst,
    input  wire signed [V_WIDTH-1:0] Vrest,
    input  wire signed [V_WIDTH-1:0] Vth,
    input  wire signed [S_WIDTH-1:0] input_spike,
    input  wire                      v_rest_load,
    input  wire                      v_th_load,
    input  wire                      s_load,
    input  wire                      v_load,
    input  wire                      x_load,
    input  wire                      v_rest_init,
    input  wire                      v_th_init,
    input  wire                      s_init,
    input  wire                      v_init,
    input  wire                      x_init,
    input  wire                      i_init,
    input  wire                      s_shift,
    input  wire                      i_en,
    input  wire                      v_sel,
    input  wire [1:0]                a_sel,
    input  wire                      b_sel,
    input  wire [1:0]                alu_sel,
    input  wire                      spike_load,
    input  wire                      spike_init,
    output wire                      spike_out,
    output wire                      i_co
);

    wire signed [V_WIDTH-1:0]       v_rest_out;
    wire signed [V_WIDTH-1:0]       v_th_out;
    wire signed [V_WIDTH-1:0]       v_in;
    wire signed [V_WIDTH-1:0]       v_out;
    wire signed [V_WIDTH-1:0]       x_in;
    wire signed [V_WIDTH-1:0]       x_out;
    wire signed [V_WIDTH-1:0]       a;
    wire signed [V_WIDTH-1:0]       b;
    wire signed [V_WIDTH-1:0]       w_x_s;
    wire signed [V_WIDTH-1:0]       w_i;
    wire signed [COUNTER_WIDTH-1:0] i;
    wire                            one_bit_s_out;
    wire                            spike_in;

    Register #(
        .WIDTH (V_WIDTH),
        .INIT  (V_INIT)
    ) v_rest_reg (
        .clk  (clk),
        .rst  (rst),
        .in   (Vrest),
        .init (v_rest_init),
        .load (v_rest_load),
        .out  (v_rest_out)
    );

    Register #(
        .WIDTH (V_WIDTH),
        .INIT  (V_INIT)
    ) v_th_reg (
        .clk  (clk),
        .rst  (rst),
        .in   (Vth),
        .init (v_th_init),
        .load (v_th_load),
        .out  (v_th_out)
    );

    Register #(
        .WIDTH (V_WIDTH),
        .INIT  (V_INIT)
    ) v_reg (
        .clk  (clk),
        .rst  (rst),
        .in   (v_in),
        .init (v_init),
        .load (v_load || v_rest_load),
        .out  (v_out)
    );

    Register #(
        .WIDTH (V_WIDTH),
        .INIT  (V_INIT)
    ) x_reg (
        .clk  (clk),
        .rst  (rst),
        .in   (x_in),
        .init (x_init),
        .load (x_load),
        .out  (x_out)
    );

    Shift_Register #(
        .WIDTH (S_WIDTH),
        .INIT  (S_INIT)
    ) s_shift_reg (
        .clk         (clk),
        .rst         (rst),
        .in          (input_spike),
        .init        (s_init),
        .load        (s_load),
        .shift       (s_shift),
        .one_bit_out (one_bit_s_out)
    );

    MUX_2 #(
        .WIDTH (V_WIDTH)
    ) v_select (
        .in_0 (x_out),
        .in_1 (v_rest_out),
        .sel  (v_sel),
        .out  (v_in)
    );

    MUX_2 #(
        .WIDTH (V_WIDTH)
    ) w_x_s_select (
        .in_0 (V_INIT),
        .in_1 (w_i),
        .sel  (one_bit_s_out),
        .out  (w_x_s)
    );

    MUX_2 #(
        .WIDTH (V_WIDTH)
    ) b_select (
        .in_0 (v_out),
        .in_1 (w_x_s),
        .sel  (b_sel),
        .out  (b)
    );

    MUX_3 #(
        .WIDTH (V_WIDTH)
    ) a_select (
        .in_0 (v_rest_out),
        .in_1 (x_out),
        .in_2 (v_th_out),
        .sel  (a_sel),
        .out  (a)
    );

    Counter #(
        .WIDTH (COUNTER_WIDTH),
        .INIT  (COUNTER_INIT)
    ) i_counter (
        .clk  (clk),
        .rst  (rst),
        .init (i_init),
        .en   (i_en),
        .out  (i),
        .co   (i_co)
    );

    LUT #(
        .ADDR_WIDTH (LUT_ADDR_WIDTH),
        .DATA_WIDTH (LUT_DATA_WIDTH),
        .PATH       (LUT_MEM_PATH)
    ) weights (
        .clk  (clk),
        .addr (i),
        .out  (w_i)
    );

    ALU #(
        .WIDTH (V_WIDTH)
    ) x_alu (
        .A       (a),
        .B       (b),
        .fn_sel  (alu_sel),
        .X       (x_in),
        .cmp_out (spike_out)
    );

    Register #(
        .WIDTH (1),
        .INIT  (1'b0)
    ) spike_reg (
        .clk  (clk),
        .rst  (rst),
        .in   (spike_in),
        .init (spike_init),
        .load (spike_load),
        .out  (spike_in)
    );

endmodule
