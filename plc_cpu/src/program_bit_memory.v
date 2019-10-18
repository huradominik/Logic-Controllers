`timescale 1 ns / 1 ps
`include "mplc_logic_il.v"


module program_bit_memory(
	CLK, 
	A, WE, DI, DQ);

parameter DW = 16;
parameter AW = 12;
parameter MEM_SIZE = (1 << AW);

input CLK;
input [AW-1:0] A;
input WE;
input [DW-1:0] DI;
output [DW-1:0] DQ;
	
reg [DW-1:0] MEM [MEM_SIZE - 1 : 0];

reg	[11:0] IA_Q; 

integer d_org;
initial begin
	for(d_org = 0; d_org < 65536; d_org = d_org + 1)
		MEM[d_org] = 16'd0;
	//ORG(12'd0);
	//WR_MEM({`I_ADD_TASK, 12'h00B});
	//WR_MEM({`I_ADD_TASK, 12'h005});
	//WR_MEM({`I_ADD_TASK, 12'hfff});
	//WR_MEM({`I_ADD_TASK, 12'h00B});
	//WR_MEM({`I_GET_TASK, 12'h00A});
	MEM[0] = {`I_LD, 12'h000};
	MEM[1] = {`I_OR, 12'h001};
	MEM[2] = {`I_AND, 12'h002};
	MEM[3] = {`I_ST, 12'h010};
	MEM[4] = {`I_LD, 12'h000};
	MEM[5] = {`I_ST, 12'h005};
	MEM[6] = {`I_LD, 12'h004};
	MEM[7] = {`I_LD, 12'h008};
	MEM[8] = {`I_ST, 12'h042};
	MEM[9] = {`I_LD, 12'h005};
	MEM[10] = {`I_OR, 12'h001};
	MEM[11] = {`I_JMP, 12'hfff};
	MEM[12] = {`I_ST, 12'h003};
	MEM[13] = {`I_GET_TASK, 12'h000};
	MEM[14] = {`I_LD, 12'h005};
	MEM[15] = {`I_ST, 12'h004};
	MEM[16] = {`I_LD, 12'h000};
	MEM[17] = {`I_ST, 12'h006};
	MEM[18] = {`I_LD, 12'h001};
	MEM[19] = {`I_ST, 12'h806};
	MEM[20] = {`I_LD, 12'h003};
	MEM[21] = {`I_ST, 12'h807};
	//WR_MEM({`I_ST, 12'h007});
	MEM[22] = {`I_LD, 12'h007};
	MEM[23] = {`I_ST, 12'h002};
	MEM[24] = {`I_LD, 12'h003};
	MEM[25] = {`I_ST, 12'h000};
	MEM[26] = {`I_LD, 12'h001};
	MEM[27] = {`I_ST, 12'h00B};
	MEM[28] = {`I_LD, 12'h818};
	MEM[29] = {`I_ST, 12'h800};
	MEM[30] = {`I_LDN, 12'h00F};
	MEM[31] = {`I_JMP, 12'hfff};
	//WR_MEM({`I_JMP, 12'hfff});

end

always @(posedge CLK) begin
	IA_Q <= A;
	if(WE) MEM[A] <= DI;
end	
	
assign DQ = MEM[A];

/*synthesis translate_off*/
integer org = 0;


task WR_MEM;
input [DW-1:0] IDD;
begin
	MEM[org] = IDD;
	org = org + 1;
end
endtask

task ORG;
input [AW-1:0] IAA;
begin
	org = IAA;
end
endtask

/*synthesis translate_on*/

endmodule