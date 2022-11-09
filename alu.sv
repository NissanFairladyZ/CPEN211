module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);

reg [15:0] output_reg;
assign ALU_out = output_reg;
wire [15:0] output_reg_wire;
assign output_reg_wire = output_reg;
reg Zreg;
assign Z = Zreg;


always_comb begin

case(ALU_op) //00: add, 01: subtract, 10: bitwise AND, 11: bitwise NOT
2'b00: output_reg = val_A + val_B;
2'b01: output_reg = val_A - val_B;
2'b10: output_reg = val_A & val_B;  
2'b11: output_reg = ~val_B;
endcase

case(output_reg_wire)    //Z is 1 if ALU output is all 0, else Z is 0
16'b0: Zreg = 1'b1;
default: Zreg = 1'b0;
endcase
end


 
endmodule: ALU


