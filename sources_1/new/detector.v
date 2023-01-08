module detector(input clk, input rst_n, input fd,ld,rd,bd, output reg f, l, r, b);
parameter T = 4000000;
// parameter T = 20;
reg trigf,trigl,trigr,trigb,trigf1,trigl1,trigr1,trigb1;
reg state;
reg [21:0] cnt;
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        {trigf,trigl,trigr,trigb,state,trigf1,trigl1,trigr1,trigb1} <= 9'b000000000;
        f <= fd;
        l <= ld;
        r <= rd;
        b <= bd;
    end
    else begin
        trigf <= fd;
        trigf1 <= trigf;
        trigl <= ld;
        trigl1 <= trigl;
        trigr <= rd;
        trigr1 <= trigr;
        trigb <= bd;
        trigb1 <= trigb;
    end
end

always @(posedge clk) begin
    case(state)
        1'b0:
            if((trigf1!=trigf) || (trigl1!=trigl) || (trigr1!=trigr) || (trigb1!=trigb)) begin
                cnt <= 0;
                state <= 1'b1;
            end
        1'b1:
            if(cnt == ((T >> 1) - 1)) begin
                f <= fd;
                l <= ld;
                r <= rd;
                b <= bd;
                state <= 1'b0;
            end
            else cnt <= cnt + 1;
    endcase
end
endmodule