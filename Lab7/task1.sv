module task1(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
  
wire waiting;
wire ram_w_en;
wire [7:0] ram_addr;
wire [15:0] ram_r_data;
wire [15:0] ram_w_data;

cpu taskcpu (.clk(clk),
		.rst_n(rst_n),
		.ram_r_data(ram_r_data),
		.start_pc(start_pc),
		.waiting(waiting),
		.out(out),
		.ram_w_en(ram_w_en),
		.ram_addr(ram_addr),
		.ram_w_data(ram_w_data));

ram taskram(.clk(clk),
		.ram_w_en(ram_w_en),
		.ram_r_addr(ram_addr),
		.ram_w_addr(ram_addr),
		.ram_w_data(ram_w_data),
		.ram_r_data(ram_r_data));




endmodule: task1

module cpu(input clk, input rst_n, input [15:0] ram_r_data, input [7:0] start_pc, 
           	output waiting, output [15:0] out,
		output ram_w_en, output [7:0] ram_addr,
	        output [15:0] ram_w_data);
  

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

reg [15:0] IR_reg;
wire [15:0] IR;
assign IR = IR_reg;

reg startreg;
wire startwire;
assign startwire = startreg;

wire load_ir;

assign ram_w_data = out;

reg [7:0] pc_reg;
assign pc = pc_reg;

reg [7:0] next_pc;
wire [7:0] next_pc_wire;
assign next_pc_wire = next_pc;

reg [7:0] dar;
wire [7:0] dar_wire;
assign dar_wire = dar;

reg [7:0] ram_addr_reg;
assign ram_addr = ram_addr_reg;

wire clear_pc;  
wire load_pc;
wire load_addr;
wire sel_addr;

//muxes
always_comb begin
//mux number 4
case(clear_pc)   
1'b0: next_pc = pc + 8'b00000001;
1'b1: next_pc = start_pc;
endcase
//mux number 6
case(sel_addr)
1'b0: ram_addr_reg = dar_wire;
1'b1: ram_addr_reg = pc;
endcase
end

//regs
always_ff @(posedge clk) begin
if(load_ir) IR_reg <= ram_r_data;
if(load_pc) pc_reg <= next_pc;
if(load_addr) dar <= ram_w_data[7:0];
startreg <= waiting;
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
			.start(startwire),
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
			.sel_B(sel_B),
			.ram_w_en(ram_w_en),
			.sel_addr(sel_addr),
			.load_pc(load_pc),
			.clear_pc(clear_pc),
			.load_addr(load_addr),
			.load_ir(load_ir));

endmodule: cpu
	




module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B,
		  output ram_w_en, output sel_addr,
		  output load_pc, output clear_pc, output load_addr, output load_ir);
  // your implementation here

//output signal regs
reg [1:0] reg_sel_reg;
assign reg_sel = reg_sel_reg;
reg [1:0] wb_sel_reg;
assign wb_sel = wb_sel_reg;
reg w_en_reg;
assign w_en = w_en_reg;
reg en_A_reg;
assign en_A = en_A_reg;
reg en_B_reg;
assign en_B = en_B_reg;
reg en_C_reg;
assign en_C = en_C_reg;
reg en_status_reg;
assign en_status = en_status_reg;
reg sel_A_reg;
assign sel_A = sel_A_reg;
reg sel_B_reg;
assign sel_B = sel_B_reg;



reg [3:0] state;             //current state reg
wire [3:0] statewire;
assign statewire = state;

reg waitingreg;                //waiting output reg
assign waiting = waitingreg;

reg [3:0] zeronext;              //output of zero-progression mux
wire [3:0] zeronextwire;
assign zeronextwire = zeronext;

reg [3:0] nonzeronext;           //output of non-zero-progression mux
wire [3:0] nonzeronextwire;
assign nonzeronextwire = nonzeronext;

reg [3:0] stateoutput;            //state update reg
wire [3:0] stateoutputwire;
assign stateoutputwire = stateoutput; 

always_comb begin
case(statewire)
4'b0000: waitingreg = 1'b1;
default: waitingreg = 1'b0;
endcase

case({start,opcode,ALU_op})     
6'b111010: zeronext = 4'b0001; //(MOV imm) (1st state cycle, state 1)
6'b111000: zeronext = 4'b0010; //(MOV)     (2nd state cycle, states 2-4)
6'b110111: zeronext = 4'b0010; //(MVN)
6'b110100: zeronext = 4'b0101; //(ADD)      (3rd state cycle, states 5-8)
6'b110110: zeronext = 4'b0101; //(AND)
6'b110101: zeronext = 4'b1001; //(CMP)       (4th state cycle, states 9-12)
default: zeronext = 4'b0000;   //          (remain at state 0 for invalid)
endcase

