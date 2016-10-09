`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:03 11/20/2015 
// Design Name: 
// Module Name:    Instruction_Register 
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
module IREG(Opcode,ReadReg1,ReadReg2,ReadReg3,Imm,Instruction,IRWrite,Reset,Clk);

//-------------Input Ports-----------------------------
input [31:0] Instruction;
input IRWrite;
input Reset,Clk;

//-------------Output Ports-----------------------------
output reg [5:0] Opcode;
output reg [4:0] ReadReg1, ReadReg2, ReadReg3;
output reg [15:0] Imm;

always@(posedge Clk)
	begin
	if(Reset)
		begin
		Opcode[5:0] <= 6'd0;
		ReadReg1[4:0] <= 5'd0;
		ReadReg2[4:0] <= 5'd0;
		ReadReg3[4:0] <= 5'd0;
		Imm[15:0] <= 16'd0;
		end
	else if (IRWrite)
		begin
		Opcode[5:0] <= Instruction[31:26];
		ReadReg1[4:0] <= Instruction[25:21];
		ReadReg2[4:0] <= Instruction[20:16];
		ReadReg3[4:0] <= Instruction[15:11];
		Imm[15:0] <= Instruction[15:0];
		end
	end
endmodule
