`timescale 1 ps/ 1 ps

module tb_cpu(output err);
  //module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
  //         output waiting, output [15:0] out, output N, output V, output Z);

reg clk;
reg rst_n;
reg load;
reg start;
reg [15:0] instr;
wire waiting;
wire [15:0] out;
wire N;
wire V;
wire Z;

reg err_reg;
assign err = err_reg;

cpu cputest(.clk(clk),
		.rst_n(rst_n),
		.load(load),
		.start(start),
		.instr(instr),
		.waiting(waiting),
		.out(out),
		.N(N),
		.V(V),
		.Z(Z));

initial begin
err_reg = 1'b0;
clk = 1'b0;
rst_n = 1'b0;
#5;
clk = 1'b1; 
#5;
clk = 1'b0;
rst_n = 1'b1;
$display("Executing MOV R0,%b", 8'b11110000);
instr = 16'b1101000011110000; //MOV R0, 11110000
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
$display("Executing MOV R3,%b", 8'b00001111);
instr = 16'b1101001100001111; //MOV R3, 00001111
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
start = 1'b0; 
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b1;
$display("Executing ADD R6, R0, R3");
instr = 16'b1010000011000011; //ADD R6, R0, R3
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if(out!=16'b1111111111111111) begin
$display("Error: output %b for ADD R6, R0, R3 does not match expected output %b",out,16'b1111111111111111);
err_reg = 1'b1;
end
else begin
$display("No errors for ADD R6, R0, R3. R6 now holds %b",out);
end
$display("Executing MVN R5, R0, LSL#1");
instr = 16'b1011100010101000; //MVN R5, R0, LSL#1
load = 1'b1; 
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if(out!=16'b0000000000011111) begin
$display("Error: output %b for MVN R5, R0, LSL#1 does not match expected output %b",out,16'b0000000000011111);
err_reg = 1'b1;
end
else begin
$display("No errors for MVN R5, R0, LSL#1. R5 now holds %b",out);
end
$display("Executing CMP R3, R0");
instr = 16'b1010101100000000;  //CMP R3,R0
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if({N,V,Z}!=3'b000) begin
$display("Error: status NVZ %b for CMP R3, R0 does not match expected NVZ %b", {N,V,Z}, 3'b000);
err_reg = 1'b1;
end
else begin
$display("No errors for CMP R3, R0. Status NVZ is %b",{N,V,Z});
end
$display("Executing CMP R0, R3");
instr = 16'b1010100000000011;  //CMP R0,R3
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if({N,V,Z}!=3'b100) begin
$display("Error: status NVZ %b for CMP R0, R3 does not match expected NVZ %b", {N,V,Z}, 3'b100);
err_reg = 1'b1;
end
else begin
$display("No errors for CMP R0, R3. Status NVZ is %b",{N,V,Z});
end
$display("Executing CMP R3, R3");
instr = 16'b1010101100000011;  //CMP R3,R3
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if({N,V,Z}!=3'b001) begin
$display("Error: status NVZ %b for CMP R3, R3 does not match expected NVZ %b", {N,V,Z}, 3'b001);
err_reg = 1'b1;
end
else begin
$display("No errors for CMP R3, R3. Status NVZ is %b",{N,V,Z});
end
$display("Executing ADD R1, R3, R5");
instr = 16'b1010001100100101;  //ADD R1,R3,R5
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if(out!=16'b0000000000101110) begin
$display("Error: output %b for ADD R1, R3, R5 does not match expected output %b",out,16'b0000000000101110);
err_reg = 1'b1;
end
else begin
$display("No errors for ADD R1, R3, R5. R1 now holds %b",out);
end
$display("Executing ADD R2, R1, R5");
instr = 16'b1010000101000101;  //ADD R2,R1,R5
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if(out!=16'b0000000001001101) begin
$display("Error: output %b for ADD R2, R1, R5 does not match expected output %b",out,16'b0000000001001101);
err_reg = 1'b1;
end
else begin
$display("No errors for ADD R2, R1, R5. R2 now holds %b",out);
end
$display("Executing AND R4, R1, R2");
instr = 16'b1011000110000010;  //AND R4,R1,R2
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if(out!=16'b0000000000001100) begin
$display("Error: output %b for AND R4, R1, R2 does not match expected output %b",out,16'b0000000000000110);
err_reg = 1'b1;
end
else begin
$display("No errors for AND R4, R1, R2. R4 now holds %b",out);
end
$display("Executing MOV R7, R0, LSR#1");
instr = 16'b1100000011110000 ;  //MOV R7, R0, LSR#1
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if(out!=16'b0111111111111000) begin
$display("Error: output %b for MOV R7, R0, LSR#1 does not match expected output %b",out,16'b0111111111111000);
err_reg = 1'b1;
end
else begin
$display("No errors for MOV R7, R0, LSR#1. R7 now holds %b",out);
end
$display("Executing CMP R7, R0");
instr = 16'b1010111100000000;  //CMP R7,R0 (N and V should go high, bit overflow from expected positive result)
load = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
load = 1'b0;
start = 1'b1;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
if({N,V,Z}!=3'b110) begin
$display("Error: status NVZ %b for CMP R7, R0 does not match expected NVZ %b", {N,V,Z}, 3'b110);
err_reg = 1'b1;
end
else begin
$display("No errors for CMP R7, R0. Status NVZ is %b",{N,V,Z});
end
#5;
clk = 1'b1;
#5; 
clk = 1'b0;
#5;



end

endmodule: tb_cpu