`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:10:40
// Design Name: 
// Module Name: dev_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rst_n,//bind to T5
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin

    input power_on,
    input power_off,
    input [2:0] Mode,

    input clutch,//debounce
    input throttle,
    input brake,
    input reverse,//debounce
    input bu_left,
    input bu_right,
    input bu_front,
    input bu_back,
    output [7:0] seg_out,
    output [1:0] seg_en,
    output [1:0] turning_LED,

    input place_barrier_signal,
    input destroy_barrier_signal,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector
    );
    always @(posedge clk) begin
        case(Mode)
            3'b001:begin
                {turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = {m_turn_left_signal, m_turn_right_signal, m_move_backward_signal, m_move_forward_signal};
            end
            3'b010:begin
                {turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = {sa_turn_left_signal, sa_turn_right_signal, sa_move_backward_signal, sa_move_forward_signal};
            end
            3'b100:begin
                {turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = {a_turn_left_signal, a_turn_right_signal, a_move_backward_signal, a_move_forward_signal};
            end
            default:{turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal} = 4'b0000;
        endcase
    end
    wire m_turn_left_signal, m_turn_right_signal, m_move_forward_signal, m_move_backward_signal;
    wire sa_turn_left_signal, sa_turn_right_signal, sa_move_forward_signal, sa_move_backward_signal;
    wire a_turn_left_signal, a_turn_right_signal, a_move_forward_signal, a_move_backward_signal;
    wire turn_left_signal, turn_right_signal, move_forward_signal, move_backward_signal;
    wire [7:0] in = {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal, turn_left_signal, move_backward_signal, move_forward_signal};
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign left_detector = rec[1];
    assign right_detector = rec[2];
    assign back_detector = rec[3];
    wire [1:0] state_semi,next_state_semi;
    wire [2:0] turn_state;
    wire [2:0] turn_state_auto;
    wire manual_mode;
    wire semi_auto_enable;
    wire auto_enable;
    wire power, next_power;
    assign manual_mode = (Mode[0] & (~Mode[1]) & (~Mode[2]));
    assign semi_auto_enable = ((~Mode[0]) & Mode[1] & (~Mode[2]));
    assign auto_enable = ((~Mode[0]) & (~Mode[1]) & Mode[2]);
    wire [1:0] state;//state NS = 2'b00, S = 2'b01, M = 2'b10; 
    wire [1:0] next_state;
    wire [1:0] state_auto;
    wire [1:0] next_state_auto;
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    
//     module mileage_LED (
//     input sys_clk,
//     input [1:0] state,
//     input power,
//     output [7:0] seg_out,
//     output [1:0] seg_en
// );
//    mileage_LED m_l(sys_clk, state, power, seg_out);//out

// module flash_turning(
//     input clk,
//     input rst_n,
//     input left,
//     input right,
//     input power,
//     output [1:0] led
// );
   flash_turning f_t(sys_clk, rst_n, turn_left_signal, turn_right_signal, power, turning_LED);//out
// module mileage_LED (
//     input sys_clk,
//     input [1:0] state,
//     input power,
//     output [7:0] seg_out
// );
    mileage_LED m_LED(sys_clk, state, power, seg_out, seg_en);
    //module divider_1ms(input clk, output reg divided_clk);
    //module debounce(input clk, input rst, input btn, output reg debounced_btn);
    //module timer(input clk, input power_on_in, output reg power_on);

     wire divided_clk_1ms;
     wire divided_clk_20ms;
     wire divided_clk_50ms;
     wire deb_clutch;
     wire deb_reverse;
     divider_1ms div1ms(sys_clk, rst_n, divided_clk_1ms);
     divider_20ms div20ms(sys_clk, rst_n, divided_clk_20ms);
     divider_50ms div50ms(sys_clk, rst_n, divided_clk_50ms);
     debounce deb_c(divided_clk_1ms, rst_n, clutch, deb_clutch);
     debounce deb_r(divided_clk_1ms, rst_n, reverse, deb_reverse);


    // wire divided_clk_50ms;
    // wire power_on1s;
    // divider_50ms div50ms(sys_clk, rst_n, divided_clk_50ms);
    // timer tim_pow(divided_clk_50ms, rst_n, power_on, power_on1s);

//    module power(
//        input clk,
//        input rst_n,
//        input sw_pOFF,
//        input sw_pON,
//        input clutch,
//        input throttle,
//        input reverse,
//        input [1:0] state,
//        output reg power,
//        output reg next_power
//        );
    power pow(sys_clk, rst_n, power_off, power_on, deb_clutch, throttle, deb_reverse, state, power, next_power);//pon1s
//     module manual (
//     input clk,
//     input manual_mode,
//     input power,
//     input clutch,
//     input throttle,
//     input brake,
//     input bu_left,
//     input bu_right,
//     input reverse,
//     output reg [1:0] state,
//     output reg [1:0] next_state,
//     output reg turn_left_signal,
//     output reg turn_right_signal,
//     output reg move_backward_signal,
//     output reg move_forward_signal
// );
    // manual man(sys_clk, rst_n, manual_mode, power, deb_clutch, throttle, brake, bu_left, bu_right, deb_reverse, 
    // state, next_state, m_turn_left_signal, m_turn_right_signal, m_move_backward_signal, m_move_forward_signal);
    //use
   manual man(sys_clk, rst_n, manual_mode, power, deb_clutch, throttle, brake, bu_left, bu_right, deb_reverse, 
   state, next_state, m_turn_left_signal, m_turn_right_signal, m_move_backward_signal, m_move_forward_signal);

//    wire f,b,l,r;
//    detector d(sys_clk, rst_n, rec[0], rec[1], rec[2], rec[3], f,l,r,b);
    // semi_auto s_a(sys_clk, divided_clk_1ms, semi_auto_enable, rst_n, f, b, l, r, 
    // bu_front, bu_back, bu_left, bu_right, 
    // state_semi, next_state_semi, sa_turn_left_signal, sa_turn_right_signal, sa_move_backward_signal, sa_move_forward_signal);
//    semi_auto s_a(sys_clk, divided_clk_1ms, rst_n, f, b, l, r, 
//    bu_front, bu_back, bu_left, bu_right, 
//    state_semi, next_state_semi, turn_state, turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal);
    semi_auto s_a(sys_clk, divided_clk_1ms,semi_auto_enable, rst_n, rec[0], rec[3], rec[1], rec[2], 
     bu_front, bu_back, bu_left, bu_right, 
     state_semi, next_state_semi, turn_state, sa_turn_left_signal, sa_turn_right_signal, sa_move_backward_signal, sa_move_forward_signal);
    // signal_trans s_t(Mode, m_turn_left_signal, m_turn_right_signal, m_move_backward_signal, m_move_forward_signal, 
    // sa_turn_left_signal, sa_turn_right_signal, sa_move_backward_signal, sa_move_forward_signal, 
    // turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal);
//module auto (
//        input clk,
//        input auto_enable,//enable
//        input rst,
    
//        input front_detector,
//        input back_detector,
//        input left_detector,
//        input right_detector,
    
//        output reg [2:0]turn_state,
//        output reg [1:0] state,
//        output reg [1:0] next_state,
//        output reg turn_left_signal,
//        output reg turn_right_signal,
//        output reg move_backward_signal,
//        output reg move_forward_signal
//    );
    auto at(divided_clk_20ms, auto_enable, rst_n, rec[0], rec[3], rec[1], rec[2], 
    turn_state_auto, state_auto, next_state_auto, 
    a_turn_left_signal, a_turn_right_signal, a_move_backward_signal, a_move_forward_signal);
endmodule