module tb_idecoder(output err);


wire [2:0] opcode;
wire [1:0] ALU_op;



wire [15:0] sximm5, sximm8;

wire [1:0] shift_op;

reg [15:0] ir;

wire [2:0] r_addr,w_addr;

reg [1:0] reg_sel;

reg err_reg;
assign err = err_reg;

idecoder test_idecoder(.opcode(opcode),.ALU_op(ALU_op),.sximm5(sximm5),.sximm8(sximm8), .shift_op(shift_op), .ir(ir),.r_addr(r_addr),.w_addr(W_addr),.reg_sel(reg_sel));



initial begin

err_reg = 1'b0;    //initialize err as 1'b0

reg_sel = 2'b00;

ir = 16'b1111110111111111;

$display("\Test One: ir = 16'b1111110111111111, reg_sel = 2'b00");

#1;

  assert (opcode === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");
     
  assert (ALU_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm5 === 16'b1111000011110000) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm8 === 16'b0000111100001111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (shift_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (r_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (w_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  if (opcode != 3'b111 || ALU_op != 2'b11 || sximm5 != 16'b1111000011110000 || sximm8 != 16'b0000111100001111 || shift_op != 2'b11 || r_addr != 3'b111 || w_addr != 3'b111) begin
    err_reg = 1'b1
 
  end


reg_sel = 2'b01;

ir = 16'b1111110111111111;

$display("\Test Two: ir = 16'b1111110111111111, reg_sel = 2'b01");

#1;

  assert (opcode === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");
     
  assert (ALU_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm5 === 16'b1111000011110000) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm8 === 16'b0000111100001111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (shift_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (r_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (w_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  if (opcode != 3'b111 || ALU_op != 2'b11 || sximm5 != 16'b1111000011110000 || sximm8 != 16'b0000111100001111 || shift_op != 2'b11 || r_addr != 3'b111 || w_addr != 3'b111) begin
    err_reg = 1'b1
 
  end

reg_sel = 2'b10;

ir = 16'b1111110111111111;

$display("\Test Three: ir = 16'b1111110111111111, reg_sel = 2'b10");

#1;

  assert (opcode === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");
     
  assert (ALU_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm5 === 16'b1111000011110000) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (sximm8 === 16'b0000111100001111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (shift_op === 2'b11) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (r_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  assert (w_addr === 3'b111) $display("[PASS] expected result");
  else $error ("[FAIL] wrong result");

  if (opcode != 3'b111 || ALU_op != 2'b11 || sximm5 != 16'b1111000011110000 || sximm8 != 16'b0000111100001111 || shift_op != 2'b11 || r_addr != 3'b111 || w_addr != 3'b111) begin
    err_reg = 1'b1
  end


endmodule: tb_idecoder