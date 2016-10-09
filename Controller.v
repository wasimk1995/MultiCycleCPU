`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:46 11/13/2015 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
	input [5:0] opcode,
	input Clk,
	input Reset,
	output reg PCWrite,
	output reg PCWriteCond,
	output reg [1:0] BranchCond,
	output reg RegRead,
	output reg MemAddr,
	output reg MemWrite,
	output reg [1:0] MemtoReg,
	output reg IRWrite,
	output reg [1:0] PCSource,
	output reg [1:0] ALUOp,
	output reg ALUSrcA,
	output reg [1:0] ALUSrcB,
	output reg RegWrite
   );
	
	reg [4:0] state, next_state;
	 
	always@(posedge Clk)
		begin
		if(Reset)
		begin
		state <= 5'd0;
		end
		else
		begin
		state <= next_state;
		end
		end

	//always @(posedge Clk)
	always@(*)
	begin
		case (state)
			5'd0: begin
					ALUSrcA	<= 0;
					ALUSrcB	<= 2'b01;
					PCWrite 	<= 1;
					RegWrite <= 0;
					MemWrite <= 0;
					IRWrite	<= 1;					
					PCSource <= 2'b00;
					ALUOp 	<= 2'b00;
					//state 	<= 5'd1;
					next_state <= 5'd1;
					end
			5'd1: begin
					ALUSrcA	<= 0;
					ALUSrcB	<= 2'b10;
					ALUOp		<= 2'b00;
					RegRead 	<= 0;
					MemAddr	<= 1;
					PCWrite	<= 0;
					RegWrite <= 0;
					MemWrite <= 0;
					IRWrite	<= 0;
					PCWriteCond <= 0;
					if (opcode == 6'b000000)							//Noop => state 2
						begin
							next_state <= 5'd2;
						end
					else if (opcode[5:4] == 2'b01)					//R-type => state 3
						begin
							next_state <= 5'd3;
						end
					else if (opcode == 6'b000001)						//JMP => state 4
						begin
							next_state <= 5'd4;
						end
					else if (opcode[5:3] == 3'b100)						//BEQ => state 5
						begin
							next_state <= 5'd19;
						end
					else if (opcode == 6'b110010 | opcode == 6'b110011 | opcode == 6'b110111)	//I-type(SE) => state 9
						begin
							next_state <= 5'd9;
						end
					else if (opcode == 6'b110100 | opcode == 6'b110101)	//I-type(ZE) => state 10
						begin
							next_state <= 5'd10;
						end
					else if (opcode == 6'b111001) 	//LI => state 11
						begin	
							next_state <= 5'd11;
						end
					else if (opcode == 6'b111011) 	//LWI => state 18
						begin	
							next_state <= 5'd18;
						end
					else if (opcode == 6'b111100)		//SWI => state 12
						begin
							next_state <= 5'd12;
						end
					else if (opcode == 6'b111101 | opcode == 6'b111110)		//LW | SW => state 13
						begin
							next_state <= 5'd13;
						end
					end
			5'd2: begin
					next_state <= 5'd0;
					end
			5'd3:	begin
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b10;
					next_state	<= 5'd14;
					end
			5'd4:	begin
					PCSource <= 2'b10;
					PCWrite <= 1;
					next_state 	<= 4'd0;
					end
			5'd5: begin
					PCSource <= 2'b01;
					RegRead <= 1;
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b01;
					PCWriteCond <= 1;
					BranchCond <= 2'b00;
					next_state	<= 4'd0;
					end
			5'd6: begin
					PCSource <= 2'b01;
					RegRead <= 1;
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b01;
					PCWriteCond <= 1;
					BranchCond <= 2'b01;
					next_state	<= 4'd0;
					end
			5'd7:	begin
					PCSource <= 2'b01;
					RegRead <= 1;
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b01;
					PCWriteCond <= 1;
					BranchCond <= 2'b10;
					next_state		<= 4'd0;
					end
			5'd8: begin
					PCSource <= 2'b01;
					RegRead <= 1;
					ALUSrcA <= 1;
					ALUSrcB <= 2'b00;
					ALUOp <= 2'b01;
					PCWriteCond <= 1;
					BranchCond <= 2'b11;
					next_state	<= 4'd0;
					end
			5'd9: begin
					ALUSrcA <= 1;
					ALUSrcB <= 2'b10;
					ALUOp <= 2'b10;
					next_state	<= 5'd14;
					end
			5'd10: begin
					ALUSrcA	<= 1;
					ALUSrcB 	<= 2'b11;
					ALUOp		<= 2'b10;
					next_state		<= 5'd14;
					end
			5'd11: begin
					RegWrite <= 1;
					MemtoReg <= 2'b01;
					next_state		<= 5'd0;
					end
			5'd12: begin	//SWI
					RegRead <= 1;
					next_state	<= 5'd17;
					end
			5'd13: begin
					ALUSrcA <= 1;
					ALUSrcB	<= 2'b10;
					ALUOp <= 2'b00;
					RegRead <= 1;
					if (opcode == 6'b111101) begin
						next_state	<= 5'd15;
						end
					else if (opcode == 6'b111110) begin
						next_state	<= 5'd16;
						end
					end
			5'd14: begin
					RegWrite <= 1;
					MemtoReg <= 2'b00;
					next_state		<= 5'd0;
					end
			5'd15: begin
					MemAddr <= 0;
					next_state	<= 5'd18;
					end
			5'd16: begin
					MemWrite <= 1;
					MemAddr <= 0;
					next_state <= 5'd0;
					end
			5'd17: begin
					MemWrite <= 1;
					MemAddr <= 1;
					next_state	<= 5'd0;
					end
			5'd18: begin
					MemtoReg <= 2'b10;
					RegWrite <= 1;
					next_state	<= 5'd0;
					end
			5'd19: begin
					RegRead <= 1;
					if (opcode == 6'b100000)						//BEQ => state 5
						begin
							next_state <= 5'd5;
						end
					else if (opcode == 6'b100001)						//BNE => state 6
						begin
							next_state <= 5'd6;
						end
					else if (opcode == 6'b100010)						//BLT => state 7
						begin
							next_state <= 5'd7;
						end
					else if (opcode == 6'b100011)						//BLE => state 8
						begin
							next_state <= 5'd8;
						end
					end
		endcase
	end
endmodule
