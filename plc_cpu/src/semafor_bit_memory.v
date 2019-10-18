`timescale 1 ns / 1 ps
`include "mplc_logic_il.v"


module semafor_bit_memory(
	CLK, CLR,
	A_0, DI_0, DQ_0, WE_0, OE_0, WT_0,
	A_1, DI_1, DQ_1, WE_1, OE_1, WT_1);
	
input CLK, CLR;
input [11:0] A_0, A_1; 
input DI_0, DI_1;
output reg DQ_0, DQ_1;
input WE_0, WE_1;
input OE_0, OE_1;
output WT_0, WT_1;


reg MEM[1023:0];
reg [11:0]ADR_REG_0;
reg [11:0]ADR_REG_1;


always @(posedge CLK) begin
	ADR_REG_0 <= A_0;
	ADR_REG_1 <= A_1;
	
	if(WE_0 & (~|A_0[11:10]))
		MEM[A_0[9:0]] <= DI_0;
	if(WE_1 & (~|A_1[11:10]))
		MEM[A_1[9:0]] <= DI_1;
		
end

	
wire SEM_NON_WT_0 = (~|A_0[11:10]);
wire SEM_NON_WT_1 = (~|A_1[11:10]);


//--------------------------------------------------------
//Port 0 semaphores  // ZAPIS BIT // ODCZYT BAJT //
//--------------------------------------------------------

