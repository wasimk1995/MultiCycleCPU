`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:27:09 11/30/2015
// Design Name:   CPU
// Module Name:   /ad/eng/users/w/a/wasimk95/Desktop/CompOrg/CPU/CPU_v1_tb.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_v1_tb;

	// Inputs
	reg Reset;
	reg Clk;

	// Outputs
	wire [31:0] Out;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.Out(Out), 
		.Reset(Reset), 
		.Clk(Clk)
	);

	initial begin
		// Initialize Inputs
		Reset = 1;
		Clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 0;
        
		// Add stimulus here

	end
	always #5 Clk = ~Clk;
      
endmodule

