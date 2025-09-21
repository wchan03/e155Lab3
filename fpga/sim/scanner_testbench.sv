// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of scanner FSM for Lab 3

`timescale 1ns/1ps

module scanner_testbench();
	
	// set up all necessary logic 
	logic clk, reset, key_pressed;
	logic [3:0] columns, rows, value;
	integer errors, tests;

	// set up test task frameworks
	task row_test(input logic [3:0] r,  exp_r);
		assert (r == exp_r)
		else begin 
			$error("rows being written wrong, expected %b, recieved %b", exp_r, r);
			errors = errors + 1;
		end
		tests = tests + 1;
	endtask

	task state_test(input logic exp_state);
		assert(dut.state == exp_state) 
		else begin 
			$error("wrong state, %b", dut.state); 
			errors = errors + 1;
		end 
		tests = tests + 1;
	endtask
	
	
	//generate clock w/ period of 10 timesteps
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// instantiate DUT 
	scanner dut(.clk(clk), .reset(reset), .columns(columns), .rows(rows), .value(value));
	
	initial 
		begin 

			// pulse reset 
			reset = 0; 
			#10;
			reset = 1;
			#10;
			reset = 0;
			//#10
			//set up counters
			tests = 0;
			errors = 0;

			//state enumeration: ROW1 = 0, R1P = 1, ROW2 = 3, R2P = 4, etc. 
			columns = 4'b1111; 
			row_test(rows, 4'b1000);
			state_test(0); //ROW1
			#10;
			row_test(rows, 4'b0100);
			#10;
			row_test(rows, 4'b0010);
			#10;
			row_test(rows, 4'b0001);
			#10;

			//should be back to row1 by now
			row_test(rows, 4'b1000);
			state_test(0); 

			#10;
			//test when there IS a column input

			columns = 4'b0111; //TODO: should this be written in the previous clock cycle?
			#10; // wait for state transition to RP1

			state_test(1); //worried about this one
			row_test(rows, 4'b1000);

			#40; //wait for key decode and debouncer to work
			assert(value == 4'b1010) else $error("incorrect output %b", value);
			state_test(1); //R1P = 1
			
			columns = 4'b1111; //release key and wait

			#10;

			columns = 4'b1011; // test that next column works

			#10;
			
			row_test(rows, 4'b0100);
			state_test(2); //ROW2 = 2

			#40; 
			assert(value == 4'b0101) else $error("incorrect output %b", value);
			state_test(3); //R2P = 3

			columns = 4'b1111;

			#10;

			// test that 3rd column works
			columns = 4'b1101;

			#10;
			
			row_test(rows, 4'b0010);
			state_test(4); //ROW3 = 4

			#40; 
			assert(value == 4'b1001) else $error("incorrect output %b", value);
			state_test(5); //R3P = 5;

			columns = 4'b1111;

			#10;

			// test that 4th column works
			columns = 4'b1110;
			#10;
			
			row_test(rows, 4'b0010);
			state_test(6); //ROW4 = 6

			#40; 
			assert(value == 4'b1101) else $error("incorrect output %b", value);
			state_test(7); //R4P = 7

			$display("%d tests completed with %d errors", tests, errors);
		
		end
	
endmodule 
	