module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
  
reg [15:0] IR_reg;
wire [15:0] IR;
assign IR = IR_reg;

always_ff @ (posedge clk) begin
if(load) IR_reg <= instr;
end

wire [2:0] opcode;
wire [1:0] ALU_op;
wire [1:0] reg_sel;
wire [2:0] status;    //VNZ
wire [1:0] shift_op;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [2:0] r_addr;
wire [2:0] w_addr;
wire [15:0] mdata;
wire [7:0] pc;
wire [1:0] wb_sel;
wire w_en;
wire en_A;
wire en_B;
wire sel_A;
wire sel_B;
wire en_C;
wire en_status;

assign Z = status[0];
assign N = status[1];
assign V = status[2];

idecoder decode(.ir(IR),
		.reg_sel(reg_sel),
		.opcode(opcode),
		.ALU_op(ALU_op),
		.shift_op(shift_op),
		.sximm5(sximm5),
		.sximm8(sximm8),
		.r_addr(r_addr),
		.w_addr(w_addr));
 
datapath newdatapath(.clk(clk),
			.mdata(mdata),
			.pc(pc),
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
			.sximm8(sximm8),
			.sximm5(sximm5),
			.datapath_out(out),
			.Z_out(status[0]),
			.N_out(status[1]),
			.V_out(status[2]));
		
controller control(.clk(clk),
			.rst_n(rst_n),
			.start(start),
			.opcode(opcode),
			.ALU_op(ALU_op),
			.shift_op(shift_op),
			.Z(status[0]),
			.N(status[1]),
			.V(status[2]),
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
		

endmodule: cpu
