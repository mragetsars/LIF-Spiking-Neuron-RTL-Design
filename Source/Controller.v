module Controller (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire       i_co,
    input  wire       spike_out,
    output reg        s_load,
    output reg        v_load,
    output reg        x_load,
    output reg        v_rest_init,
    output reg        v_th_init,
    output reg        s_init,
    output reg        v_init,
    output reg        x_init,
    output reg        i_init,
    output reg        s_shift,
    output reg        i_en,
    output reg        v_sel,
    output reg  [1:0] a_sel,
    output reg        b_sel,
    output reg  [1:0] alu_sel,
    output reg        spike_load,
    output reg        spike_init,
    output reg        valid
);

    parameter IDLE   = 4'b0000,
              INIT   = 4'b0001,
              LOAD   = 4'b0010,
              CAL1   = 4'b0011,
              CAL2_1 = 4'b0100,
              CAL2_2 = 4'b0101,
              CAL3   = 4'b0110,
              CAL4   = 4'b0111,
              GET_V  = 4'b1000,
              GET_S  = 4'b1001,
              HAVE_S = 4'b1010,
              NO_S   = 4'b1011;

    reg [3:0] p_state, n_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            p_state <= IDLE;
        else
            p_state <= n_state;
    end

    always @(*) begin
        n_state = p_state;
        case (p_state)
            IDLE:   if (start)     n_state = INIT;
            INIT:   if (~start)    n_state = LOAD;
            LOAD:                  n_state = CAL1;
            CAL1:                  n_state = CAL2_1;
            CAL2_1:                n_state = CAL2_2;
            CAL2_2:                n_state = CAL3;
            CAL3:                  n_state = CAL4;
            CAL4:   if (i_co)      n_state = GET_V;
            GET_V:                 n_state = GET_S;
            GET_S:  if (spike_out) n_state = HAVE_S;
                    else           n_state = NO_S;
            HAVE_S:                n_state = IDLE;
            NO_S:                  n_state = IDLE;
        endcase
    end

    always @(*) begin

        s_load      = 0;
        v_load      = 0;
        x_load      = 0;
        v_rest_init = 0;
        v_th_init   = 0;
        s_init      = 0;
        v_init      = 0;
        x_init      = 0;
        i_init      = 0;
        s_shift     = 0;
        i_en        = 0;
        v_sel       = 1;
        a_sel       = 0;
        b_sel       = 0;
        alu_sel     = 0;
        spike_load  = 0;
        spike_init  = 0;
        valid       = 0;

        case (p_state)
            INIT: begin
                s_init      = 1;
                x_init      = 1;
                i_init      = 1;
                spike_init  = 1;
            end
            LOAD:   begin
                s_load      = 1;
            end
            CAL1:   begin
                a_sel       = 0;
                b_sel       = 0;
                alu_sel     = 1;
                x_load      = 1;
            end
            CAL2_1: begin
                a_sel       = 1;
                alu_sel     = 3;
                x_load      = 1;
            end
            CAL2_2: begin
                a_sel       = 1;
                alu_sel     = 3;
                x_load      = 1;
            end
            CAL3:   begin
                a_sel       = 1;
                b_sel       = 0;
                alu_sel     = 0;
                x_load      = 1;
            end
            CAL4:   begin
                i_en        = 1;
                a_sel       = 1;
                b_sel       = 1;
                alu_sel     = 0;
                x_load      = 1;
                s_shift     = 1;
            end
            GET_V:  begin
                v_sel       = 0;
                v_load      = 1;
            end
            GET_S:  begin
                b_sel       = 0;
                a_sel       = 2;
                alu_sel     = 2;
                spike_load  = 1;
            end
            HAVE_S: begin
                v_sel       = 1;
                v_load      = 1;
                valid       = 1;
            end
            NO_S: begin
                valid       = 1;
            end
        endcase
    end

endmodule
