`timescale 1ns / 1ps

module forwarding(rs1, rs2, ex_mem_rd, mem_wb_rd, ex_mem_regwrite, mem_wb_regwrite, forwardA, forwardB);

input [4:0] rs1;
input [4:0] rs2;
input [4:0] ex_mem_rd;
input [4:0] mem_wb_rd;
input ex_mem_regwrite;
input mem_wb_regwrite;
output reg [1:0] forwardA, forwardB;

always@(*) begin
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs1))
            forwardA <= 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 5'b0) &&
            !(ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs1)) && 
            (mem_wb_rd == rs1))
                forwardA <= 2'b01;
        else
            forwardA <= 2'b00;
        
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs2))
            forwardB <= 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 5'b0) && 
            !(ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs2)) &&
            (mem_wb_rd == rs2))
                forwardB <= 2'b01;
        else
            forwardB <= 2'b00;
    end
endmodule
