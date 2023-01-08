`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2023 04:52:05 PM
// Design Name: 
// Module Name: semi_auto_sim
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


module semi_auto_sim(
//input clk,
//input divider_1ms_clk,
//input semi_auto_enable,//enable
//input rst,

//input front_detector,
//input back_detector,
//input left_detector,
//input right_detector,

//input bu_front,
//input bu_back,
//input bu_left,
//input bu_right,

//output reg [1:0] state,
//output reg [1:0] next_state,
//output reg turn_left_signal,
//output reg turn_right_signal,
//output reg move_backward_signal,
//output reg move_forward_signal,
//output reg [9:0] count,
//output reg finishedTurn
    );
reg clk;
reg semi_auto_enable;
reg rst;
    
reg front_detector;
reg back_detector;
reg left_detector;
reg right_detector;

reg bu_front;
reg bu_back;
reg bu_left;
reg bu_right;

wire [1:0] state;
wire [1:0] next_state;
wire turn_left_signal;
wire turn_right_signal;
wire move_backward_signal;
wire move_forward_signal;
wire [9:0] count;
wire finishedTurn;

semi_auto s_a(clk, clk, semi_auto_enable, rst, front_detector, back_detector, left_detector, right_detector, bu_front, bu_back, bu_left, bu_right, state, next_state, turn_left_signal, turn_right_signal, move_backward_signal, move_forward_signal, count, finishedTurn);
initial fork
    clk <= 1'b0;
    forever #1 clk = ~clk;
    {front_detector, back_detector, left_detector, right_detector} = 4'b0000;
    {bu_front, bu_back, bu_left, bu_right} = 4'b0000;
    #1 rst = 1'b0;
    #3 rst = 1'b1;
    #1 semi_auto_enable = 1'b1;
    #5 {front_detector, back_detector, left_detector, right_detector} = 4'b0110;
    #5 {bu_front, bu_back, bu_left, bu_right} = 4'b1000;
    #6 {bu_front, bu_back, bu_left, bu_right} = 4'b0000;
    #5 {front_detector, back_detector, left_detector, right_detector} = 4'b0011;
    #100 {front_detector, back_detector, left_detector, right_detector} = 4'b1010;
    #105 {front_detector, back_detector, left_detector, right_detector} = 4'b0011;
    #100 {bu_front, bu_back, bu_left, bu_right} = 4'b0001;
    #105 {bu_front, bu_back, bu_left, bu_right} = 4'b0000;
    #150 {front_detector, back_detector, left_detector, right_detector} = 4'b0010;
    #155 {front_detector, back_detector, left_detector, right_detector} = 4'b0011;
    #155 {bu_front, bu_back, bu_left, bu_right} = 4'b1000;
    #160 {bu_front, bu_back, bu_left, bu_right} = 4'b0000;
    #200 {front_detector, back_detector, left_detector, right_detector} = 4'b0001;
    #205 {front_detector, back_detector, left_detector, right_detector} = 4'b0011;
    #205 {bu_front, bu_back, bu_left, bu_right} = 4'b0010;
    #210 {bu_front, bu_back, bu_left, bu_right} = 4'b0000;
    #250 $finish;
join
endmodule
