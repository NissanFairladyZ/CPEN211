module tb_controller(output err);
  //module controller(input clk, input rst_n, input start,
   //               input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
   //               input Z, input N, input V,
   //               output waiting,
    //              output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
     //             output en_A, output en_B, output en_C, output en_status,
     //             output sel_A, output sel_B);

reg clk;
reg rst_n;
reg start;
reg [2:0] opcode;
reg [1:0] ALU_op;
reg [1:0] shift_op;
reg Z;
reg N;
reg V;
wire waiting;
wire [1:0] reg_sel;
wire [1:0] wb_sel;
wire w_en;
wire en_A;
wire en_B;
wire en_C;
wire en_status;
wire sel_A;
wire sel_B;

reg err_reg;
assign err = err_reg;

controller controllertest (.clk(clk),
				.rst_n(rst_n),
				.start(start),
				.opcode(opcode),
				.ALU_op(ALU_op),
				.shift_op(shift_op),
				.Z(Z),
				.N(N),
				.V(V),
				.waiting(waiting),
				.reg_sel(reg_sel),
				.wb_sel(wb_sel),
				.w_en(w_en),
				.en_A(en_A),
				.en_B(en_B),
				.en_C(en_C),
				.en_status(en_status),
				.sel_A(sel_A),
				.sel_B(sel_B));

initial begin
clk = 1'b0;
rst_n = 1'b0;
err_reg = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end
$display("Starting MOV imm state cycle");
rst_n = 1'b1;
opcode = 3'b110;
ALU_op = 2'b10;
start = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
start = 1'b0;
#5;
clk = 1'b1;
#5;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b10101000000) begin
$display("Error: output signals for state 1 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b10101000000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 1");
end
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end
$display("Starting MOV/MVN state cycle");
opcode = 3'b110;
ALU_op = 2'b00;
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
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b00000010000) begin
$display("Error: output signals for state 2 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b00000010000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 2");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01000001010) begin
$display("Error: output signals for state 3 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01000001010);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 3");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01001000010) begin
$display("Error: output signals for state 4 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01001000010);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 4");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end
$display("Starting ADD/AND state cycle");
opcode = 3'b101;
ALU_op = 2'b00;
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
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b10000100000) begin
$display("Error: output signals for state 5 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b10000100000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 5");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b00000010000) begin
$display("Error: output signals for state 6 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b00000010000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 6");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b00000001000) begin
$display("Error: output signals for state 7 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b00000001000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 7");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01001000000) begin
$display("Error: output signals for state 8 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01001000000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 8");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end
$display("Starting CMP state cycle");
opcode = 3'b101;
ALU_op = 2'b01;
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
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b10000100000) begin
$display("Error: output signals for state 9 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b10000100000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 9");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b00000010000) begin
$display("Error: output signals for state 10 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b00000010000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 10");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b00000000100) begin
$display("Error: output signals for state 11 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b00000000100);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 11");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 12 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 12");
end
#5;
clk = 1'b1;
#5;
clk = 1'b0;
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end
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
$display("Ensuring controller remains in wait state multiple clk cycles after most recent instruction ends with start = 0");
if({reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B}!=11'b01100000000) begin
$display("Error: output signals for state 0 %b do not match the expected output of %b", {reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B},11'b01100000000);
err_reg = 1'b1;
end
else if(waiting != 1'b1) begin
$display("Error: controller in state 0, but waiting is not 1");
err_reg = 1'b1;
end
else begin
$display("Correct output signals for state 0, and waiting is 1");
end

end



endmodule: tb_controller
