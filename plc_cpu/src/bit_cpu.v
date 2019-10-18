`timescale 1 ns / 1 ps
`include "mplc_logic_il.v"


module bit_cpu(
	CLK, CLR,
	I_A, I_D,
	T_I, T_O, T_RD, T_WR, T_EN,
	D_A, D_I, D_O, D_OE, D_WE, D_RDY,
	DONE_B, STATE);

// Parametry

parameter IA_W = 12; // Instruction adress word
parameter ID_W = 16; // Instruction data word
parameter DA_W = 12; // Data adress word

input CLK, CLR;

// Instrukcje
output [IA_W-1:0] I_A;  // wejscie adresowe do pamieci uzytkownika
input [ID_W-1:0] I_D;		// dane pochodzace z pamieci uzytkownika (15:12 instrukcja 11:0 adres do pamieci data memory)

// Blok danych we/wy
output [DA_W-1:0] D_A;	// adres pamieci danych
input D_I; 				// wejscie do LU z pamieci danych
output D_O;				// wyjscie zapisu danych do pamieci
output D_OE;			// Data output enable  NIEWYKORZYSTANE ale chyba cos do pamieci
output D_WE;			// Data write enable (mozliwosc wpisu do pamieci do ST)
input D_RDY;			// sygnal zezwolenia na odczyt z pamieci (jesli 0 to STALL = 1)

input DONE_B;
input [1:0] STATE;
input [IA_W-1:0] T_I;
output [IA_W-1:0] T_O;
output T_RD;
output T_WR;
output T_EN;

//Data flow control - kontrola przeplywu danych

reg [ID_W-1:0] IR_DAT, IR_EXE;   // rejestry do przetwarzania potokowego 
wire [3:0] IR_OPC = IR_EXE[ID_W-1:ID_W-4];	// polaczenie z rejestru do LU kodu instrukcji
reg [IA_W-1:0] IP, IP_PRV;				// rejestry licznika rozkazow (obecny i poprzedni) 
reg D_OE, D_WE;			// data output enable // data write enable
reg FLUSH, FLUSH_RQ, FLUSH_DY;		// rejestry do potokowosci (do instrukcji JMP)
reg STALL;						// zatrzask (zatrzymanie programu w celu mozliwosci pobrania danej z pamieci danych)
reg JMP_EN;					// zeswolenie na skok
reg [1:0] CLR_DY;			// dwu krokowy clear

reg T_WR;
reg T_RD;
reg T_EN;
reg T_ENABLE;

// Akumlator
reg CR, CR_D, CR_EN;		//	CR_EN zezwolenie na wpisanie LU do akumlatora (rejestr)

assign D_O = CR; 			// wyjscie acc wpiete do wyjscia ktore idzie do pamieci danych
assign D_A = IR_DAT[11:0]; 	// wyjscie do adresu pamieci danych z rejestru DATA (adres bloku pamieci danych)
assign I_A = IP;			// wyjsie z licznika programu do pamieci programu (adresowe) 
assign T_O = IR_EXE[11:0];
//assign IP =

