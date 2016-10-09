`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:21 11/20/2015 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath(ALUOut,Out_to_Control,ALUSelect,PCWriteCond,PCWrite,MemWrite,MemAddr,MemtoReg,IRWrite,BranchCond,PCSource,ALUSrcB,ALUSrcA,RegRead,RegWrite,Reset,Clk);

parameter DATA_WIDTH = 32;
parameter DATA_SELECT_WIDTH = 5;

//-------------Input Ports------------------------------
input PCWriteCond,PCWrite,MemWrite,MemAddr,IRWrite,ALUSrcA,RegRead,RegWrite;
input [1:0] PCSource,ALUSrcB,MemtoReg,BranchCond;
input [2:0] ALUSelect;
input Reset,Clk;
//-------------Output Ports-----------------------------
output [5:0] Out_to_Control;//first 6 bits of instruction to control
output [DATA_WIDTH-1:0] ALUOut;//ALUOut for testing

wire Write;
assign Write = 1'b1;

wire [DATA_WIDTH-1:0] ZE26_Out;
wire [DATA_WIDTH-1:0] ZE16_Out;
wire zero_not;
wire [DATA_WIDTH-1:0] DMem_Addr;
wire Branch_Out;
wire and_to_or_PC_Out;
wire or_to_PC_Out;
wire [DATA_WIDTH-1:0] PC_Out;
wire [DATA_WIDTH-1:0] IMem_Out;
wire [4:0] ReadReg1, ReadReg2, ReadReg3;
wire [15:0] Imm;
wire [4:0] Read2Select_Out;
wire [DATA_WIDTH-1:0] RegFile_WriteData;
wire [DATA_WIDTH-1:0] DataRead1,DataRead2;
wire [DATA_WIDTH-1:0] A_Out;
wire [DATA_WIDTH-1:0] B_Out;
wire [DATA_WIDTH-1:0] A_Select;
wire [DATA_WIDTH-1:0] B_Select;
wire [DATA_WIDTH-1:0] SE16_Out;
wire [DATA_WIDTH-1:0] ALUResult;
wire zero;
wire [DATA_WIDTH-1:0] ALUResult_Reg_Out;
wire [DATA_WIDTH-1:0] DMem_Out;
wire [DATA_WIDTH-1:0] DMem_Reg_Out;
wire [DATA_WIDTH-1:0] mux_PCSource_Out;
wire [DATA_WIDTH-1:0] SL16_Out;
wire or_ble_Out;
wire and_blt_Out;

//ShiftLeft16
assign SL16_Out = {Imm,16'h0000};

//ZeroExtend26
assign ZE26_Out = {6'b000000,ReadReg1,ReadReg2,Imm};
//ZeroExtend16
assign ZE16_Out = {16'h0000,Imm};
//SignExtend
assign SE16_Out = (Imm[15]==1)? {16'hFFFF,Imm}:{16'h0000,Imm};

assign ALUOut = ALUResult_Reg_Out;

//NOT gate to invert zero
not not_zero (zero_not,zero);
//AND gate to allow next Branch Instruction to be written to PC
and and_to_or_PC (and_to_or_PC_Out,PCWriteCond,Branch_Out);//PCWriteCond
//OR gate to allow next instruciton to be written to PC
or or_to_PC (or_to_PC_Out,PCWrite,and_to_or_PC_Out);//PCWrite
//OR gate to check ble
or or_ble (or_ble_Out,(~ALUResult[31]),zero_not);
//AND gate to check blt
and and_blt (and_blt_Out,(~ALUResult[31]),zero);

//Mux that selects the address of the memory from either Reg+Offset or Imm
assign DMem_Addr = (MemAddr == 1'b00) ? ALUResult_Reg_Out : ZE16_Out;

//Mux that selects the next instruction address
assign mux_PCSource_Out = (PCSource == 2'b00) ? ALUResult :
							(PCSource == 2'b01) ? ALUResult_Reg_Out :
							ZE26_Out;
							
//Mux that selects if branch is taken
assign Branch_Out = (BranchCond == 2'b00) ? zero_not : 
							(BranchCond == 2'b01) ? zero :
							(BranchCond == 2'b10) ? and_blt_Out :
							or_ble_Out;


//MUX_Read2_Select
assign Read2Select_Out = (RegRead == 1'b0) ? ReadReg3 : ReadReg1;

//Mux that selects which data is written to register file
assign RegFile_WriteData = (MemtoReg == 2'b00) ? ALUResult_Reg_Out :
									(MemtoReg == 2'b01) ? ZE16_Out :
									(MemtoReg == 2'b10 ) ? DMem_Reg_Out :
									SL16_Out;
									
//mux_ALUSrcA
assign A_Select = (ALUSrcA == 1'b0) ? PC_Out : A_Out;

//mux_ALUSrcB
assign B_Select = (ALUSrcB == 2'b00) ? B_Out :
						(ALUSrcB == 2'b01) ? 32'd1 :
						(ALUSrcB == 2'b10) ? SE16_Out:
						ZE16_Out;

//PC
Register PC (mux_PCSource_Out,PC_Out,or_to_PC_Out,Reset,Clk);//No Control Singal

//IMEM
IMem Instruction_Mem (PC_Out,IMem_Out);//No Control Signal

//IREG
IREG Instruction_Register(Out_to_Control,ReadReg1,ReadReg2,ReadReg3,Imm,IMem_Out,IRWrite,Reset,Clk);//IRWrite

//Register File
nbit_register_file register_file (RegFile_WriteData,DataRead1,DataRead2,ReadReg2,Read2Select_Out,ReadReg1,RegWrite,Clk);//RegWrite

//RegA
Register RegA (DataRead1,A_Out,Write,Reset,Clk);

//RegB
Register RegB (DataRead2,B_Out,Write,Reset,Clk);

//ALU
ALU alu (A_Select,B_Select,ALUSelect,ALUResult,zero);

//ALU_Result_Reg
Register ALUResult_Reg (ALUResult,ALUResult_Reg_Out,Write,Reset,Clk);

//DMEM
DMem Data_Mem (B_Out,DMem_Out,DMem_Addr,MemWrite,Clk);//MemWrite

//DMEM_Reg
Register DMem_Reg (DMem_Out,DMem_Reg_Out,Write,Reset,Clk);

endmodule
