`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 12:13:53 PM
// Design Name: 
// Module Name: manual_sim
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


module manual_sim();
    // input clk,
    // input manual_enable,//enable
    
    // input clutch,
    // input throttle,
    // input brake,
    // input bu_left,
    // input bu_right,
    // input reverse,
    
    // output reg [1:0] state,
    // output reg [1:0] next_state,
    // output reg power,
    // output reg turn_left_signal,
    // output reg turn_right_signal,
    // output reg move_backward_signal,
    // output reg move_forward_signal
    reg clk;
    reg manual_enable;
    
    reg clutch;
    reg throttle;
    reg brake;
    reg bu_left;
    reg bu_right;
    reg reverse;
    
    wire [1:0] state;
    wire [1:0] next_state;
    wire turn_left_signal;
    wire turn_right_signal;
    wire move_backward_signal;
    wire move_forward_signal;
    manual man(clk, manual_enable, clutch, throttle, brake, bu_left, bu_right, reverse, state, next_state, turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal);
initial fork
    clk <= 1'b0;
    {throttle, reverse, clutch, brake} = 4'b0000;
    {bu_left, bu_right} = 2'b00;
    forever #1 clk = ~clk;
    #5 manual_enable = 1'b1;
    #10 {throttle, reverse, clutch, brake} = 4'b1010;//NS -> S
    #20 {throttle, reverse, clutch, brake} = 4'b1000;//S -> M
    #30 {throttle, reverse, clutch, brake} = 4'b0010;//M -> S
    #40 {throttle, reverse, clutch, brake} = 4'b0001;//S -> NS
    #50 {throttle, reverse, clutch, brake} = 4'b1110;//NS -> S(R)
    #60 {throttle, reverse, clutch, brake} = 4'b1100;//S -> M(R)
    #70 {bu_left, bu_right} = 2'b10;
    #80 {bu_left, bu_right} = 2'b01;
    #90 {bu_left, bu_right} = 2'b00;
    #100 {throttle, reverse, clutch, brake} = 4'b1101;
    #110 {throttle, reverse, clutch, brake} = 4'b0101;
    #120 {throttle, reverse, clutch, brake} = 4'b1000;
    #122 $finish;
join    
endmodule
