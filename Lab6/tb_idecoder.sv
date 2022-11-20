
`timescale 1 ps/ 1 ps

module tb_idecoder(output err);



wire [2:0] opcode;
wire [1:0] ALU_op;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [1:0] shift_op;
reg [15:0] ir;
wire [2:0] r_addr;
wire [2:0] w_addr;
reg [1:0] reg_sel;

reg err_reg;
assign err = err_reg;

idecoder test_idecoder(.opcode(opcode),.ALU_op(ALU_op),.sximm5(sximm5),.sximm8(sximm8), .shift_op(shift_op), .ir(ir),.r_addr(r_addr),.w_addr(w_addr),.reg_sel(reg_sel));



initial begin

err_reg = 1'b0;    //initialize err as 1'b0

ir = 16'b1111000011110000;
reg_sel = 2'b10;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110000,16'b1111111111110000,ir[4:3],ir[10:8],ir[10:8]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b01;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110000,16'b1111111111110000,ir[4:3],ir[7:5],ir[7:5]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b00;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110000,16'b1111111111110000,ir[4:3],ir[2:0],ir[2:0]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end

#5
ir = 16'b1001100110011001;
reg_sel = 2'b10;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111111001,16'b1111111110011001,ir[4:3],ir[10:8],ir[10:8]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b01;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111111001,16'b1111111110011001,ir[4:3],ir[7:5],ir[7:5]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b00;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111111001,16'b1111111110011001,ir[4:3],ir[2:0],ir[2:0]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end

#5
ir = 16'b0101010101010101;
reg_sel = 2'b10;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110101,16'b0000000001010101,ir[4:3],ir[10:8],ir[10:8]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b01;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110101,16'b0000000001010101,ir[4:3],ir[7:5],ir[7:5]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end
#5;
reg_sel = 2'b00;
#5;
if ({opcode,ALU_op,sximm5,sximm8,shift_op,r_addr,w_addr}!={ir[15:13],ir[12:11],16'b1111111111110101,16'b0000000001010101,ir[4:3],ir[2:0],ir[2:0]}) begin
$display("Error: decoded instruction for %b with reg_sel = %b is incorrect", ir, reg_sel);
end
else begin
$display("Instruction %b with reg_sel %b decoded successfully",ir,reg_sel);
end

end

endmodule: tb_idecoder
