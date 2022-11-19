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
				.sel_A(sel_A),
				.sel_B(sel_B));

initial begin
clk = 1'b0;
rst_n = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
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
clk = 1'b0;
#5;
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
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
clk = 1'b1;
#5;
clk = 1'b0;
#5;
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



end



endmodule: tb_controller
