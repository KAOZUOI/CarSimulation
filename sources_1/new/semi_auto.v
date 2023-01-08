module semi_auto (
    input clk,
    input semi_auto_enable,//enable
    input rst,

    input front_detector,
    input back_detector,
    input left_detector,
    input right_detector,

    input bu_front,
    input bu_back,
    input bu_left,
    input bu_right,
    output reg [2:0] turn_state,
    output reg [1:0] state,
    output reg [1:0] next_state,
    output reg turn_left_signal,
    output reg turn_right_signal,
    output reg move_backward_signal,
    output reg move_forward_signal
);
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;//S0 Moving, S1 Waiting, S2 Turning

//left, right, back
reg [31:0] count;
always @(posedge clk) begin
    if(semi_auto_enable)begin
        if (!rst) begin
            state <= 2'b01;
        end
        else
            state <= next_state;
    end
end

parameter T = 100000000, T_2 = 180000000;
parameter T_w = 120000000, T_w2 = 200000000;
parameter T_s = 170000000, T_s2 = 250000000;
// parameter T = 10, T_2 = 18, T_w = 12, T_w2 = 20, T_s = 17, T_s2 = 25;
always @(posedge clk) begin
    case(state)
        S0:begin
            {move_backward_signal, move_forward_signal} <= 2'b01;
            {turn_left_signal,turn_right_signal} <= 2'b00;
            turn_state <= 3'b000;
            count <= 0;
            if(front_detector == 1'b1 || (left_detector == 1'b0 || right_detector == 1'b0)) begin
                next_state <= S1;
            end
            else begin
                next_state <= S0;
            end
        end
        S1:begin
            {move_backward_signal, move_forward_signal} <= 2'b00;
            {turn_left_signal,turn_right_signal} <= 2'b00;
            turn_state <= 3'b000;
            count <= 0;
            case({bu_front, bu_back, bu_left, bu_right})
                4'b1000:begin
                    turn_state <= 3'b000;
                    next_state <= S0;
                end
                4'b0100:begin
                    turn_state <= 3'b001;
                    next_state <= S2;
                end
                4'b0010:begin
                    turn_state <= 3'b100;
                    next_state <= S2;
                end
                4'b0001:begin
                    turn_state <= 3'b010;
                    next_state <= S2;
                end
                default:begin
                    turn_state <= 3'b000;
                    next_state <= S1;
                end
            endcase
        end
        S2:begin
            case(turn_state)
                3'b100:begin
                    if((count >= T) && (count < T_w))begin
                        {turn_left_signal,turn_right_signal} <= 2'b00;
                        count <= count + 1;
                    end
                    else if((count >= T_w) && (count != T_s))begin
                        {move_backward_signal, move_forward_signal} <= 2'b01;
                        count <= count + 1;
                    end
                    else if(count == T_s)begin
                        next_state <= S0;
                    end
                    else begin
                        {turn_left_signal,turn_right_signal} <= 2'b10;
                        count <= count + 1;
                    end
                end
                3'b010:begin
                    if((count >= T) && (count < T_w))begin
                        {turn_left_signal,turn_right_signal} <= 2'b00;
                        count <= count + 1;
                    end
                    else if((count >= T_w) && (count != T_s))begin
                        {move_backward_signal, move_forward_signal} <= 2'b01;
                        count <= count + 1;
                    end
                    else if(count == T_s)begin
                        next_state <= S0;
                    end
                    else begin
                        {turn_left_signal,turn_right_signal} <= 2'b01;
                        count <= count + 1;
                    end
                end
                3'b001:begin
                    if((count >= T_2) && (count < T_w2))begin
                        {turn_left_signal,turn_right_signal} <= 2'b00;
                        count <= count + 1;
                    end
                    else if((count >= T_w2) && (count != T_s2))begin
                        {move_backward_signal, move_forward_signal} <= 2'b01;
                        count <= count + 1;
                    end
                    else if(count == T_s2)begin
                        next_state <= S0;
                    end
                    else begin
                        {turn_left_signal,turn_right_signal} <= 2'b10;
                        count <= count + 1;
                    end
                end
                default:begin
                    count <= 0;
                    next_state <= S1;
                end
            endcase
        end
    endcase
end

endmodule
