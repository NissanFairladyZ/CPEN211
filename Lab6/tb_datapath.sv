module tb_datapath(output err);
//  module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
 //               input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
 //               input en_B, input [1:0] shift_op, input sel_A, input sel_B,
 //               input [1:0] ALU_op, input en_C, input en_status,
	//	input [15:0] sximm8, input [15:0] sximm5,
 //               output [15:0] datapath_out, output Z_out, output N_out, output V_out);

reg clk;
reg [15:0] mdata;
reg [7:0] pc;
reg [1:0] wb_sel;
reg [2:0] w_addr;
reg [2:0] r_addr;
reg w_en;
reg en_A;
reg en_B;
reg [1:0] shift_op;
reg sel_A;
reg sel_B;
reg [1:0] ALU_op;
reg en_C;
reg en_status;
reg [15:0] sximm8;
reg [15:0] sximm5;
wire [15:0] datapath_out;
wire Z_out;
wire N_out;
wire V_out;

reg err_reg;
assign err = err_reg;

datapath datapathtest (.clk(clk),
			.mdata(mdata),
			.pc(pc),
			.wb_sel(wb_sel),
			.w_addr(w_addr),
			.r_addr(r_addr),
			.w_en(w_en),
			.en_A(en_A),
			.en_B(en_B),
			.shift_op(shift_op),
			.sel_A(sel_A),
			.sel_B(sel_B),
			.ALU_op(ALU_op),
			.en_C(en_C),
			.en_status(en_status),
			.sximm8(sximm8),
			.sximm5(sximm5),
			.datapath_out(datapath_out),
			.Z_out(Z_out),
			.N_out(N_out),
			.V_out(V_out));

initial begin

err_reg = 1'b0;
clk = 1'b0;  //initialize clk at 0 for first rising edge to work

//instruction:
// MOV R0, 1111000011110000
// MOV R7, 1111000011110000
// ADD R5, R0, R7, LSL#1

