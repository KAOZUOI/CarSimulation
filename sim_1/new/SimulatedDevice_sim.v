`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 16:20:59
// Design Name: 
// Module Name: SimulatedDevice_sim
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


module SimulatedDevice_sim(
    
    );
    reg sys_clk;
    reg rx;
    wire tx;
    reg power_on;
    reg power_off;
    reg [2:0] Mode;
    reg clutch;
    reg throttle;
    reg brake;
    reg reverse;
    reg bu_left;
    reg bu_right;
    reg place_barrier_signal;
    reg destroy_barrier_signal;
    wire front_detector;
    wire back_detector;
    wire left_detector;
    wire right_detector;
    SimulatedDevice sd(sys_clk, rx, tx, power_on, power_off, Mode, clutch, throttle, brake, reverse, bu_left, bu_right, 
        place_barrier_signal, destroy_barrier_signal, front_detector, back_detector, left_detector, right_detector);
initial fork
    sys_clk <= 1'b0;
    power_on = 1'b0;
    power_off = 1'b1;
    {throttle, reverse, clutch, brake} = 4'b0000;
    forever 
        #5 sys_clk = ~sys_clk;
    #10 power_on = 1'b1;
        power_off = 1'b0;
    #15
        Mode = {1'b1, 1'b1, 1'b1};

    while ({throttle, reverse, clutch, brake} <= 4'b1111) begin
        #5 {throttle, reverse, clutch, brake} = {throttle, reverse, clutch, brake} + 1'b1;
    end
    #50 power_off = 1'b1;
join
endmodule
