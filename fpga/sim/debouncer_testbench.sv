// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testbench for debouncer module

`timescale 1ns/1ps
// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of Lab 3 for E155

`timescale 1ns/1ps

module debouncer_testbench();
	
	// what exactly am i testing here?
	// what does a working debouncer look like? filters out quick oscillations 
	
	// set up all necessary logic 
	logic clk, reset, key_pressed;
	logic [3:0] columns, sig_out; 
	integer tests, errors;

	// test signal? 
	
	
	//generate clock w/ period of 10 timesteps
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// instantiate DUT 
	debouncer dut(.clk(clk), .reset(reset), .sig_in(columns), .key_pressed(key_pressed), .sig_out(sig_out));
	
	// Override the counter_done for simulation (MUCH shorter time)
    // For 1MHz clock, 20 cycles = 20μs instead of 20ms
    assign dut.counter_done = (dut.counter == 20);


	task test_db(input logic [3:0] test_col);
		begin
			//pulse key_pressed
			#400; key_pressed = 0; #400; key_pressed = 1; columns = test_col; #400;
			assert(sig_out == test_col)
			else begin
				$error("no dice. expected output = %b & actual output = %b", test_col, sig_out);
				errors = errors + 1;
			end
			tests = tests + 1;
		end

	endtask
	//run tests
	initial 
		begin 
			// pulse reset 
			reset = 0; 
			#100;
			reset = 1;
			#100;
			reset = 0;
			//#10;

			//set up counters
			tests = 0;
			errors = 0;
			
			#400;

			test_db(4'b0001);
			test_db(4'b0010);
			test_db(4'b0100);
			test_db(4'b1000);

			#400;
			
			$display("%d tests completed with %d errors", tests, errors);
			
		end

endmodule 