case(statewire)
4'b0001: nonzeronext = 4'b0000; //(end of 1st cycle)  (MOV imm)
4'b0010: nonzeronext = 4'b0011;
4'b0011: nonzeronext = 4'b0100;
4'b0100: nonzeronext = 4'b0000; //(end of 2nd cycle) (MOV, MVN)
4'b0101: nonzeronext = 4'b0110;
4'b0110: nonzeronext = 4'b0111;
4'b0111: nonzeronext = 4'b1000;
4'b1000: nonzeronext = 4'b0000; //(end of 3rd cycle)  (ADD, AND)
4'b1001: nonzeronext = 4'b1010;
4'b1010: nonzeronext = 4'b1011; 
4'b1011: nonzeronext = 4'b1100; 
4'b1100: nonzeronext = 4'b0000; //(end of 4th cycle)   (CMP)
default: nonzeronext = statewire;
endcase

case(statewire)
4'b0000: stateoutput = zeronextwire;
default: stateoutput = nonzeronextwire;
endcase
end


always_ff @(posedge clk) begin
case(rst_n) 
1'b0: state <= 4'b0000;
1'b1: state <= stateoutputwire;
endcase

  case(statewire) //instructions differ slightly from written notes due to debugging                           aabbcdefghi
4'b0000: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01100000000; //0
4'b0001: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b10101000000; //1
4'b0010: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b00000010000; //2
4'b0011: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01000001010; //3
4'b0100: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01001000010; //4
4'b0101: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b10000100000; //5
4'b0110: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b00000010000; //6
4'b0111: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b00000001000; //7
4'b1000: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01001000000; //8
4'b1001: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b10000100000; //9
4'b1010: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b00000010000; //10
4'b1011: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b00000000100; //11  
4'b1100: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01100000000; //12    
default: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01100000000;
endcase
end



endmodule: controller


module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
  
assign opcode = ir[15:13];
assign ALU_op = ir[12:11];
assign shift_op = ir[4:3];

reg [15:0] sximm5reg;
assign sximm5 = sximm5reg;
reg [15:0] sximm8reg;
assign sximm8 = sximm8reg;
reg [2:0] muxout;
assign r_addr = muxout;
assign w_addr = muxout;

always_comb begin
case(ir[4])
1'b0: sximm5reg = {11'b0,ir[4:0]};   //positive, extend with 0
1'b1: sximm5reg = {11'b11111111111,ir[4:0]};   //negative, extend with 1
endcase
case(ir[7])
1'b0: sximm8reg = {8'b0,ir[7:0]};
1'b1: sximm8reg = {8'b11111111,ir[7:0]};
endcase
case(reg_sel)
2'b00: muxout = ir[2:0];  //Rm
2'b01: muxout = ir[7:5];  //Rd
2'b10: muxout = ir[10:8]; //Rn
default: muxout = 3'b000;  //default case, do NOT input
endcase
end

endmodule: idecoder






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


module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z, output N, output V);
wire [15:0] sumdiff;
reg addsub;

reg [15:0] output_reg;
assign ALU_out = output_reg;
wire [15:0] output_reg_wire;
assign output_reg_wire = output_reg;
reg Zreg;
assign Z = Zreg;
reg Nreg;
assign N = Nreg;
reg Vreg;
assign V = Vreg;

wire overflow;    //overflow and underflow wires for future use
wire underflow;

always_comb begin
case(ALU_op)              
2'b00: addsub = 1'b0;             //opcode 00 generates addsub input 0, opcode 01 generates addsub input 1
2'b01: addsub = 1'b1;
default: addsub = 1'b0;
endcase

case(ALU_op) //00: add, 01: subtract, 10: bitwise AND, 11: bitwise NOT
2'b10: output_reg = val_A & val_B;  //opcodes 00 and 01 both use output of add_or_subtract module, opcodes 10 and 11 have their own outputs
2'b11: output_reg = ~val_B;
default: output_reg = sumdiff;
endcase

case(output_reg_wire)    //Z is 1 if ALU output is all 0, else Z is 0
16'b0: Zreg = 1'b1;
default: Zreg = 1'b0;
endcase

case(output_reg_wire[15]) //N is 1 if ALU output is negative (if output[15] is 1)
1'b1: Nreg = 1'b1;
default: Nreg = 1'b0;
endcase

case({overflow,underflow}) //V is 1 if ALU output has overflow OR underflow, 0 if neither
2'b00: Vreg = 1'b0;
default: Vreg = 1'b1;
endcase
end

add_or_subtract arithmetic (.a(val_A),
			    .b(val_B),
		            .addsub(addsub),
			    .sum(sumdiff),
			    .overflow(overflow),
			    .underflow(underflow));
 
endmodule: ALU

module full_adder(input a, input b, input cin, output cout, output sum);
reg cout_reg;
reg sum_reg;
assign cout = cout_reg;
assign sum = sum_reg;

always_comb begin
case({a,b,cin})
3'b110: cout_reg = 1'b1;
3'b011: cout_reg = 1'b1;
3'b101: cout_reg = 1'b1;
3'b111: cout_reg = 1'b1;
default: cout_reg = 1'b0;
endcase

