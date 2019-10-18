`timescale 1 ns / 1 ps

module DMA_ch_testBench();

reg CLK,CLR;
reg [1:0]STATE;


// image memory //	
	

// DMA //					   
wire ONE; 
wire [4:0] COUNT;


//de_mux//
wire [15:0]OUT;
wire [15:0]IN;

image_memory IMA_MEM(
.CLK(CLK),
.A_0(COUNT),
.DI_0(IN_1),
.DQ_0(OUT_1),
.WE_0(!COUNT[4] & STATE[0]),
.A_1(),
.DI_1(),
.DQ_1(),
.WE_1()
);

DMA_channel DMA(
.CLK(CLK),
.CLR(CLR),					  
.STATE(STATE[0]),
.COUNT(COUNT),
.ONE(ONE)
);

de_mux D_MUX(
.CLK(CLK),
.COUNT(COUNT[3:0]),
.WR_EN(COUNT[4] & !ONE),
.IN(OUT_1),
.OUT(OUT));


reg [15:0]WE;
wire [15:0]WY;



assign IN_1 = WE[COUNT[3:0]];
assign WY = OUT;



initial begin  	
	CLK = 1'b0;
	forever #5 CLK = ~CLK;	
end

initial begin
	CLR = 1'b1;
	STATE = 2'b00;
	WE = 16'b0000111100001111;
	#17
	CLR = 1'b0;
	#70
	STATE = 2'b01;
	#180
	WE = 16'b1111111111111111;
	STATE = 2'b00;
	#20
	STATE = 2'b01;
	#180
	WE = 16'b0000000001111111;
end

endmodule	