w_en = 1'b1;        
wb_sel = 2'b10;
#5;
$display("Instruction test 1");
$display("MOV R0, 1111000011110000");
$display("MOV R7, 1111000011110000");
$display("ADD R5, R0, R7, LSL#1");
w_addr = 3'b000;    //writing datapath_in to r0
sximm8 = 16'b1111000011110000;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_addr = 3'b111;   //writing datapath_in to r7
sximm8 = 16'b1111000011110000;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
wb_sel = 2'b00;
#5;
r_addr = 3'b000;    //reading r0 to reg A
en_A = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
r_addr = 3'b111;   //reading r7 to reg B
en_A = 1'b0;
en_B = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
en_B = 1'b0;
sel_A = 1'b0;      //both val_A and val_B muxes taking input vals from reg A, B
sel_B = 1'b0;
shift_op = 2'b01;   //shifter applying left shift to value from reg B
#5;
ALU_op = 2'b00; //ALU adds values of val_A and val_B
#5;
en_C = 1'b1;      //writing ALU outputs to reg C and reg status
en_status = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
en_C = 1'b0;
en_status = 1'b0;
#5;
wb_sel = 2'b00;  //writing value of reg C to R5
w_en = 1'b1;
w_addr = 3'b101;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
if(datapath_out != 16'b1111000011110000 + (16'b1111000011110000 << 1)) begin
$display("Error: datapath_out %b doesn't match expected value %b",datapath_out,16'b1111000011110000 + (16'b1111000011110000 << 1));
err_reg = 1'b1;
end
else if ({Z_out,N_out,V_out} != 3'b010) begin
$display("Error: datapath_out is correct but ZNV %b differs from expected %b", {Z_out,N_out,V_out},3'b010);
err_reg = 1'b1;
end
else begin
$display("datapath_out %b is correct, and Z_out is set to 1'b0. R5 now holds this value", datapath_out); 
$display("Current reg status:");
$display("R0 = %b", 16'b1111000011110000);
$display("R5 = %b", datapath_out);
$display("R7 = %b", 16'b1111000011110000);
end





#20;
$display("Instruction test 2");
$display("MOV R1, 0100110110100001");
$display("SUB R3, R1, R5");
w_addr = 3'b001;
w_en = 1'b1;
wb_sel = 2'b10;
sximm8 = 16'b0100110110100001;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
wb_sel = 2'b00;
r_addr = 3'b001;
en_A = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
en_A = 1'b0;
en_B = 1'b1;
r_addr = 3'b101;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
en_B = 1'b0;
sel_A = 1'b0;
sel_B = 1'b0;
shift_op = 2'b00;
ALU_op = 2'b01;
#5;
en_C = 1'b1;
en_status = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_addr = 3'b011;
w_en = 1'b1;
wb_sel = 2'b00;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
if(datapath_out != 16'b0100110110100001 - 16'b1101001011010000) begin
$display("Error: datapath_out %b doesn't match expected value %b",datapath_out,16'b0100110110100001 - 16'b1101001011010000);
err_reg = 1'b1;
end
else if ({Z_out,N_out,V_out} != 3'b000) begin
$display("Error: datapath_out is correct but ZNV %b differs from expected %b", {Z_out,N_out,V_out},3'b000);
err_reg = 1'b1;
end
else begin
$display("datapath_out %b is correct, and Z_out is set to 1'b0. R3 now holds this value", datapath_out); 
$display("Current reg status:");
$display("R0 = %b", 16'b1111000011110000);
$display("R1 = %b", 16'b0100110110100001);
$display("R3 = %b", datapath_out);
$display("R5 = %b", 16'b1101001011010000);
$display("R7 = %b", 16'b1111000011110000);
end




#20;
$display("Test 3: testing mux sel_B");
$display("sel_B = 1'b1 sximm8");
$display("R3 AND sximm5, store in R4");
#5;
r_addr = 3'b011;
en_A = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
sximm5 = 16'b1000010100110001;
sel_A = 1'b0;
sel_B = 1'b1;
ALU_op = 2'b10;
#5;
en_C = 1'b1;
en_status = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b1;
wb_sel = 2'b00;
w_addr = 3'b100;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
#5;
if(datapath_out != 16'b0000000000010001) begin
$display("Error: datapath_out %b doesn't match expected value %b",datapath_out,16'b0000000000010001);
err_reg = 1'b1;
end
else if ({Z_out,N_out,V_out} != 3'b000) begin
$display("Error: datapath_out is correct but ZNV %b differs from expected %b", {Z_out,N_out,V_out},3'b000);
err_reg = 1'b1;
end
else begin
$display("datapath_out %b is correct, and Z_out is set to 1'b0. R4 now holds this value", datapath_out); 
$display("Current reg status:");
$display("R0 = %b", 16'b1111000011110000);
$display("R1 = %b", 16'b0100110110100001);
$display("R3 = %b", 16'b0111101011010001);
$display("R4 = %b", datapath_out);
$display("R5 = %b", 16'b1101001011010000);
$display("R7 = %b", 16'b1111000011110000);
end




#20;
$display("Test 4: testing sel_A, Z_out and reg overwrite");
$display("16'b0 AND R0, store in R0");
#5;
r_addr = 3'b000;
en_A = 1'b1;
en_B = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
sel_A = 1'b1;
sel_B = 1'b0;
ALU_op = 2'b10;
shift_op = 2'b00;
#5;
en_C = 1'b1;
en_status = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b1;
wb_sel = 2'b00;
w_addr = 3'b000;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
if(datapath_out != 16'b0000000000000000) begin
$display("Error: datapath_out %b doesn't match expected value %b",datapath_out,16'b0000000000010001);
err_reg = 1'b1;
end
else if ({Z_out,N_out,V_out} != 3'b100) begin
$display("Error: datapath_out is correct but ZNV %b differs from expected %b", {Z_out,N_out,V_out},3'b100);
err_reg = 1'b1;
end
else begin
$display("datapath_out %b is correct, and Z_out is set to 1'b1. R0 now holds this value", datapath_out); 
$display("Current reg status:");
$display("R0 = %b", datapath_out);
$display("R1 = %b", 16'b0100110110100001);
$display("R3 = %b", 16'b0111101011010001);
$display("R4 = %b", 16'b0000000000010001);
$display("R5 = %b", 16'b1101001011010000);
$display("R7 = %b", 16'b1111000011110000);
end



end



endmodule: tb_datapath
