`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:44 11/23/2015 
// Design Name: 
// Module Name:    CPU 
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
module CPU(Out,Reset,Clk);

	parameter DATA_WIDTH = 32;
	parameter DATA_SELECT_WIDTH = 5;
	
	input Reset, Clk;
	
	output [DATA_WIDTH-1:0] Out;
	
	wire [5:0] opcode;
	wire PCWriteCond;
	wire PCWrite;
	wire RegRead;
	wire MemAddr;
	wire MemWrite;
	wire [1:0] MemtoReg;
	wire IRWrite;
	wire [1:0] BranchCond;
	wire [1:0] PCSource;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire RegWrite;
	wire [2:0] ALUSelect;
	
	Datapath
	#(DATA_WIDTH,DATA_SELECT_WIDTH)
	Data_Bus (
	.Reset(Reset),
	.Clk(Clk),
	.ALUOut(Out),
	.Out_to_Control(opcode),
	.ALUSelect(ALUSelect),
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
	.RegWrite(RegWrite)
	);
	
	Top_Control Controller (
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
	.ALUSelect(ALUSelect)
	);

endmodule
