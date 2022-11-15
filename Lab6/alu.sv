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
