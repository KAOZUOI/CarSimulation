module mileage_LED (
    input sys_clk,
    input [1:0] state,
    input power,
    output reg [7:0] seg_out,
    output reg [1:0] seg_en
);
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;//S0 NS, S1 S, S2 M
wire clk;
reg scan_cnt;
wire [4:0] mileage;
divider_1000ms div_1000ms(sys_clk, clk);
mileage_record m_re(clk, state, power, mileage);

always @(posedge clk) begin
    if (!power) begin
        scan_cnt <= 1'b0;
    end
    else begin
        scan_cnt <= ~scan_cnt;
    end

end
always @(scan_cnt) begin
    case(scan_cnt)
    1'b0 : seg_en = 2'b01;
    1'b1 : seg_en = 2'b10;
    endcase
end
always @ * 
    if(scan_cnt == 1'b0) begin
        case({mileage[3],mileage[2],mileage[1],mileage[0]})
            4'b0000: seg_out = 8'b1111_1100;//0
            4'b0001: seg_out = 8'b0110_0000;//1
            4'b0010: seg_out = 8'b1101_1010;//2
            4'b0011: seg_out = 8'b1111_0010;//3
            4'b0100: seg_out = 8'b0110_0110;//4
            4'b0101: seg_out = 8'b1011_1100;//5
            4'b0110: seg_out = 8'b1011_1110;//6
            4'b0111: seg_out = 8'b1110_0000;//7
            4'b1000: seg_out = 8'b1111_1110;//8
            4'b1001: seg_out = 8'b1110_0110;//9
            4'b1010: seg_out = 8'b1110_1110;//A
            4'b1011: seg_out = 8'b0011_1110;//B
            4'b1100: seg_out = 8'b1001_1100;//C
            4'b1101: seg_out = 8'b0111_1100;//D
            4'b1110: seg_out = 8'b1001_1110;//E
            4'b1111: seg_out = 8'b1000_1110;//F
            default: seg_out = 8'b1111_1111;
        endcase
    end
    else begin
        case(mileage[4])
            1'b0: seg_out = 8'b1111_1100;//0
            1'b1: seg_out = 8'b0110_0000;//1
        endcase
    end
endmodule

module mileage_record (
    input clk_1000ms,
    input [1:0] state,
    input power,
    output reg [4:0] mileage
);
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    always @(posedge clk_1000ms) begin
        if(power == 1'b1) begin
            if(state == S2)
                mileage <= mileage + 1'b1;
            else
                mileage <= mileage;
        end
        else
            mileage = 1'b0;
   end
endmodule

