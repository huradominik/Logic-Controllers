`timescale 1 ns / 1 ps
`include "mplc_logic_il.v"


module central_unit (
CLK, CLR, A, WE, OUT, RUN);

parameter IA_W = 16;
parameter ID_W = 24;
parameter DA_W = 16;
parameter DW_W = 32;

parameter IA_B = 12; // Instruction adress word
parameter ID_B = 16; // Instruction data word
parameter DA_B = 12; // Data adress word

input CLK, CLR;
input RUN;
output [4:0] A;
input [15:0] WE;
output [15:0] OUT;

// Connections for WORD CPU //
wire [IA_W-5:0] DB_A;
wire DB_I;
wire DB_O;

wire [IA_W-1:0] IW_A;
wire [ID_W-1:0] IW_D;

wire [DA_W-1:0] DW_A;
wire [DW_W-1:0] DW_I;
wire [DW_W-1:0] DW_O;


wire DB_OE, DW_OE;
wire DB_WE, DW_WE;
//wire DB_RDY, DW_RDY;
wire DW_RDY;			// cos trzeba uzaleznic od sys control
wire D_WT_1;
wire DONE_W;

// Connections for BIT CPU //
wire [IA_B-1:0] IA_1;
wire [ID_B-1:0] ID_1;
wire [DA_B-1:0] DA_1;
wire [11:0] T_I;
wire [11:0] T_O;
wire T_RD;
wire T_WR;
wire T_EN;
wire DI_1;
wire DO_1;
wire D_WE_1;
wire D_OE_1;
wire D_WT_0;
wire DONE_B;



// Connections for Image Memory //
wire DQ_IM;
wire [4:0] A_IM;

// DMA //
wire ONE;
wire [4:0] COUNT_DMA;

// Connections for System Control //
wire [1:0] STATE;
wire [4:0] COUNT_SYS;
wire START;
wire DONE_0;
wire DONE_1;
wire S_WE_1;
wire WR_IMAGE;

wire B_OUT;
wire [11:0]A_IN;

wire DW_WE_1;

assign B_OUT = (STATE[1] == 1'b1)? DQ_IM : DO_1;
assign A_IN = (STATE[1] == 1'b1)? {7'b0000000,STATE[0],COUNT_SYS[3:0]} : DA_1;
assign DW_WE_1 = (STATE[1] == 1'b1)? WR_IMAGE : D_WE_1; 

assign IN_1 = WE[COUNT_DMA[3:0]];
assign WY = OUT;

system_control SYS_CONTROL(	
.CLK(CLK),
.CLR(CLR),
.RUN(RUN),
.STATE(STATE),
.COUNT(COUNT_SYS),
.START(START),
.S_WE_1(S_WE_1),
.WR_IMAGE(WR_IMAGE),
.A_0(IA_1),
.A_1(IW_A),
.DONE_0(DONE_0),
.DONE_1(DONE_1));

de_mux DE_MUX(
.CLK(CLK),
.COUNT(COUNT_DMA[3:0]),
.WR_EN(COUNT_DMA[4] & !ONE),
.IN(OUT_1),
.OUT(OUT));

DMA_channel DMA(
.CLK(CLK),
.CLR(CLR),
.STATE(STATE[0]),
.COUNT(COUNT_DMA),
.ONE(ONE));

image_memory IMAGE_MEMORY(
.CLK(CLK),
.A_0(COUNT_DMA),
.DI_0(IN_1),
.DQ_0(OUT_1),
.WE_0(!COUNT_DMA[4] & STATE[0]),
.A_1({!STATE[1], COUNT_SYS[3:0]}),
.DI_1(DI_1),
.DQ_1(DQ_IM),
.WE_1(S_WE_1));

word_cpu CPU_WORD(
.CLK(CLK),
.CLR(CLR),
.DB_A(DB_A),
.DB_I(DB_I),
.DB_O(DB_O),
.DB_OE(DB_OE),
.DB_WE(DB_WE),
.DB_RDY(DW_WT_1), // WT
.IW_A(IW_A),
.IW_D(IW_D),
.DW_A(DW_A),
.DW_I(DW_I),
.DW_O(DW_O),
.DW_OE(DW_OE),
.DW_WE(DW_WE),
.DW_RDY(DW_RDY),
.DONE_W(DONE_1),
.STATE(STATE));  /// ?  
	
bit_cpu CPU_BIT(
.CLK(CLK),
.CLR(CLR),
.I_A(IA_1),
.I_D(ID_1),
.T_I(T_I),
.T_O(T_O),
.T_RD(T_RD),
.T_WR(T_WR),
.T_EN(T_EN),
.D_A(DA_1),
.D_I(DI_1),
.D_O(DO_1),
.D_OE(D_OE_1),
.D_WE(D_WE_1),
.D_RDY(DW_WT_0),
.DONE_B(DONE_0),
.STATE(STATE));	// WT

scheduler_fifo FIFO_MEMORY(
.CLK(CLK),
.CLR(CLR),
.RD(T_RD),
.WR(T_WR),
.EN(T_EN),
.EMPTY(),
.D_IN(T_O),
.D_OUT(T_I));


program_word_memory USER_WORD_MEM(
.CLK(CLK),
.A(IW_A), 
.WE(1'b0), 
.DI(), 
.DQ(IW_D));

program_bit_memory USER_BIT_MEM(
.CLK(CLK), 
.A(IA_1), 
.WE(1'b0), 
.DI(), 
.DQ(ID_1));

data_word_memory CPU_WORD_MEM(
.CLK(CLK),
.D_WE(DW_WE),
.A(DW_A),
.DI(DW_O),
.DQ(DW_I));


wire DW_WT_0;
wire DW_WT_1;

assign DW_RDY = !DONE_1 && START;
assign DW_WT_1 = (D_WT_1 && !DONE_1) && START;
assign DW_WT_0 = (D_WT_0 && !DONE_0) && START;


semafor_bit_memory CPU_SEM_BIT_MEM(
	.CLK(CLK), .CLR(CLR),
	.A_0(A_IN), .DI_0(B_OUT), .DQ_0(DI_1), .WE_0(DW_WE_1), .OE_0(D_OE_1), .WT_0(D_WT_0), 
	.A_1(DB_A), .DI_1(DB_O), .DQ_1(DB_I), .WE_1(DB_WE), .OE_1(DB_OE), .WT_1(D_WT_1));

	
endmodule 