// sterowanie //
always @(posedge CLK) begin
	CLR_DY[1:0] <= {CLR_DY[0], CLR};		// rejestr przesuwny dwu bitowy;
	FLUSH_DY <= FLUSH_RQ;
	if(FLUSH)
		IR_DAT <= {`I_NOP, 12'h000};		// jesli flush to w rejestrze data nop
	else begin
		if(~STALL)
			IR_DAT <= I_D;					// jesli zatrzask = 0 to wpisuje dane z pamieci programu do rej DATA
	end										// jesli jest JMP to czyszcze 2 rejestry DATA i EXE
	if(FLUSH | STALL)
		IR_EXE <= {`I_NOP, 12'h000};		// sygnal wysoki STALL zatrzymuje tylko do rej EXE
	else
		IR_EXE <= IR_DAT;					
	if(CLR_DY[0] || (STATE != 2'b01))
		IP <= {IA_W{1'b0}};				 	// podczas clr licznik rozkazow ustawia sie na adres 0 programu uzytkownika
	else begin
		if(JMP_EN)
			IP <= IR_EXE[11:0];				// jestli jmp_en to wpisuje wartosc adresu z rejestru EXE do licznika rozkazow
		else if (T_ENABLE)
			IP  <= T_I;
		else if(STALL | FLUSH | DONE_B)
				IP <= IP;				// jesli zatrzask to wpisuje jeden adres instrukcji wczesniej 
		else
				IP <= IP +1;		
	end
	
	if(CR_EN)
		CR <= CR_D;							// przepisanie wyniku LU do akumlatora dla CR_EN wysokiego
end

always @(*) begin
	//ALU  uklad asynchroniczny
	case (IR_OPC) 				// poczaczenie z rej EXE do LU
	`I_LD:   CR_D = D_I;
	`I_LDN:  CR_D = ~D_I;
	`I_OR:   CR_D = CR | D_I;
	`I_ORN:  CR_D = CR | ~D_I;
	`I_AND:  CR_D = CR & D_I;
	`I_ANDN: CR_D = CR & ~D_I;
	default: CR_D = 1'bx;	  
	endcase
	
	CR_EN = 1'b0;
	case(IR_OPC)
		`I_LD, `I_LDN, `I_OR, `I_ORN,
		`I_AND,`I_ANDN:
		 	CR_EN = 1'b1;
	default: CR_EN = 1'b0;
	endcase
	
	// Data stage control
	D_OE = 1'b0;				
	D_WE = 1'b0;
	STALL = 1'b0;
	T_EN = 1'b0;
	T_RD = 1'b0;
	case(IR_DAT[15:12])
		`I_LD, `I_LDN, `I_OR, `I_ORN,
		`I_AND,`I_ANDN: begin
			if(~FLUSH_RQ) begin
				D_OE = 1'b1;				// data output enable  - mozliwosc pobrania zmiennej z pamieci
				STALL = ~D_RDY;
			end
		end
		`I_ST, `I_STN:
		if(~FLUSH_RQ) begin
			if(CR_EN)			  	// podczas zapisu wprowadzam jednego NOP zeby przeniesc wartosc z acc do D_O
				STALL = 1'b1;
			else begin				// nastepny rozkaz przenosi instrukcje zapisu jeszcze raz i wpisywana jest wartosc D_O do pamieci
				D_WE = 1'b1;
				STALL = ~D_RDY;
			end
		end
		`I_ADD_TASK: begin
			if(~FLUSH_RQ) STALL = ~D_RDY;
				end
		`I_GET_TASK: begin
			if(~FLUSH_RQ) begin
				T_RD = 1'b1;
				T_EN = 1'b1;
				STALL = ~D_RDY;
			end
		end
		default: begin
			STALL = 1'b0;
			D_WE = 1'b0;
			D_OE = 1'b0;
			T_RD = 1'b0;
			T_EN = 1'b0;
			end
	endcase
	
// Datflow
	


// JMP

JMP_EN = 1'b0;
case(IR_EXE[15:12])
`I_JMP:
	JMP_EN = 1'b1;
`I_JMPC:
	JMP_EN = CR;
`I_JMPCN:
JMP_EN = ~CR;
default: JMP_EN = 1'b0;
endcase

T_WR = 1'b0;
//T_EN = 1'b0;
T_ENABLE = 1'b0;


case(IR_EXE[15:12])
	`I_ADD_TASK: begin
		T_WR = 1'b1;
		T_EN = 1'b1;
	end
	`I_GET_TASK: begin
		T_ENABLE = 1'b1;
	end
	default: begin
		T_WR = 1'b0;
		//T_EN = 1'b0;
		T_ENABLE = 1'b0;
	end
	
endcase

// Pipe flushing
	
FLUSH_RQ = CLR_DY[0] | JMP_EN | T_ENABLE;
FLUSH = FLUSH_RQ | FLUSH_DY;

end						
endmodule