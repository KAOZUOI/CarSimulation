`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/05 17:15:56
// Design Name: 
// Module Name: detector_sim
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


module detector_sim();
reg clk;
reg rst_n;
reg fd,ld,rd,bd;
wire trigf,trigl,trigr,trigb;
wire trigf1,trigl1,trigr1,trigb1;
wire state;
wire f,l,r,b;

//module detector(input clk, input rst_n, input fd,ld,rd,bd, 
//output reg trigf,trigl,trigr,trigb,output reg state, output reg f, l, r, b);
detector d(clk, rst_n, fd, ld, rd, bd, trigf, trigl, trigr, trigb, trigf1,trigl1,trigr1,trigb1, state, f, l, r, b);
initial fork
    clk = 1'b0;
    rst_n = 1'b0;
    fd = 1'b0;
    ld = 1'b1;
    rd = 1'b0;
    bd = 1'b1;
    forever #1 clk = ~clk;
    #2 rst_n = 1'b1; 
    #10 fd = 1'b1;
    #15 ld = 1'b1;
    #15 rd = 1'b1;
    #15 bd = 1'b1;
    #30 fd = 1'b0;
    #30 ld = 1'b0;
    #35 rd = 1'b0;
    #60 $finish;
join
endmodule
