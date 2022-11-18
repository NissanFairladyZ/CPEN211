module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
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
6'b110101: zeronext = 4'b1001; //(CMP)       (4th state cycle, states 9-11)
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
4'b1011: nonzeronext = 4'b0000; //(end of 4th cycle)   (CMP)
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
default: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg} <= 11'b01100000000;
endcase
end



endmodule: controller
