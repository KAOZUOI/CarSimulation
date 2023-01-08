module manual (
    input clk,
    input rst_n,
    input manual_mode,//enable,
    input power,

    input clutch,
    input throttle,
    input brake,
    input bu_left,
    input bu_right,
    input reverse,
    
    output reg [1:0] state,
    output reg [1:0] next_state,
    output reg turn_left_signal,
    output reg turn_right_signal,
    output reg move_backward_signal,
    output reg move_forward_signal
);
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;//S0 NS, S1 S, S2 M

always @(posedge clk, negedge rst_n) begin//reset
    if(!rst_n) begin
        state <= S0;
    end
    else if(manual_mode == 1'b1 && power == 1'b1) state <= next_state;
    else state <= S0;
end

always @(state, throttle, brake, clutch) begin
    case(state)
        S0:
            if({throttle, brake, clutch} == 3'b000 || {throttle, brake, clutch} == 3'b001 || {throttle, brake, clutch} == 3'b010 || {throttle, brake, clutch} == 3'b011 || {throttle, brake, clutch} == 3'b110) begin
                next_state = S0;
            end
            else if ({throttle, brake, clutch} == 3'b101 || {throttle, brake, clutch} == 3'b111) begin
                next_state = S1;
            end
            else begin
                next_state = S0;
            end
        
        S1:
            if({throttle, brake, clutch} == 3'b000 || {throttle, brake, clutch} == 3'b101 || {throttle, brake, clutch} == 3'b001 || {throttle, brake, clutch} == 3'b110)begin
                next_state = S1;
            end
            else if({throttle, brake, clutch} == 3'b100)begin
                next_state = S2;
            end
            else begin
                next_state = S0;
            end
        
        S2:
            if({throttle, brake, clutch} == 3'b000 || {throttle, brake, clutch} == 3'b001 || {throttle, brake, clutch} == 3'b110)begin
                next_state = S1;
            end
            else if({throttle, brake, clutch} == 3'b100)begin
                next_state = S2;
            end
            else begin
                next_state = S0;
            end
        
        default:
              next_state = S0; 
    endcase
end

always @(bu_left, bu_right, state) begin
    if (state == S2) begin
        turn_left_signal = bu_left;
        turn_right_signal = bu_right;
    end
    else begin
        turn_left_signal = 1'b0;
        turn_right_signal = 1'b0;
    end
end   

always @(throttle, reverse, clutch, state) begin
    if(state == S2) begin
            if (throttle && reverse) begin
                move_backward_signal = 1'b1;
                move_forward_signal = 1'b0;
            end
            else if (throttle && ~reverse) begin
                move_backward_signal = 1'b0;
                move_forward_signal = 1'b1;
            end
    end
    else begin
        move_backward_signal = 1'b0;
        move_forward_signal = 1'b0;
    end
end

endmodule
