`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 16:49:43
// Design Name: 
// Module Name: power_sim
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


module power_sim(
//    input clk,
//    input rst_n,
//    input sw_pOFF,
//    input sw_pON,
//    input clutch,
//    input throttle,
//    input reverse,
//    input [1:0] state,
//    output reg power,
//    output reg next_power
    );
    reg clk;
    reg rst_n;
    reg sw_pOFF;
    reg sw_pON;
    reg clutch;
    reg throttle;
    reg reverse;
    reg [1:0] state;
    wire power;
    wire next_power;
    power pow(clk, rst_n, sw_pOFF, sw_pON, clutch, throttle, reverse, state, power, next_power);
initial fork
    clk = 1'b0;
    rst_n = 1'b0;
    sw_pOFF = 1'b0;
    sw_pON = 1'b0;
    {state, clutch, throttle, reverse} = 5'b00000;
    forever #1 clk = ~clk;
    #2 rst_n = 1'b1;
    #10 sw_pON = 1'b1;
    #15 sw_pON = 1'b0;
    #50 sw_pOFF = 1'b1;
    #55 sw_pOFF = 1'b0;
    #60 sw_pON = 1'b1;
    #65 sw_pON = 1'b0;
    #100 {state, clutch, throttle, reverse} = 5'b00010;
    #120 sw_pON = 1'b1;
    #125 sw_pON = 1'b0;
    #170 {state, clutch, throttle, reverse} = 5'b10011;
    #180 $finish;
join
endmodule
