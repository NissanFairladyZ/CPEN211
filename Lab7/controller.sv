module controller(input clk, input rst_n,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B,
		output ram_w_en,
		output sel_addr,
		output load_pc,
		output clear_pc,
		output load_addr,
		output load_ir);
  // your implementation here
//ram_w_en,sel_addr,load_pc,clear_pc,load_addr,load_ir

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
reg ram_w_en_reg;
assign ram_w_en = ram_w_en_reg;
reg sel_addr_reg;
assign sel_addr = sel_addr_reg;
reg load_pc_reg;
assign load_pc = load_pc_reg;
reg clear_pc_reg;
assign clear_pc = clear_pc_reg;
reg load_addr_reg;
assign load_addr= load_addr_reg;
reg load_ir_reg;
assign load_ir = load_ir_reg;



reg [5:0] state;             //current state reg
wire [5:0] statewire;
assign statewire = state;

reg waitingreg;                //waiting output reg
wire waiting;
assign waiting = waitingreg;

reg startreg;
wire start;
assign start = startreg;

reg [5:0] zeronext;              //output of zero-progression mux
wire [5:0] zeronextwire;
assign zeronextwire = zeronext;

reg [5:0] nonzeronext;           //output of non-zero-progression mux
wire [5:0] nonzeronextwire;
assign nonzeronextwire = nonzeronext;

reg [5:0] stateoutput;            //state update reg
wire [5:0] stateoutputwire;
assign stateoutputwire = stateoutput; 

always_comb begin
case(statewire)
6'b000000: waitingreg = 1'b1;
default: waitingreg = 1'b0;
endcase

case({start,opcode,ALU_op})     
6'b111010: zeronext = 6'b000001; //(MOV imm) (1st state cycle, state 1)
6'b111000: zeronext = 6'b000010; //(MOV)     (2nd state cycle, states 2-4)
6'b110111: zeronext = 6'b000010; //(MVN)
6'b110100: zeronext = 6'b000101; //(ADD)      (3rd state cycle, states 5-8)
6'b110110: zeronext = 6'b000101; //(AND)
6'b110101: zeronext = 6'b001001; //(CMP)       (4th state cycle, states 9-12)




default: zeronext = 6'b000000;   //          (remain at state 0 for invalid)
endcase

case(statewire)
6'b000001: nonzeronext = 6'b001110; //(end of 1st cycle)  (MOV imm)
6'b000010: nonzeronext = 6'b000011;
6'b000011: nonzeronext = 6'b000100;
6'b000100: nonzeronext = 6'b001110; //(end of 2nd cycle) (MOV, MVN)
6'b000101: nonzeronext = 6'b000110;
6'b000110: nonzeronext = 6'b000111;
6'b000111: nonzeronext = 6'b001000;
6'b001000: nonzeronext = 6'b001110; //(end of 3rd cycle)  (ADD, AND)
6'b001001: nonzeronext = 6'b001010;
6'b001010: nonzeronext = 6'b001011; 
6'b001011: nonzeronext = 6'b001100; 
6'b001100: nonzeronext = 6'b001110; //(end of 4th cycle)   (CMP)

6'b001101: nonzeronext = 6'b001111; // initial fetch state (resets here)
6'b001110: nonzeronext = 6'b001111; // subsequent fetch state (after every instruction
6'b001111: nonzeronext = 6'b010000;
6'b010000: nonzeronext = 6'b000000; // return to state 0 (return state)



default: nonzeronext = statewire;
endcase

case(statewire)
6'b000000: stateoutput = zeronextwire;
default: stateoutput = nonzeronextwire;
endcase
end


always_ff @(posedge clk) begin
case(rst_n) 
1'b0: state <= 6'b001101;
1'b1: state <= stateoutputwire;
endcase
  //new 17 bit outputs
  case(statewire) //instructions differ slightly from written notes due to debugging                           aabbcdefghijklmno
6'b000000: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000000000; //0

6'b000001: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b10101000000000000; //1

6'b000010: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b00000010000000000; //2
6'b000011: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01000001010000000; //3
6'b000100: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01001000010000000; //4

6'b000101: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b10000100000000000; //5
6'b000110: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b00000010000000000; //6
6'b000111: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b00000001000000000; //7
6'b001000: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01001000000000000; //8
																							      	
6'b001001: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b10000100000000000; //9
6'b001010: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b00000010000000000; //10
6'b001011: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b00000000100000000; //11  
6'b001100: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000000000; //12    

6'b001101: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000011100; //13 
6'b001110: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000011000; //14 
6'b001111: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000010000; //15 
6'b010000: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000010001; //16 

																				//ram_w_en,sel_addr,load_pc,clear_pc,load_addr,load_ir
			
default: {reg_sel_reg,wb_sel_reg,w_en_reg,en_A_reg,en_B_reg,en_C_reg,en_status_reg,sel_A_reg,sel_B_reg,ram_w_en_reg,sel_addr_reg,load_pc_reg,clear_pc_reg,load_addr_reg,load_ir_reg} <= 17'b01100000000000000;
endcase

startreg <= waiting;
end



endmodule: controller
