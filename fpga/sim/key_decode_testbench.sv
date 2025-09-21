// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of key_decoder module for Lab 3

//`timescale 1ns/1ps


module key_decode_testbench();
	
	// set up all necessary logic 
	logic [3:0] r, c, value;
	integer errors, test_count;
	logic clk;

	
	//generate clock
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end

	// instantiate DUT 
	key_decode dut(r, c, value);
	
	//run tests
	initial begin 
		test_count = 0;
		errors = 0;
		// row 1 hot. TODO: doublecheck this syntax
		r = 4'b1000; #10; c = 4'b0001; #10; assert(value == 4'b0001)
										else begin 
											$error("failed input %b %b with output %b", r, c, value);
											errors <= errors + 1;
										end
		test_count = test_count + 1; 
		c = ~4'b1101; #10; 	assert(value == 4'b0010)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = ~4'b1011; #10; 	assert(value == 4'b0011)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = ~4'b0111; #10; 	assert(value == 4'b1010)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		// row 2 hot
		r = 4'b0100; c =~4'b1110; #10; assert(value == 4'b0100)
										else begin 
												$error("failed input %b %b with output %b", r, c, value);
												errors = errors + 1;
											end
		test_count = test_count + 1; 
		c = ~4'b1101; #10; 	assert(value == 4'b0101)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = ~4'b1011; #10; 	assert(value == 4'b0110)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = ~4'b0111; #10; 	assert(value == 4'b1011)
							else begin 
									$error("failed input %b %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		//row 3 hot
		r = 4'b0010; c = ~4'b1110; #10; assert(value == 4'b0111)
										else begin 
											$error("failed input %b %b with output %b", r, c, value);
											errors = errors + 1;
										end
		test_count = test_count + 1; 
		c = 4'b0010; #10; 	assert(value == 4'b1000)
							else begin 
									$error("failed input r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = 4'b0100; #10; 	assert(value == 4'b1001)
							else begin 
									$error("failed input  r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = 4'b1000; #10; 	assert(value == 4'b1100)
							else begin 
									$error("failed input  r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 						
		//row 4 hot
		r = 4'b0001; c = 4'b0001; #10; assert(value == 4'b1110)
										else begin 
												$error("failed input r = %b  and c = %b with output %b", r, c, value);
												errors = errors + 1;
											end
		test_count = test_count + 1; 
		c = 4'b0010; #10; 	assert(value == 4'b0000)
							else begin 
									$error("failed input  r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = 4'b0100; #10; 	assert(value == 4'b1111)
							else begin 
									$error("failed input  r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		c = 4'b1000; #10; 	assert(value == 4'b1101)
							else begin 
									$error("failed input r = %b  and c = %b with output %b", r, c, value);
									errors = errors + 1;
								end
		test_count = test_count + 1; 
		
		$display("%d tests completed with %d errors", test_count, errors); //16 tests, 0 errors

		//$finish;
	end
	
endmodule 