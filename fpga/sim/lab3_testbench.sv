// Wava Chan
// wchan@g.hmc.edu 
// Sept. 15, 2025
// Testing of top-level module of Lab 3, lab3_wc.sv

`timescale 1ns/1ps

module lab3_testbench();

	
	// what exactly am i testing here?
	// what does a working top module look like?
	
	// set up all necessary logic 
	//logic clk, reset, key_pressed;
	logic [3:0] columns, rows; 
    logic [6:0] seg_out;
    logic [1:0] anodes;

	// test signal? 
	
	
	//generate clock w/ period of 10 timesteps
	always 
		begin 
			clk = 1; #5; clk = 0; #5;
		end
	
	// instantiate DUT 
	lab3_wc dut(.columns(columns), .rows(rows), .seg_out(seg_out), .anodes(anodes));
	
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
			
			#10
			columns <= 4'b0001; //what am i testing here ;-;
			//expected output
			assert(sig_expected==4'b0001;) else $error("no dice");
			
			#10
			columns <= 4'b0010;
			assert(sig_expected==4'b0010;) else $error("no dice");
			
			#10
			columns <=4'b0100
			assert(sig_expected==4'b0100;) else $error("no dice");
			
			#10
			columns <= 4'b1000;
			assert(sig_expected==4'b1000;) else $error("no dice");
			
			
		end
	
endmodule 