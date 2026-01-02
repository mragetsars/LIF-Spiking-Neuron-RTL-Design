`timescale 1ns/1ns
module tb_Top_Module;

    localparam V_WIDTH        = 12;
    localparam S_WIDTH        = 8;
    localparam COUNTER_WIDTH  = 3;
    localparam LUT_ADDR_WIDTH = 3;
    localparam LUT_DATA_WIDTH = 12;
    localparam LUT_MEM_PATH   = "Weights.mif";

    reg clk;
    reg rst;
    reg start;
    reg [S_WIDTH-1:0] input_spikes;
    reg v_rest_load;
    reg v_th_load;
    reg signed [V_WIDTH-1:0] Vth;
    reg signed [V_WIDTH-1:0] Vrest;

    wire spike_out;
    wire valid;

    Top_Module #(
        .V_WIDTH        (V_WIDTH),
        .S_WIDTH        (S_WIDTH),
        .COUNTER_WIDTH  (COUNTER_WIDTH),
        .LUT_ADDR_WIDTH (LUT_ADDR_WIDTH),
        .LUT_DATA_WIDTH (LUT_DATA_WIDTH),
        .LUT_MEM_PATH   (LUT_MEM_PATH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .input_spike(input_spikes),
        .v_rest_load(v_rest_load),
        .v_th_load(v_th_load),
        .Vth(Vth),
        .Vrest(Vrest),
        .spike_out(spike_out),
        .valid(valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start = 0;
        input_spikes = 0;
        v_th_load = 0;
        v_rest_load = 0;
        Vth = 0;
        Vrest = 0;

        #20;
        rst = 0;

        #10;
        Vth = 12'sd256;   // 000100000000
        Vrest = -12'sd26; // 111111100110
        v_th_load = 1;
        v_rest_load = 1;
        #20;
        v_th_load = 0;
        v_rest_load = 0;

        #20;
        start = 1; input_spikes = 8'b11111011; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00011010; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00010001; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00000010; #10; start = 0; #200;
        start = 1; input_spikes = 8'b01010111; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00111101; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10011100; #10; start = 0; #200;
        start = 1; input_spikes = 8'b01011110; #10; start = 0; #200;
        start = 1; input_spikes = 8'b01110000; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10101010; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10101110; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00000101; #10; start = 0; #200;
        start = 1; input_spikes = 8'b11110111; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10100111; #10; start = 0; #200;
        start = 1; input_spikes = 8'b11110000; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10100010; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10101010; #10; start = 0; #200;
        start = 1; input_spikes = 8'b10110110; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00010000; #10; start = 0; #200;
        start = 1; input_spikes = 8'b00001100; #10; start = 0; #200;

        #200;
        $stop;
    end

endmodule
