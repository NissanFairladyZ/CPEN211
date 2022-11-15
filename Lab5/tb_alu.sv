`timescale 1 ps / 1 ps

module tb_ALU(output err);
  reg [15:0] val_A;
  reg [15:0] val_B;
  reg [1:0] ALU_op;
  wire [15:0] ALU_out;
  wire Z;

reg err_reg;
assign err = err_reg;

ALU test_alu (.val_A(val_A),
	      .val_B(val_B),
	      .ALU_op(ALU_op),
	      .ALU_out(ALU_out),
	      .Z(Z));

initial begin
err_reg = 1'b0;    //initialize err as 1'b0
val_A = 16'b0000000000001001;
val_B = 16'b0000000000001001;
ALU_op = 2'b00;
#1;
if(ALU_out != (val_A + val_B)) begin
$display("Error: ALU_out is %b, expected sum is %b", ALU_out, val_A + val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b + %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

ALU_op = 2'b01;
#1;
if(ALU_out != (val_A - val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, val_A - val_B);
err_reg = 1'b1;
end
else if(Z != 1'b1) begin
$display("Error: ALU_out is 16'b0, but Z is not 1");
end
else begin
$display("ALU_out for %b - %b = %b is correct, and Z is set to 1", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b0000000000000001;
val_B = 16'b0000000000000010;
ALU_op = 2'b01;
#1;
if(ALU_out != (val_A - val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, val_A - val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b - %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b0000000000010001;
val_B = 16'b0000001100100010;
ALU_op = 2'b01;
#1;
if(ALU_out != (val_A - val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, val_A - val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b - %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b1111111111111111;
val_B = 16'b1111111111111111;
ALU_op = 2'b00;
#1;
if(ALU_out != (val_A + val_B)) begin
$display("Error: ALU_out is %b, expected sum is %b", ALU_out, val_A + val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b + %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b0111101111011111;
ALU_op = 2'b01;
#1;
if(ALU_out != (val_A - val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, val_A - val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b - %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b0111101111011111;
ALU_op = 2'b00;
#1;
if(ALU_out != (val_A + val_B)) begin
$display("Error: ALU_out is %b, expected sum is %b", ALU_out, val_A + val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b + %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b0111101111011111;
ALU_op = 2'b10;
#1;
if(ALU_out != (val_A & val_B)) begin
$display("Error: ALU_out is %b, expected result is %b", ALU_out, val_A & val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for %b & %b = %b is correct", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b0000000000000000;
val_B = 16'b0111101111011111;
ALU_op = 2'b10;
#1;
if(ALU_out != (val_A & val_B)) begin
$display("Error: ALU_out is %b, expected result is %b", ALU_out, val_A & val_B);
err_reg = 1'b1;
end
else if(Z != 1'b1) begin
$display("Error: ALU_out is 16'b0, but Z is not 1");
end
else begin
$display("ALU_out for %b & %b = %b is correct, and Z is set to 1", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b0000000000000001;
val_B = 16'b1111111111111111;
ALU_op = 2'b00;
#1;
if(ALU_out != (val_A + val_B)) begin
$display("Error: ALU_out is %b, expected result is %b", ALU_out, val_A + val_B);
err_reg = 1'b1;
end
else if(Z != 1'b1) begin
$display("Error: ALU_out is 16'b0, but Z is not 1");
end
else begin
$display("ALU_out for %b + %b = %b is correct, and Z is set to 1", val_A, val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b0111101111011111;
ALU_op = 2'b11;
#1;
if(ALU_out != (~val_B)) begin
$display("Error: ALU_out is %b, expected result is %b", ALU_out, ~val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for ~%b = %b is correct", val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b1111111111111111;
ALU_op = 2'b11;
#1;
if(ALU_out != (~val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, ~val_B);
err_reg = 1'b1;
end
else if(Z != 1'b1) begin
$display("Error: ALU_out is 16'b0, but Z is not 1");
end
else begin
$display("ALU_out for ~%b = %b is correct, and Z is set to 1", val_B, ALU_out); 
end
#1;

val_A = 16'b1101111110111011;
val_B = 16'b0000000000000000;
ALU_op = 2'b11;
#1;
if(ALU_out != (~val_B)) begin
$display("Error: ALU_out is %b, expected difference is %b", ALU_out, ~val_B);
err_reg = 1'b1;
end
else begin
$display("ALU_out for ~%b = %b is correct", val_B, ALU_out); 
end
#1;



end


endmodule: tb_ALU
