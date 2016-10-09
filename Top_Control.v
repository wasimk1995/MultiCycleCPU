`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:43 11/13/2015 
// Design Name: 
// Module Name:    Top_Control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top_Control(
	input Clk,
	input Reset,
	input [5:0] opcode,
	output PCWriteCond,
	output PCWrite,
	output RegRead,
	output MemAddr,
	output MemWrite,
	output [1:0] MemtoReg,
	output IRWrite,
	output [1:0] BranchCond,
	output [1:0] PCSource,
	output ALUSrcA,
	output [1:0] ALUSrcB,
	output RegWrite,
	output [2:0] ALUSelect
    );

	wire [1:0] Con_to_ALUCon;
	
	Controller	Control(
		.Clk(Clk),
		.Reset(Reset),
		.opcode(opcode),
		.PCWriteCond(PCWriteCond),
		.PCWrite(PCWrite),
		.RegRead(RegRead),
		.MemAddr(MemAddr),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.IRWrite(IRWrite),
		.BranchCond(BranchCond),
		.PCSource(PCSource),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.RegWrite(RegWrite),
		.ALUOp(Con_to_ALUCon)
   );
	
	ALU_Control ALUCon(
		.ALUOp(Con_to_ALUCon),
		.opcode(opcode),
		.ALUSelect(ALUSelect)
	);

endmodule
