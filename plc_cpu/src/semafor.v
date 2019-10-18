


module semafor(CLK, DI, WR, WR_EN, RD, RD_EN, REAL, DQ, WR_RDY, RD_RDY);		
input CLK;
input DI;
input WR, WR_EN, RD, RD_EN;
input REAL;
output reg DQ;
output WR_RDY, RD_RDY;
reg MW_Q0, MW_Q1;
reg MR_Q0, MR_Q1;
reg WE_MW, WE_MR;
initial begin
	MW_Q0 <= 1'b0;
	MW_Q1 <= 1'b0;
	MR_Q0 <= 1'b0;
	MR_Q1 <= 1'b0;
end
always @(posedge CLK) begin
	if(WE_MW) begin 
		MW_Q0 <= ~MW_Q0;
		MW_Q1 <= ~MW_Q1;
		DQ <= DI;  		
	end
	if(WE_MR) begin 
		MR_Q0 <= ~MR_Q0;
		MR_Q1 <= ~MR_Q1;
	end		
end
always@(*) begin	
	WE_MW = WR & WR_RDY;
	WE_MR = REAL & RD & RD_RDY;	
end
assign WR_RDY = (MW_Q0 ~^ MR_Q1) & WR_EN;
assign RD_RDY =  (MW_Q1 ^ MR_Q0) & RD_EN;
endmodule