`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:32 11/22/2015 
// Design Name: 
// Module Name:    Register 
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
module Register(in,out,write,reset,clk);
	parameter DATA_WIDTH = 32;
	
	input [DATA_WIDTH-1:0] in;
	input write,reset,clk;
	output [DATA_WIDTH-1:0] out;
	
	reg [DATA_WIDTH-1:0] contents;
	
	assign out = contents;
	
	always @ (posedge clk) begin
		if(reset) begin
			contents <= 32'd0;
			end
		else if(write) begin
			contents <= in;
			end
		end
endmodule
