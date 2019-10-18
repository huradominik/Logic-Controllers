

module system_control(
	CLK,CLR,
	RUN,
	STATE, COUNT,
	START, S_WE_1,
	WR_IMAGE,
	A_0,
	A_1,
	DONE_0,
	DONE_1
	); 
	
parameter INIT = 2'b11;	// tylko raz
parameter IN = 2'b10;
parameter OUT = 2'b00;
parameter PROG = 2'b01;
	
parameter BIP_W = 12;	
parameter WIP_W = 16;	
	
input CLK,CLR;
input RUN;


input [BIP_W-1:0] A_0;
input [WIP_W-1:0] A_1;

output [1:0]STATE;
output reg [4:0]COUNT;
output reg START;
output DONE_0;
output DONE_1;
output reg S_WE_1;
output reg WR_IMAGE;
reg [1:0] state;


//reg CHANGE;

assign DONE_0 = (A_0 == 12'hfff); //&& CHANGE;
assign DONE_1 = (A_1 == 16'hffff);// && CHANGE;
assign STATE = state;
assign END_CYCLE = DONE_0 & DONE_1;	

always @(posedge CLK) begin
	if(CLR) begin
		state <= INIT;
		COUNT <= 5'd0;
		START <= 1'b0;
		S_WE_1 <= 1'b0;
		WR_IMAGE <= 1'b0;
		//CHANGE <= 1'b1;
	end
else begin
	if(RUN)	begin
		case(state)
		INIT: if(COUNT == 5'b11111) begin
			state <= IN;
			COUNT <= 5'd0;
			WR_IMAGE <= 1'b1;
		end
		else begin
			COUNT <= COUNT + 1'b1;
		end	
		IN: if(COUNT[3:0] == 4'b1111) begin
				state <= PROG;
				START <= 1'b1;
				COUNT <= 5'd0;
				WR_IMAGE <= 1'b0;
			end
		else begin
			if(COUNT[3:0] != 4'b1111)
				COUNT <= COUNT + 1;
				START <= 1'b0;
				WR_IMAGE <= 1'b1;
			end
		PROG: if(END_CYCLE) begin
				state <= OUT;
				START <= 1'b0;
				//CHANGE <= 1'b1;
				
		end
		OUT: if(COUNT[3:0] == 4'b1111) begin
			state <= IN;
			COUNT <= 5'd0;
			START <= 1'b0;
			S_WE_1 <= 1'b0;
			//CHANGE <= 1'b0;
		end
		else begin
			if(COUNT[3:0] != 4'b1111)
			COUNT <= COUNT + 1;
			START <= 1'b0;
			S_WE_1 <= 1'b1;
			//CHANGE <= 1'b1;
			
		end
		
		default: begin
			state <= INIT;
			COUNT <= 5'd0;
		end	
		endcase
	end
	end
end
		

endmodule