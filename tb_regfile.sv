module tb_regfile(output err);

reg [15:0] SIM_w_data; 
reg [2:0] SIM_w_addr;
reg SIM_w_en;
reg [2:0] SIM_r_addr; 
reg SIM_clk;
wire [15:0] SIM_r_data;

reg err_reg;
assign err = err_reg;


regfile test(.w_data(SIM_w_data),
		.w_addr(SIM_w_addr),
		.w_en(SIM_w_en),
		.r_addr(SIM_r_addr),
		.clk(SIM_clk),
		.r_data(SIM_r_data));

initial begin

err_reg = 1'b0; //initialize err as 1'b0

//write 0010100000111111 to r3
SIM_w_en = 1'b1;
SIM_w_addr = 3'b011;
SIM_w_data = 16'b0010100000111111;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;

//checking all addresses: only r3 should output 010100000111111
SIM_r_addr = 3'b000;  //r0
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r0 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b001;  //r1
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r1 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b010;  //r2
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r2 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b011;  //r3
#1;
if(SIM_r_data != 16'b0010100000111111) begin
err_reg = 1'b1;
$display("Error: r3 is %b, expected %b", SIM_r_data, 16'b0010100000111111);
end
#1;
 SIM_r_addr = 3'b100;  //r4
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1; 
$display("Error: r4 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b101;  //r5
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r5 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b110;  //r6
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r6 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b111;  //r7
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r7 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
if(err == 1'b0) begin
$display("No errors found when writing 0010100000111111 to r3");
end
#1;

//attempt to write 1010100100110111 to r5 with w_en off, and write 1010100100110111 to r7 with w_en on
SIM_w_en = 1'b0;
SIM_w_addr = 3'b101;
SIM_w_data = 16'b1010100100110111;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;

SIM_w_en = 1'b1;
SIM_w_addr = 3'b111;
SIM_w_data = 16'b1010100100110111;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;

//checking all addresses
SIM_r_addr = 3'b000;  //r0
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r0 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b001;  //r1
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r1 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b010;  //r2
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r2 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b011;  //r3
#1;
if(SIM_r_data != 16'b0010100000111111) begin
err_reg = 1'b1;
$display("Error: r3 is %b, expected %b", SIM_r_data, 16'b0010100000111111);
end
#1;
 SIM_r_addr = 3'b100;  //r4
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1; 
$display("Error: r4 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b101;  //r5
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r5 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b110;  //r6
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r6 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b111;  //r7
#1;
if(SIM_r_data != 16'b1010100100110111) begin
err_reg = 1'b1;
$display("Error: r7 is %b, expected %b", SIM_r_data, 16'b1010100100110111);
end
#1;
if(err == 1'b0) begin
$display("No errors found when writing 1010100100110111 to r7 and not to r5");
end
#1;

//write 0010101000110011 to r0,r1,r2
SIM_w_en = 1'b1;
SIM_w_addr = 3'b000;
SIM_w_data = 16'b0010101000110011;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;
SIM_w_addr = 3'b001;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;
SIM_w_addr = 3'b010;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;

//checking all addresses
SIM_r_addr = 3'b000;  //r0
#1;
if(SIM_r_data != 16'b0010101000110011) begin
err_reg = 1'b1;
$display("Error: r0 is %b, expected %b", SIM_r_data, 16'b0010101000110011);
end
#1;
 SIM_r_addr = 3'b001;  //r1
#1;
if(SIM_r_data != 16'b0010101000110011) begin
err_reg = 1'b1;
$display("Error: r1 is %b, expected %b", SIM_r_data, 16'b0010101000110011);
end
#1;
 SIM_r_addr = 3'b010;  //r2
#1;
if(SIM_r_data != 16'b0010101000110011) begin
err_reg = 1'b1;
$display("Error: r2 is %b, expected %b", SIM_r_data, 16'b0010101000110011);
end
#1;
 SIM_r_addr = 3'b011;  //r3
#1;
if(SIM_r_data != 16'b0010100000111111) begin
err_reg = 1'b1;
$display("Error: r3 is %b, expected %b", SIM_r_data, 16'b0010100000111111);
end
#1;
 SIM_r_addr = 3'b100;  //r4
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1; 
$display("Error: r4 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b101;  //r5
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r5 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b110;  //r6
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r6 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b111;  //r7
#1;
if(SIM_r_data != 16'b1010100100110111) begin
err_reg = 1'b1;
$display("Error: r7 is %b, expected %b", SIM_r_data, 16'b1010100100110111);
end
#1;
if(err == 1'b0) begin
$display("No errors found when writing 0010101000110011 to r0,r1,r2");
end
#1;

//writing all zeros to r0 and all ones to r2,r5
SIM_w_en = 1'b1;
SIM_w_addr = 3'b000;
SIM_w_data = 16'b0;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;
SIM_w_addr = 3'b010;
SIM_w_data = 16'b1111111111111111;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;
SIM_w_addr = 3'b101;
SIM_w_data = 16'b1111111111111111;
#1;
SIM_clk = 1'b1;
#1;
SIM_clk = 1'b0;
#1;

//checking all addresses
SIM_r_addr = 3'b000;  //r0
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r0 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b001;  //r1
#1;
if(SIM_r_data != 16'b0010101000110011) begin
err_reg = 1'b1;
$display("Error: r1 is %b, expected %b", SIM_r_data, 16'b0010101000110011);
end
#1;
 SIM_r_addr = 3'b010;  //r2
#1;
if(SIM_r_data != 16'b1111111111111111) begin
err_reg = 1'b1;
$display("Error: r2 is %b, expected %b", SIM_r_data, 16'b1111111111111111);
end
#1;
 SIM_r_addr = 3'b011;  //r3
#1;
if(SIM_r_data != 16'b0010100000111111) begin
err_reg = 1'b1;
$display("Error: r3 is %b, expected %b", SIM_r_data, 16'b0010100000111111);
end
#1;
 SIM_r_addr = 3'b100;  //r4
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1; 
$display("Error: r4 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b101;  //r5
#1;
if(SIM_r_data != 16'b1111111111111111) begin
err_reg = 1'b1;
$display("Error: r5 is %b, expected %b", SIM_r_data, 16'b1111111111111111);
end
#1;
 SIM_r_addr = 3'b110;  //r6
#1;
if(SIM_r_data != 16'b0) begin
err_reg = 1'b1;
$display("Error: r6 is %b, expected %b", SIM_r_data, 16'b0);
end
#1;
 SIM_r_addr = 3'b111;  //r7
#1;
if(SIM_r_data != 16'b1010100100110111) begin
err_reg = 1'b1;
$display("Error: r7 is %b, expected %b", SIM_r_data, 16'b1010100100110111);
end
#1;
if(err == 1'b0) begin
$display("No errors found when writing all zeros to r0 and all ones to r2, r5");
end
#1;





end

endmodule: tb_regfile
