
//Logic instructions
//Low order - 
`define I_NOP	4'b0000
`define I_PUSH	4'b0001
`define I_ST	4'b0010
`define I_STN	4'b0011
`define I_JMP	4'b0100
`define I_JMPC	4'b0101
`define I_JMPCN	4'b0110
`define I_POP	4'b0111
//
`define I_LD	4'b1000
`define I_LDN	4'b1001
`define I_OR	4'b1010
`define I_ORN	4'b1011
`define I_AND	4'b1100
`define I_ANDN	4'b1101
`define I_ADD_TASK	4'b1110
`define I_GET_TASK	4'b1111


//Arithemtic instructions 6 bits

`define IA_NOP	8'b00000000
//Load - store
`define IA_LDW	8'b00000001
`define IA_STW	8'b00000010
`define IA_STB	8'b00000011
`define IA_LDB	8'b00000100
//Jumps
`define IA_JMP	8'b00000101
`define IA_JMPC	8'b00000110
`define IA_JMPCN 8'b00000111

//Arithmetic
`define IA_ADD	8'b00001000
`define IA_SUB	8'b00001001
`define IA_MUL	8'b00001010
`define IA_DIV	8'b00001011
`define IA_ALD	8'b00001100
`define IA_SLD	8'b00001101
`define IA_LDI	8'b00010000
//Stack
`define IA_PUSH	8'b00001110
`define IA_POP	8'b00001111







