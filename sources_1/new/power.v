module power(
    input clk,
    input rst_n,
    input sw_pOFF,
    input sw_pON,
    input clutch,
    input throttle,
    input reverse,
    input [1:0] state,
    output reg power,
    output reg next_power
    );

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;//S0 NS, S1 S, S2 M
wire posReverse;
wire negReverse;
reg trig1;
reg trig2;
reg trig3;
   always @(posedge clk, negedge rst_n) begin
       if(!rst_n) {trig1,trig2,trig3} <= 3'b000;
       else begin
           trig1 <= reverse;
           trig2 <= trig1;
           trig3 <= trig2;
       end
   end
   assign posReverse = (~trig3)&trig2;
   assign negReverse = trig3&(~trig2);

   always @(posedge clk, negedge rst_n) begin
       if(!rst_n) power <= 1'b0;
       else power <= next_power;
   end

   always @(*) begin
       case(power)
           1'b0:
               if({sw_pOFF, sw_pON} == 2'b01) next_power = 1'b1;
               else next_power = 1'b0;
           1'b1:
               if({sw_pOFF, sw_pON} == 2'b10 || {sw_pOFF, sw_pON} == 2'b11) next_power = 1'b0;
               else if({sw_pOFF, sw_pON} == 2'b00 && state == S2) begin
                   if(posReverse) next_power = 1'b0;
                   else next_power = 1'b1;
                   if(negReverse) next_power = 1'b0;
                   else next_power = 1'b1;
               end
               else if({sw_pOFF, sw_pON} == 2'b00 && state == S0) begin
                   if(throttle&(~clutch)) next_power = 1'b0;
                   else next_power = 1'b1;
               end
               else next_power = 1'b1;
       endcase
   end
//     always @(power,sw_pOFF,sw_pON) begin
//         case(power)
//             1'b0:
//                 if({sw_pOFF, sw_pON} == 2'b01) next_power = 1'b1;
//                 else next_power = 1'b0;
//             1'b1:
//                 if({sw_pOFF, sw_pON} == 2'b10 || {sw_pOFF, sw_pON} == 2'b11) next_power = 1'b0;
//                 else next_power = 1'b1;
//         endcase
//     end
endmodule