module divider_50ms(input clk, input rst, output reg divided_clk);
    parameter T = 5000000;
    reg [22:0] counter;

  always @(posedge clk, negedge rst) begin
    if (!rst)begin
        divided_clk <= 1'b0;
        counter <= 1'b0;
    end
    else
        if(counter == ((T >> 1) - 1))begin
            divided_clk <= ~divided_clk;
            counter <= 1'b0;
        end
        else begin
            counter <= counter + 1'd1;
        end
  end
endmodule
