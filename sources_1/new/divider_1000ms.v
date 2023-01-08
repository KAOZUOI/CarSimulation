module divider_1000ms(input clk, input rst, output reg divided_clk);//1000ms
  reg [25:0] counter = 0;

  always @(posedge clk, negedge rst) begin
	  if (!rst) 
      divided_clk = 1'b0;
    else
      counter <= counter + 1'd1;
  end

  always @(posedge clk) begin
    if (counter == 26'd5000_0000) begin
      counter <= 0;
      divided_clk <= ~divided_clk;
    end
  end
endmodule
