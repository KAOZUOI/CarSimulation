// module divider_100ns(input clk, input rst, output reg divided_clk);


module divider_100ns_sim();
    reg clk_s;
    reg rst_s;
    wire divided_clk_s;
    divider_100ns d(clk_s, rst_s, divided_clk_s);
initial fork
    clk_s = 1'b0;
    rst_s = 1'b0;
    forever #1 clk_s = ~clk_s;
    #1 rst_s = 1'b1;
join    
endmodule
