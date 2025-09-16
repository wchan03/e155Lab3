// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of scanner FSM for Lab 3

`timescale 1ns/1ps

module scanner_testbench();
	
	// what does a working scanner look like? filters out quick oscillations 
	
	// set up all necessary logic 
	logic clk, reset, key_pressed;
	logic [3:0] columns, sig_expected; 

	// test signal? 
	
	
	//generate clock w/ period of 10 timesteps
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// instantiate DUT 
	scanner dut(.clk(clk), .reset(reset), .columns(columns), .row(rows), .key_pressed(key_pressed), .value(value));
	
	initial 
		begin 
			// pulse reset 
			reset = 0; 
			#10;
			reset = 1;
			#10;
			reset = 0;
			//#10;
			
			//series of inputs? 
			columns <= 4'b0000;
			assert(rows == 4'b1000); else $error("wrong state");
			#5
			assert(rows == 4'b0100); else $error("wrong state");	
			#5 //is this one clock cycle?
			assert(rows == 4'b0010); else $error("wrong state");
			#5
			assert(rows == 4'b0001); else $error("wrong state");
			#5
			//should be back to row1 by now
			//test when there IS a column input
			columns <=4'b1000;
			assert(rows == 4'b1000); else $error("wrong state");
			assert(value == 4'b1010); else $error("incorrect output %b", key_pressed);
			
			#5 //another clock 
			
		end
	
endmodule 
	