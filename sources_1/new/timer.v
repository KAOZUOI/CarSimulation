module timer(input clk, input rst, input power_on_in, output reg power_on);
    reg [19:0] D;
    always @(posedge clk, negedge rst) begin
        if(!rst)
            D <= 20'b0000_0000_0000_0000_0000;
        else
            D <= {power_on_in, D[19:1]};
    end
    always @(D) begin
        if(D == 20'b1111_1111_1111_1111_1111)
          power_on = 1'b1;
        else
          power_on = 1'b0;
    end
endmodule
