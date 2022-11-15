`timescale 1 ps / 1 ps

module tb_datapath(output err);

reg clk;
reg [15:0] datapath_in;
reg wb_sel;
reg [2:0] w_addr;
reg w_en;
reg [2:0] r_addr;
reg en_A;
reg en_B;
reg [1:0] shift_op;
reg sel_A;
reg sel_B;
reg [1:0] ALU_op;
reg en_C;
reg en_status;
wire [15:0] datapath_out;
wire Z_out;


reg err_reg;
assign err = err_reg;

datapath test_datapath(.clk(clk),
			.datapath_in(datapath_in),
			.wb_sel(wb_sel),
			.w_addr(w_addr),
			.w_en(w_en),
			.r_addr(r_addr),
			.en_A(en_A),
			.en_B(en_B),
			.shift_op(shift_op),
			.sel_A(sel_A),
			.sel_B(sel_B),
			.ALU_op(ALU_op),
			.en_C(en_C),
			.en_status(en_status),
			.datapath_out(datapath_out),
			.Z_out(Z_out));

initial begin

err_reg = 1'b0;
clk = 1'b0;  //initialize clk at 0 for first rising edge to work

//instruction:
// MOV R0, 1111000011110000
// MOV R7, 1111000011110000
// ADD R5, R0, R7, LSL#1

w_en = 1'b1;        
wb_sel = 1'b1;
#5;
$display("Instruction test 1");
$display("MOV R0, 1111000011110000");
$display("MOV R7, 1111000011110000");
$display("ADD R5, R0, R7, LSL#1");
w_addr = 3'b000;    //writing datapath_in to r0
datapath_in = 16'b1111000011110000;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_addr = 3'b111;   //writing datapath_in to r7
datapath_in = 16'b1111000011110000;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
wb_sel = 1'b0;
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
wb_sel = 1'b0;  //writing value of reg C to R5
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
else if (Z_out != 1'b0) begin
$display("Error: datapath_out is correct but Z_out is not 1'b0");
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
wb_sel = 1'b1;
datapath_in = 16'b0100110110100001;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
w_en = 1'b0;
wb_sel = 1'b0;
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
wb_sel = 1'b0;
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
else if(Z_out != 1'b0) begin
$display("Error: datapath_out is correct but Z_out is not 1'b0");
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
$display("sel_B = 1'b1 (first 5 bits of datapath_in)");
$display("R3 AND datapath_in[4:0], store in R4");
#5;
r_addr = 3'b011;
en_A = 1'b1;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
datapath_in = 16'b1010101010110001;
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
wb_sel = 1'b0;
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
else if(Z_out != 1'b0) begin
$display("Error: datapath_out is correct but Z_out is not 1'b0");
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
wb_sel = 1'b0;
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
else if(Z_out != 1'b1) begin
$display("Error: datapath_out is correct but Z_out is not 1'b1");
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
