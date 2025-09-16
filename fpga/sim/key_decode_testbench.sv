// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of key_decoder module for Lab 3

//`timescale 1ns/1ps


module key_decode_testbench();
	
	// set up all necessary logic 
	logic [3:0] r, c, value;
	
	//generate clock
	
	// instantiate DUT 
	key_decode dut(r, c, value);
	
	//run tests
	initial begin 
		// row 1 hot. TODO: doublecheck this syntax
		r <= 4'b1000; c <=4'b0001; #1; assert(value == 4'b0001)
										else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0010; #1; 	assert(value == 4'b0010)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0100; #1; 	assert(value == 4'b0011)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b1000; #1; 	assert(value == 4'b1010)
							else $error("failed input %b %b with output %b", r, c, value);
		// row 2 hot
		r <= 4'b0100; c <=4'b0001; #1; assert(value == 4'b0100)
										else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0010; #1; 	assert(value == 4'b0101)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0100; #1; 	assert(value == 4'b0110)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b1000; #1; 	assert(value == 4'b1011)
							else $error("failed input %b %b with output %b", r, c, value);
		
		//row 3 hot
		r <= 4'b0010; c <=4'b0001; #1; assert(value == 4'b0111)
										else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0010; #1; 	assert(value == 4'b1000)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0100; #1; 	assert(value == 4'b1001)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b1000; #1; 	assert(value == 4'b1100)
							else $error("failed input %b %b with output %b", r, c, value);
								
		//row 4 hot
		r <= 4'b0001; c <=4'b0001; #1; assert(value == 4'b1110)
										else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0010; #1; 	assert(value == 4'b0000)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b0100; #1; 	assert(value == 4'b1111)
							else $error("failed input %b %b with output %b", r, c, value);
		c <= 4'b1000; #1; 	assert(value == 4'b1101)
							else $error("failed input %b %b with output %b", r, c, value);
		$finish;
	end
	
endmodule 