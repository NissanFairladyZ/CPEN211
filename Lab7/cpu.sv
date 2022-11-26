module cpu(input clk, input rst_n, input [7:0] start_pc, input [15:0] ram_r_data,
           output [15:0] out, output ram_w_en,
		output [7:0] ram_addr, output [15:0] ram_w_data);
  
reg [15:0] IR_reg;
wire [15:0] IR;
assign IR = IR_reg;



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
//ram_w_en,sel_addr,load_pc,clear_pc,load_addr,load_ir

wire sel_addr;
wire load_pc;
wire clear_pc;
wire load_addr;
wire load_ir;

reg [7:0] next_pc_reg;
wire [7:0] next_pc;
assign next_pc = next_pc_reg;

reg [7:0] pc_reg;
assign pc = pc_reg;

wire [7:0] out_wire;
assign out_wire = out[7:0];

assign ram_w_data = out;

reg [7:0] dar;
wire [7:0] dar_wire;
assign dar_wire = dar;

reg [7:0] ram_addr_reg;
assign ram_addr = ram_addr_reg;



always_comb begin
case(clear_pc)
1'b0: next_pc_reg = pc + 8'b00000001;
1'b1: next_pc_reg = start_pc;
endcase

case(sel_addr)
1'b0: ram_addr_reg = dar_wire;
1'b1: ram_addr_reg = pc;
endcase
end

always_ff @ (posedge clk) begin
if(load_ir) IR_reg <= ram_r_data;
if(load_pc) pc_reg <= next_pc;
if(load_addr) dar <= out_wire;
end

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
			.mdata(ram_r_data),
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
			.opcode(opcode),
			.ALU_op(ALU_op),
			.shift_op(shift_op),
			.Z(status[0]),
			.N(status[1]),
			.V(status[2]),
			.reg_sel(reg_sel),
			.wb_sel(wb_sel),
			.w_en(w_en),
			.en_A(en_A),
			.en_B(en_B),
			.en_C(en_C),
			.en_status(en_status),
			.sel_A(sel_A),
			.sel_B(sel_B),
			.ram_w_en(ram_w_en),
			.sel_addr(sel_addr),
			.load_pc(load_pc),
			.clear_pc(clear_pc),
			.load_addr(load_addr),
			.load_ir(load_ir));

		

endmodule: cpu
