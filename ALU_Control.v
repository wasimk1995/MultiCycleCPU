`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:33 11/13/2015 
// Design Name: 
// Module Name:    ALU_Control 
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
module ALU_Control(
	input [1:0] ALUOp,
	input	[5:0] opcode,
	output reg [2:0] ALUSelect
   );

	always @(ALUOp)
	begin
		case (ALUOp)
			2'b00: ALUSelect <= 3'b010;
			2'b01: ALUSelect <= 3'b011;
			2'b10: ALUSelect <= opcode[2:0];
		endcase
	
	end

endmodule
