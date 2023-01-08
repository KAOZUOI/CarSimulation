module signal_trans(
    input [2:0] Mode,
    input m_turn_left_signal,
    input m_turn_right_signal,
    input m_move_backward_signal,
    input m_move_forward_signal,
    input sa_turn_left_signal,
    input sa_turn_right_signal,
    input sa_move_backward_signal,
    input sa_move_forward_signal,
    output reg turn_left_signal,
    output reg turn_right_signal,
    output reg move_backward_signal,
    output reg move_forward_signal
    );
always @(*) begin
    case(Mode)
        3'b001:{turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = {m_turn_left_signal, m_turn_right_signal, m_move_backward_signal, m_move_forward_signal};
        3'b010:{turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = {sa_turn_left_signal, sa_turn_right_signal, sa_move_backward_signal, sa_move_forward_signal};
        default:{turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = 4'b0000;
    endcase
end
endmodule
