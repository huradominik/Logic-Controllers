`timescale 1 ns / 1 ps


module image_fifo(
	CLK, CLR,
	RD, WR, EN,
	EMPTY, FULL,
	D_IN, D_OUT
	);
	
	parameter M_W = 5;
	
	input CLK, CLR;
	input RD, WR, EN;
	input D_IN;
	output EMPTY;
	output FULL;
	output reg D_OUT;
	
	reg FIFO[15:0];
	reg [M_W-1:0] Count;
	reg [M_W-1:0] rdCounter, wrCounter;
	
always @(posedge CLK) begin
	if(CLR) begin
		Count = 0;
		rdCounter = 0;
		wrCounter = 0;
		D_OUT <= 0;
	end
	if(EN) begin
		if(RD == 1'b1 && Count != 0) begin
			D_OUT <= FIFO[rdCounter];
			rdCounter = rdCounter + 1;
			Count = Count - 1;
		end
	else if(WR == 1'b1 && Count < 16) begin
		FIFO[wrCounter] <= D_IN;
		wrCounter = wrCounter + 1;
		Count = Count + 1;
	end
	end
end
	
	assign EMPTY = (Count == 0)? 1'b1:1'b0;
	assign FULL = (Count == 15)? 1'b1:1'b0;
		
endmodule
	
		
	