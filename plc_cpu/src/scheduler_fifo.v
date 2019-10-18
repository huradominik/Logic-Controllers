`timescale 1 ns / 1 ps


module scheduler_fifo(
	CLK, CLR,
	RD, WR, EN,
	EMPTY,
	D_IN, D_OUT);
	
	
parameter D_W = 12;
parameter C_W = 5; 

input CLK, CLR;
input RD, WR, EN;
input [D_W-1:0] D_IN;
output [D_W-1:0] D_OUT;
output EMPTY;




reg [C_W-1:0] Count = 0;
reg [D_W-1:0] FIFO [C_W-1:0];
reg [C_W-1:0] rdCounter = 0, wrCounter = 0;
reg [D_W-1:0] D_OUT_reg;

always @(posedge CLK)
	begin
		if(CLR)
			begin
				rdCounter = 0;
				wrCounter = 0;
				Count = 0;
			end	
		if(EN)
			begin
				if(RD == 1'b1 && Count !=0) begin
					D_OUT_reg <= FIFO[rdCounter];
					rdCounter = rdCounter + 1;
					Count = Count - 1;
				end
			else if (WR == 1'b1 && Count < 32) begin
				FIFO[wrCounter] <= D_IN;
				wrCounter = wrCounter + 1;
				Count = Count + 1;
			end
		end
	end	
/*	always @(*)
		begin
			if (rdCounter > wrCounter) begin
				Count = rdCounter - wrCounter;
			end
			if (wrCounter > rdCounter) begin
				Count = wrCounter - rdCounter;
			end
		end
*/		
assign EMPTY = (Count == 0)? 1'b1:1'b0;				
assign D_OUT = D_OUT_reg;			
			
			

endmodule
