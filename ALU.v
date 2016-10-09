`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:19 11/20/2015 
// Design Name: 
// Module Name:    ALU 
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
module ALU(A,B,ALUOp,ALUOut,zero);
	
parameter DATA_WIDTH = 32;
parameter ALU_SELECT_WIDTH = 3;
	
//-------------Input Ports-----------------------------
input [DATA_WIDTH-1:0] A;
input [DATA_WIDTH-1:0] B;
input [ALU_SELECT_WIDTH-1:0] ALUOp;
//-------------Output Ports-----------------------------
output reg [DATA_WIDTH-1:0] ALUOut;
output reg zero;

wire [DATA_WIDTH-1:0] zero_bit;
assign zero_bit = 32'b0;

always@(A or B or ALUOp)
	begin
	zero <= (A==B)? 1'b0:1'b1;
	case(ALUOp)
		3'b000: ALUOut <= A;
		3'b001: ALUOut <= ~A;
		3'b010: ALUOut <= A+B;
		3'b011: ALUOut <= A-B;
		3'b100: ALUOut <= A|B;
		3'b101: ALUOut <= A&B;
		3'b111: if(B[DATA_WIDTH-1] == 0) begin
						if(A[DATA_WIDTH-1] == 0) begin
							ALUOut <= (A<B)? 32'd1:32'd0;
							end
						else begin
							ALUOut <= 32'd1;
							end
						end
					else begin
						if(A[DATA_WIDTH-1] == 0) begin
							ALUOut <= 32'd0;
							end
						else begin
							ALUOut <= (A>B)? 32'd1:32'd0;
							end
						end
		default: ALUOut <= zero_bit;
		endcase
	end

endmodule
