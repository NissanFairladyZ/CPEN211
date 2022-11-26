module task1(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);

wire [15:0] ram_r_data;
wire ram_w_en;
wire [7:0] ram_addr;
wire [15:0] ram_w_data;

cpu taskcpu(.clk(clk),
		.rst_n(rst_n),
		.start_pc(start_pc),
		.ram_r_data(ram_r_data),
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
