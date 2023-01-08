module debounce(input clk, input rst, input btn, output reg debounced_btn);
    reg [19:0] D;
    always @(posedge clk, negedge rst)
        if(~rst)
            D <= 20'b0000_0000_0000_0000_0000;
        else
            D <= {btn, D[19:1]};
    always @(D) begin
        if(D == 20'b1111_1111_1111_1111_1111)
          debounced_btn = 1'b1;
        else
          debounced_btn = 1'b0;
    end
endmodule
