`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/28 09:39:57
// Design Name: 
// Module Name: flash_led_top
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


module flash_turning(
    input clk,
    input rst_n,
    input left,
    input right,
    input power,
    output [1:0] led
);
    flash_led_ctrl fled_ctrl(.clk(clk),.rst_n(rst_n),.power(power),.dir({left,right}),.led(led));
endmodule

module flash_led_ctrl(
    input clk,
    input rst_n,
    input power,
    input [1:0] dir,
    output reg[1:0] led
    );
    reg [23:0] cnt;
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n)  
            cnt<=0;   
        else if(cnt<=24'd1000_0000)
            cnt<=cnt+1'd1;
        else
            cnt<=0;
    end
    always@(posedge clk, negedge rst_n)
        if(!rst_n) begin
            led <= 2'b00;
        end
        else begin
            if(power) begin
                case(dir)
                    2'b00:begin
                            led[1] <= 1'b1;
                            led[0] <= 1'b1;
                        end
                    2'b01:
                        led=(cnt<= 24'd500_0000) ? 2'b10:1'b00;
                    2'b10:
                        led=(cnt<= 24'd500_0000) ? 2'b01:1'b00;
                    2'b11:begin
                            led[1] <= 1'b1;
                            led[0] <= 1'b1;
                        end
                endcase
            end
            else begin
                led[1] <= 1'b0;
                led[0] <= 1'b0;
            end
        end
endmodule

// module counter(
// input clk,
// input rst_n,
// output clk_bps
//     );
//     reg [13:0] cnt_first,cnt_second;
//     always@(posedge clk, negedge rst_n) 
//         if(!rst_n)
//             cnt_first <= 14'd0;
//         else if (cnt_first == 14'd1000)
//             cnt_first <= 14'd0;
//         else
//             cnt_first <= cnt_first + 1'b1;
//     always@(posedge clk, negedge rst_n)
//         if(!rst_n)
//              cnt_second <= 14'd0;
//         else if (cnt_second == 14'd1000)
//              cnt_second <= 14'd0;
//         else if (cnt_first == 14'd1000)
//              cnt_second <= cnt_second + 1'b1;   
//         else 
//             cnt_second <= cnt_second;       
//     assign clk_bps = cnt_second == 14'd1000;
// endmodule