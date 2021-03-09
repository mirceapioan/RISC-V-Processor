`timescale 1ns / 1ps

module EX(IMM_EX, REG_DATA1_EX, REG_DATA2_EX, PC_EX,
         FUNCT3_EX,
         FUNCT7_EX,
         RD_EX,
         RS1_EX,
         RS2_EX,
         RegWrite_EX,
         MemtoReg_EX,
         MemRead_EX,
         MemWrite_EX,
         ALUop_EX,
         ALUSrc_EX,
         Branch_EX,
         forwardA, forwardB,
         ALU_DATA_WB,
         ALU_OUT_MEM,
         ZERO_EX,
         ALU_OUT_EX,
         PC_Branch_EX,
         REG_DATA2_EX_FINAL);
         
    input [31:0] IMM_EX;   
    input [31:0] REG_DATA1_EX;
    input [31:0] REG_DATA2_EX;
    input [31:0] PC_EX;
    input [2:0] FUNCT3_EX;
    input [6:0] FUNCT7_EX;
    input [4:0] RD_EX;
    input [4:0] RS1_EX;
    input [4:0] RS2_EX;
    input RegWrite_EX;
    input MemtoReg_EX;
    input MemRead_EX;
    input MemWrite_EX;
    input [1:0] ALUop_EX;
    input ALUSrc_EX;
    input Branch_EX;
    input [1:0] forwardA, forwardB;
  
    input [31:0] ALU_DATA_WB;
    input [31:0] ALU_OUT_MEM;
  
    output ZERO_EX;
    output [31:0] ALU_OUT_EX;
    output [31:0] PC_Branch_EX;
    output [31:0] REG_DATA2_EX_FINAL;

    wire [31:0] mux_dreapta, mux_sus, mux_jos;
    wire [3:0] ALUinput;

    mux2_1 MUX_2_1(mux_jos, IMM_EX, ALUSrc_EX, mux_dreapta);
    mux4_1 MUX_4_1_sus(REG_DATA1_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardA, mux_sus);
    mux4_1 MUX_4_1_jos(REG_DATA2_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardB, mux_jos);
    adder ADDER_UNIT(PC_EX, IMM_EX, PC_Branch_EX);
    ALUcontrol ALU_CONTROL_UNIT(ALUop_EX, FUNCT7_EX, FUNCT3_EX, ALUinput);
    ALU ALU_UNIT(ALUinput, mux_sus, mux_dreapta, ZERO_EX, ALU_OUT_EX);
    
    assign REG_DATA2_EX_FINAL = mux_jos;

endmodule