case({a,b,cin})
3'b100: sum_reg = 1'b1;
3'b010: sum_reg = 1'b1;
3'b001: sum_reg = 1'b1;
3'b111: sum_reg = 1'b1;
default: sum_reg = 1'b0;
endcase
end

endmodule: full_adder
module add_or_subtract(input [15:0] a, input [15:0] b, input addsub, output [15:0] sum, output overflow, output underflow);

wire [15:0] carry;
reg overflowreg;
assign overflow = overflowreg;
reg underflowreg;
assign underflow = underflowreg;

reg [15:0] negate;
wire [15:0] negatewire;
assign negatewire = negate;

reg [15:0] b_new;           //register for storing positive b or negative b (two's comp)
assign b_new = b^negatewire;
wire [15:0] b_new_wire;
assign b_new_wire = b_new;  //use b_new_wire as input for b in adder

always_comb begin    //converts input 'addsub' to 16'b0 or 16'b1 
case(addsub)
1'b0: negate = 16'b0;
1'b1: negate = 16'b1111111111111111;
endcase

case({a[15],b_new_wire[15],carry[14],carry[15]}) //overflow 
4'b0010: overflowreg = 1'b1;
default: overflowreg = 1'b0;
endcase

case({a[15],b_new_wire[15],carry[14],carry[15]}) //underflow
4'b1101: underflowreg = 1'b1;
default: underflowreg = 1'b0;
endcase
end

full_adder bit0 (.a(a[0]),
		 .b(b_new_wire[0]),
		 .cin(addsub),
		 .cout(carry[0]),
		 .sum(sum[0]));

full_adder bit1 (.a(a[1]),
		 .b(b_new_wire[1]),
		 .cin(carry[0]),
		 .cout(carry[1]),
		 .sum(sum[1]));

full_adder bit2 (.a(a[2]),
		 .b(b_new_wire[2]),
		 .cin(carry[1]),
		 .cout(carry[2]),
		 .sum(sum[2]));

full_adder bit3 (.a(a[3]),
		 .b(b_new_wire[3]),
		 .cin(carry[2]),
		 .cout(carry[3]),
		 .sum(sum[3]));

full_adder bit4 (.a(a[4]),
		 .b(b_new_wire[4]),
		 .cin(carry[3]),
		 .cout(carry[4]),
		 .sum(sum[4]));

full_adder bit5 (.a(a[5]),
		 .b(b_new_wire[5]),
		 .cin(carry[4]),
		 .cout(carry[5]),
		 .sum(sum[5]));

full_adder bit6 (.a(a[6]),
		 .b(b_new_wire[6]),
		 .cin(carry[5]),
		 .cout(carry[6]),
		 .sum(sum[6]));

full_adder bit7 (.a(a[7]),
		 .b(b_new_wire[7]),
		 .cin(carry[6]),
		 .cout(carry[7]),
		 .sum(sum[7]));

full_adder bit8 (.a(a[8]),
		 .b(b_new_wire[8]),
		 .cin(carry[7]),
		 .cout(carry[8]),
		 .sum(sum[8]));

full_adder bit9 (.a(a[9]),
		 .b(b_new_wire[9]),
		 .cin(carry[8]),
		 .cout(carry[9]),
		 .sum(sum[9]));

full_adder bit10 (.a(a[10]),
		 .b(b_new_wire[10]),
		 .cin(carry[9]),
		 .cout(carry[10]),
		 .sum(sum[10]));

full_adder bit11 (.a(a[11]),
		 .b(b_new_wire[11]),
		 .cin(carry[10]),
		 .cout(carry[11]),
		 .sum(sum[11]));

full_adder bit12 (.a(a[12]),
		 .b(b_new_wire[12]),
		 .cin(carry[11]),
		 .cout(carry[12]),
		 .sum(sum[12]));

full_adder bit13 (.a(a[13]),
		 .b(b_new_wire[13]),
		 .cin(carry[12]),
		 .cout(carry[13]),
		 .sum(sum[13]));

full_adder bit14 (.a(a[14]),
		 .b(b_new_wire[14]),
		 .cin(carry[13]),
		 .cout(carry[14]),
		 .sum(sum[14]));

full_adder bit15 (.a(a[15]),
		 .b(b_new_wire[15]),
		 .cin(carry[14]),
		 .cout(carry[15]),
		 .sum(sum[15]));

endmodule: add_or_subtract


module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);

always_comb begin
case(shift_op)
2'b00: shift_out = shift_in;           //no shift
2'b01: shift_out = {shift_in[14:0],      //left shift, LSB = 0
			1'b0};
2'b10: shift_out = {1'b0,             //logical right shift, MSB = 0
		    shift_in[15:1]};
2'b11: shift_out = {shift_in[15],     //arithmetic right shift, MSB = original shift_in[15]
		    shift_in[15:1]};


endcase
end

endmodule: shifter
