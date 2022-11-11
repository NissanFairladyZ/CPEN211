module tb_shifter(output err);
  reg [15:0] shift_in;
  reg [1:0] shift_op;
  wire [15:0] shift_out;

reg err_reg;
assign err = err_reg;

shifter test_shifter (.shift_in(shift_in),
			.shift_op(shift_op),
			.shift_out(shift_out));

initial begin

err_reg = 1'b0; //initialize err as 0

shift_in = 16'b1111000011110000;
shift_op = 2'b00;

#1;

if(shift_out != shift_in) begin
$display("Error: shift_out %b doesn't match the non-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for non-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b01;

#1;

if(shift_out != 16'b1110000111100000) begin
$display("Error: shift_out %b doesn't match the left-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for left-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b10;

#1;

if(shift_out != 16'b0111100001111000) begin
$display("Error: shift_out %b doesn't match the logical right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for logical right-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b11;

#1;

if(shift_out != 16'b1111100001111000) begin
$display("Error: shift_out %b doesn't match the arithmetic right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for arithmetic right-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_in = 16'b0111000011110000;

#1;

if(shift_out != 16'b0011100001111000) begin
$display("Error: shift_out %b doesn't match the arithmetic right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for arithmetic right-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_in = 16'b1111111111111111;
shift_op = 2'b00;

#1;

if(shift_out != shift_in) begin
$display("Error: shift_out %b doesn't match the non-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for non-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b01;

#1;

if(shift_out != 16'b1111111111111110) begin
$display("Error: shift_out %b doesn't match the left-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for left-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b10;

#1;

if(shift_out != 16'b0111111111111111) begin
$display("Error: shift_out %b doesn't match the logical right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for logical right-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_op = 2'b11;

#1;

if(shift_out != 16'b1111111111111111) begin
$display("Error: shift_out %b doesn't match the arithmetic right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for arithmetic right-shifted shift_in %b is correct", shift_out, shift_in);
end

#1;

shift_in = 16'b0111111111111111;

#1;

if(shift_out != 16'b0011111111111111) begin
$display("Error: shift_out %b doesn't match the arithmetic right-shifted shift_in %b", shift_out, shift_in);
err_reg = 1'b1;
end
else begin
$display("shift_out %b for arithmetic right-shifted shift_in %b is correct", shift_out, shift_in);
end

end

endmodule: tb_shifter