wire SEM_0_0_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0000);
wire SEM_0_1_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0001);
wire SEM_0_2_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0010);
wire SEM_0_3_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0011);
wire SEM_0_4_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0100);
wire SEM_0_5_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0101);
wire SEM_0_6_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0110);
wire SEM_0_7_WE = WE_0 & A_0[11] & (A_0[3:0] == 4'b0111);

wire SEM_0_0_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0000);
wire SEM_0_1_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0001);
wire SEM_0_2_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0010);
wire SEM_0_3_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0011);
wire SEM_0_4_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0100);
wire SEM_0_5_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0101);
wire SEM_0_6_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0110);
wire SEM_0_7_RD = OE_1 & A_1[11] & (A_1[3:0] == 4'b0111);

wire SEM_0_0_DQ, SEM_0_1_DQ, SEM_0_2_DQ, SEM_0_3_DQ, SEM_0_4_DQ, SEM_0_5_DQ, SEM_0_6_DQ, SEM_0_7_DQ;
wire SEM_0_0_WR, SEM_0_1_WR, SEM_0_2_WR, SEM_0_3_WR, SEM_0_4_WR, SEM_0_5_WR, SEM_0_6_WR, SEM_0_7_WR;
wire SEM_0_0_RR, SEM_0_1_RR, SEM_0_2_RR, SEM_0_3_RR, SEM_0_4_RR, SEM_0_5_RR, SEM_0_6_RR, SEM_0_7_RR;

wire WR_EN_0_0 = &(A_0[3:0] == 4'b0000);
wire WR_EN_0_1 = &(A_0[3:0] == 4'b0001);
wire WR_EN_0_2 = &(A_0[3:0] == 4'b0010);
wire WR_EN_0_3 = &(A_0[3:0] == 4'b0011);
wire WR_EN_0_4 = &(A_0[3:0] == 4'b0100);
wire WR_EN_0_5 = &(A_0[3:0] == 4'b0101);
wire WR_EN_0_6 = &(A_0[3:0] == 4'b0110);
wire WR_EN_0_7 = &(A_0[3:0] == 4'b0111);

wire RD_EN_0_0 = &(A_1[3:0] == 4'b0000);
wire RD_EN_0_1 = &(A_1[3:0] == 4'b0001);
wire RD_EN_0_2 = &(A_1[3:0] == 4'b0010);
wire RD_EN_0_3 = &(A_1[3:0] == 4'b0011);
wire RD_EN_0_4 = &(A_1[3:0] == 4'b0100);
wire RD_EN_0_5 = &(A_1[3:0] == 4'b0101);
wire RD_EN_0_6 = &(A_1[3:0] == 4'b0110);
wire RD_EN_0_7 = &(A_1[3:0] == 4'b0111);

// WPIS BIT // ODCZYT BAJT //

semafor_unit SEM_0_0(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_0_DQ),
.WR(SEM_0_0_WE), .WR_EN(WR_EN_0_0), .WR_RDY(SEM_0_0_WR), .RD(SEM_0_0_RD),
.RD_EN(RD_EN_0_0), .RD_RDY(SEM_0_0_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_1(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_1_DQ),
.WR(SEM_0_1_WE), .WR_EN(WR_EN_0_1), .WR_RDY(SEM_0_1_WR), .RD(SEM_0_1_RD),
.RD_EN(RD_EN_0_1), .RD_RDY(SEM_0_1_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_2(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_2_DQ),
.WR(SEM_0_2_WE), .WR_EN(WR_EN_0_2), .WR_RDY(SEM_0_2_WR), .RD(SEM_0_2_RD),
.RD_EN(RD_EN_0_2), .RD_RDY(SEM_0_2_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_3(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_3_DQ),
.WR(SEM_0_3_WE), .WR_EN(WR_EN_0_3), .WR_RDY(SEM_0_3_WR), .RD(SEM_0_3_RD),
.RD_EN(RD_EN_0_3), .RD_RDY(SEM_0_3_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_4(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_4_DQ),
.WR(SEM_0_4_WE), .WR_EN(WR_EN_0_4), .WR_RDY(SEM_0_4_WR), .RD(SEM_0_4_RD),
.RD_EN(RD_EN_0_4), .RD_RDY(SEM_0_4_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_5(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_5_DQ),
.WR(SEM_0_5_WE), .WR_EN(WR_EN_0_5), .WR_RDY(SEM_0_5_WR), .RD(SEM_0_5_RD),
.RD_EN(RD_EN_0_5), .RD_RDY(SEM_0_5_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_6(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_6_DQ),
.WR(SEM_0_6_WE), .WR_EN(WR_EN_0_6), .WR_RDY(SEM_0_6_WR), .RD(SEM_0_6_RD),
.RD_EN(RD_EN_0_6), .RD_RDY(SEM_0_6_RR), .REALASE(A_1[4]));

semafor_unit SEM_0_7(		   
.CLK(CLK), .CLR(CLR), .DI(DI_0), .DQ(SEM_0_7_DQ),
.WR(SEM_0_7_WE), .WR_EN(WR_EN_0_7), .WR_RDY(SEM_0_7_WR), .RD(SEM_0_7_RD),
.RD_EN(RD_EN_0_7), .RD_RDY(SEM_0_7_RR), .REALASE(A_1[4]));

//--------------------------------------------------------
//Port 1 semaphores	 // ZAPIS BAJT // ODCZYT BIT //
//--------------------------------------------------------

wire SEM_1_0_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1000);
wire SEM_1_1_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1001);
wire SEM_1_2_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1010);
wire SEM_1_3_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1011);
wire SEM_1_4_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1100);
wire SEM_1_5_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1101);
wire SEM_1_6_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1110);
wire SEM_1_7_WE = WE_1 & A_1[11] & (A_1[3:0] == 4'b1111);

wire SEM_1_0_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1000);
wire SEM_1_1_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1001);
wire SEM_1_2_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1010);
wire SEM_1_3_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1011);
wire SEM_1_4_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1100);
wire SEM_1_5_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1101);
wire SEM_1_6_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1110);
wire SEM_1_7_RD = OE_0 & A_0[11] & (A_0[3:0] == 4'b1111);

wire SEM_1_0_DQ, SEM_1_1_DQ, SEM_1_2_DQ, SEM_1_3_DQ, SEM_1_4_DQ, SEM_1_5_DQ, SEM_1_6_DQ, SEM_1_7_DQ;
wire SEM_1_0_WR, SEM_1_1_WR, SEM_1_2_WR, SEM_1_3_WR, SEM_1_4_WR, SEM_1_5_WR, SEM_1_6_WR, SEM_1_7_WR; 
wire SEM_1_0_RR, SEM_1_1_RR, SEM_1_2_RR, SEM_1_3_RR, SEM_1_4_RR, SEM_1_5_RR, SEM_1_6_RR, SEM_1_7_RR;

wire WR_EN_1_0 = &(A_1[3:0] == 4'b1000);
wire WR_EN_1_1 = &(A_1[3:0] == 4'b1001);
wire WR_EN_1_2 = &(A_1[3:0] == 4'b1010);
wire WR_EN_1_3 = &(A_1[3:0] == 4'b1011);
wire WR_EN_1_4 = &(A_1[3:0] == 4'b1100);
wire WR_EN_1_5 = &(A_1[3:0] == 4'b1101);
wire WR_EN_1_6 = &(A_1[3:0] == 4'b1110);
wire WR_EN_1_7 = &(A_1[3:0] == 4'b1111);

wire RD_EN_1_0 = &(A_0[3:0] == 4'b1000);
wire RD_EN_1_1 = &(A_0[3:0] == 4'b1001);
wire RD_EN_1_2 = &(A_0[3:0] == 4'b1010);
wire RD_EN_1_3 = &(A_0[3:0] == 4'b1011);
wire RD_EN_1_4 = &(A_0[3:0] == 4'b1100);
wire RD_EN_1_5 = &(A_0[3:0] == 4'b1101);
wire RD_EN_1_6 = &(A_0[3:0] == 4'b1110);
wire RD_EN_1_7 = &(A_0[3:0] == 4'b1111);

// WPIS BAJT // ODCZYT BIT //

semafor_unit SEM_1_0(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_0_DQ),
.WR(SEM_1_0_WE), .WR_EN(WR_EN_1_0), .WR_RDY(SEM_1_0_WR), .RD(SEM_1_0_RD),
.RD_EN(RD_EN_1_0), .RD_RDY(SEM_1_0_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_1(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_1_DQ),
.WR(SEM_1_1_WE), .WR_EN(WR_EN_1_1), .WR_RDY(SEM_1_1_WR), .RD(SEM_1_1_RD),
.RD_EN(RD_EN_1_1), .RD_RDY(SEM_1_1_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_2(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_2_DQ),
.WR(SEM_1_2_WE), .WR_EN(WR_EN_1_2), .WR_RDY(SEM_1_2_WR), .RD(SEM_1_2_RD),
.RD_EN(RD_EN_1_2), .RD_RDY(SEM_1_2_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_3(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_3_DQ),
.WR(SEM_1_3_WE), .WR_EN(WR_EN_1_3), .WR_RDY(SEM_1_3_WR), .RD(SEM_1_3_RD),
.RD_EN(RD_EN_1_3), .RD_RDY(SEM_1_3_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_4(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_4_DQ),
.WR(SEM_1_4_WE), .WR_EN(WR_EN_1_4), .WR_RDY(SEM_1_4_WR), .RD(SEM_1_4_RD),
.RD_EN(RD_EN_1_4), .RD_RDY(SEM_1_4_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_5(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_5_DQ),
.WR(SEM_1_5_WE), .WR_EN(WR_EN_1_5), .WR_RDY(SEM_1_5_WR), .RD(SEM_1_5_RD),
.RD_EN(RD_EN_1_5), .RD_RDY(SEM_1_5_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_6(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_6_DQ),
.WR(SEM_1_6_WE), .WR_EN(WR_EN_1_6), .WR_RDY(SEM_1_6_WR), .RD(SEM_1_6_RD),
.RD_EN(RD_EN_1_6), .RD_RDY(SEM_1_6_RR), .REALASE(A_0[4]));

semafor_unit SEM_1_7(		   
.CLK(CLK), .CLR(CLR), .DI(DI_1), .DQ(SEM_1_7_DQ),
.WR(SEM_1_7_WE), .WR_EN(WR_EN_1_7), .WR_RDY(SEM_1_7_WR), .RD(SEM_1_7_RD),
.RD_EN(RD_EN_1_7), .RD_RDY(SEM_1_7_RR), .REALASE(A_0[4]));



assign WT_0 = (SEM_0_0_WR | SEM_0_1_WR | SEM_0_2_WR | SEM_0_3_WR | 
SEM_0_4_WR | SEM_0_5_WR | SEM_0_6_WR | SEM_0_7_WR)  | 
(SEM_1_0_RR | SEM_1_1_RR | SEM_1_2_RR | SEM_1_3_RR | 
SEM_1_4_RR | SEM_1_5_RR | SEM_1_6_RR | SEM_1_7_RR ) 
| SEM_NON_WT_0 ;	

assign WT_1 =  (SEM_1_0_WR | SEM_1_1_WR | SEM_1_2_WR | SEM_1_3_WR | 
SEM_1_4_WR | SEM_1_5_WR | SEM_1_6_WR | SEM_1_7_WR ) | 
(SEM_0_0_RR | SEM_0_1_RR | SEM_0_2_RR | SEM_0_3_RR | 
SEM_0_4_RR | SEM_0_5_RR | SEM_0_6_RR | SEM_0_7_RR) 
| SEM_NON_WT_1 ;





wire DQ_0_M = MEM[ADR_REG_0[9:0]];
wire DQ_1_M = MEM[ADR_REG_1[9:0]];
 

always @(*) begin
	casex(ADR_REG_0)								 // odczyt bitowy	  1000 000- 0000
	12'b00xx_xxxx_xxxx: DQ_0 = DQ_0_M;
	12'b1000_000x_1000: DQ_0 = SEM_1_0_DQ;
	12'b1000_000x_1001: DQ_0 = SEM_1_1_DQ;
	12'b1000_000x_1010: DQ_0 = SEM_1_2_DQ;
	12'b1000_000x_1011: DQ_0 = SEM_1_3_DQ;
	12'b1000_000x_1100: DQ_0 = SEM_1_4_DQ;
	12'b1000_000x_1101: DQ_0 = SEM_1_5_DQ;
	12'b1000_000x_1110: DQ_0 = SEM_1_6_DQ;
	12'b1000_000x_1111: DQ_0 = SEM_1_7_DQ;
	default: DQ_0 = 1'bx;	
	endcase
end

always @(*) begin
	casex(ADR_REG_1)
	12'b00xx_xxxx_xxxx: DQ_1 = DQ_1_M;	 		// odczyt bajtowy	   1000_000-_1000
	12'b1000_000x_0000: DQ_1 = SEM_0_0_DQ;
	12'b1000_000x_0001: DQ_1 = SEM_0_1_DQ;
	12'b1000_000x_0010: DQ_1 = SEM_0_2_DQ;
	12'b1000_000x_0011: DQ_1 = SEM_0_3_DQ;
	12'b1000_000x_0100: DQ_1 = SEM_0_4_DQ;
	12'b1000_000x_0101: DQ_1 = SEM_0_5_DQ;
	12'b1000_000x_0110: DQ_1 = SEM_0_6_DQ;
	12'b1000_000x_0111: DQ_1 = SEM_0_7_DQ;
	default: DQ_1 = 1'bx;	
	endcase
end

/* synthesis translate_off */
integer i;
initial begin
	for( i = 0; i < 1024; i = i + 1)
		MEM[i] = 1'b0;
		MEM[0] = 1'b1;
		MEM[1] = 1'b1;
		MEM[2] = 1'b1;
		MEM[3] = 1'b1;
		MEM[4] = 1'b1;
		MEM[16] = 1'b0;
		MEM[17] = 1'b0;
		MEM[18] = 1'b0;
		MEM[19] = 1'b0;
		MEM[20] = 1'b0;
		MEM[21] = 1'b0;
		MEM[22] = 1'b0;
		MEM[23] = 1'b0;
		MEM[24] = 1'b0;
		MEM[25] = 1'b0;
		MEM[26] = 1'b0;
		MEM[27] = 1'b0;
		MEM[28] = 1'b0;
		MEM[29] = 1'b0;
		MEM[30] = 1'b0;
		MEM[31] = 1'b0;
		MEM[55] = 1'b0;
end
/* synthesis translate_on */
	
endmodule