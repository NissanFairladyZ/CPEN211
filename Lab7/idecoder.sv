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
