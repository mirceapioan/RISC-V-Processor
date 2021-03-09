`timescale 1ns / 1ps
module vreau_afara_la_zapada;
 reg clk,reset;
    wire [31:0] PC_EX;
    wire [31:0] ALU_OUT_EX;
    wire [31:0] PC_MEM;
    wire PCSrc;
    wire [31:0] DATA_MEMORY_MEM;
    wire [31:0] ALU_DATA_WB;
    wire [1:0] forwardA, forwardB;
    wire pipeline_stall;

    RISC_V simulare(clk,reset,
              PC_EX,
              ALU_OUT_EX,
              PC_MEM,
              PCSrc,
              DATA_MEMORY_MEM,
              ALU_DATA_WB,
              forwardA, forwardB,
              pipeline_stall);

    always #5 clk=~clk;
    initial begin
        #0  clk=1'b0;
            reset=1'b1;
        #10 reset=1'b0;
        #1000 $finish;
    end
endmodule
