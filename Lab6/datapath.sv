module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  reg [15:0] wb_reg;    //writeback mux connection and w_data
wire [15:0] w_data;
assign w_data = wb_reg;

wire [15:0] r_data;  //output wire for register

reg [15:0] reg_A;           //registers A and B
reg [15:0] reg_B;
wire [15:0] wire_A;
wire [15:0] wire_B;
assign wire_A = reg_A;
assign wire_B = reg_B;

reg [15:0] val_A_reg;      //mux outputs val_A and val_B
reg [15:0] val_B_reg;
wire [15:0] val_A_wire;
wire [15:0] val_B_wire;
assign val_A_wire = val_A_reg;
assign val_B_wire = val_B_reg;

assign reg_A_out = reg_A;
assign reg_B_out = reg_B;
assign val_A_out = val_A_reg;
assign val_B_out = val_B_reg;


wire [15:0] shift_wire_B;

wire [15:0] ALU_out_wire;    //ALU output wires
wire Z_wire;
wire N_wire;
wire V_wire;

reg [15:0] reg_C;           //reg C
wire [15:0] wire_C;
assign wire_C = reg_C;
assign datapath_out = reg_C;   //datapath_out

reg [2:0] status;          //reg status
assign Z_out = status[0];         //Z_out
assign N_out = status[1];
assign V_out = status[2];

regfile register(.w_data(w_data),            //register instantiation
			.w_addr(w_addr),
			.w_en(w_en),
			.r_addr(r_addr),
			.clk(clk),
			.r_data(r_data));

shifter shift(.shift_in(wire_B),             //shifter instantiation
		.shift_op(shift_op),
		.shift_out(shift_wire_B));

ALU arithmetic(.val_A(val_A_wire),           //ALU instantiation
		.val_B(val_B_wire),
		.ALU_op(ALU_op),
		.ALU_out(ALU_out_wire),
		.Z(Z_wire),
		.N(N_wire),
		.V(V_wire));


 
always_comb begin
case(wb_sel)       //writeback mux
2'b00: wb_reg = wire_C;         //value of reg C
2'b01: wb_reg = {8'b0,pc};
2'b10: wb_reg = sximm8;
2'b11: wb_reg = mdata;
endcase

case(sel_A)               //sel_A mux
1'b0: val_A_reg = wire_A;
1'b1: val_A_reg = 16'b0000000000000000;
endcase

case(sel_B)                 //sel_B mux;
1'b0: val_B_reg = shift_wire_B;
1'b1: val_B_reg = sximm5;
endcase

end

always_ff @(posedge clk) begin
if(en_A) reg_A <= r_data;
if(en_B) reg_B <= r_data;
if(en_C) reg_C <= ALU_out_wire;
if(en_status) status[0] <= Z_wire;
if(en_status) status[1] <= N_wire;
if(en_status) status[2] <= V_wire;
end

endmodule: datapath
