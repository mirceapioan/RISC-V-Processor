`timescale 1ns / 1ps
module ALU(ALUop, ina, inb, zero, out);

input [3:0] ALUop;
input [31:0] ina, inb;
output zero;
output reg [31:0] out;

    always@(*) begin
    case(ALUop)
        
        4'b0010: out <= ina + inb; //add
        4'b0110: out <= ina - inb; //sub
        4'b0000: out <= ina & inb; //and
        4'b0001: out <= ina | inb; //or
        4'b0011: out <= ina ^ inb; //xor
        4'b0101: out <= ina >> inb; //srl
        4'b0100: out <= ina << inb; //sll
        4'b1001: out <= ina >>> inb; //sra (shiftare aritmetica)
        4'b0111: out <= (ina < inb) ? 32'b1 : 32'b0; //sltu, bltu, bgeu
        4'b1000: out <= ($signed(ina) < $signed(inb)) ? 32'b1 : 32'b0; //blt, bge
        default: out <= 32'b0; 
    endcase
  end
  
  assign zero=(out==32'b0)? 1 : 0;
  
endmodule