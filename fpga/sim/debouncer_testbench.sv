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
	logic [3:0] columns, sig_expected; 

	// test signal? 
	
	
	//generate clock w/ period of 10 timesteps
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// instantiate DUT 
	debouncer dut(.clk(clk), .reset(reset), .sig_in(columns), .key_pressed(key_pressed), .sig_out(sig_expected));
	
	//run tests
	initial 
		begin 
			// pulse reset 
			reset = 0; 
			#10;
			reset = 1;
			#10;
			reset = 0;
			//#10;
			
			#20
			columns <= 4'b0001;
			//expected output
			assert(sig_expected==4'b0001;) else $error("no dice");
			
			#20
			columns <= 4'b0010;
			assert(sig_expected==4'b0010;) else $error("no dice");
			
			#20
			columns <=4'b0100
			assert(sig_expected==4'b0100;) else $error("no dice");
			
			#20
			columns <= 4'b1000;
			assert(sig_expected==4'b1000;) else $error("no dice");
			
			
		end
	
endmodule 