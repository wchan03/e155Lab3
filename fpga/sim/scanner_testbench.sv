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
			#5;
			reset = 1;
			#5;
			reset = 0;
			//#10;
			
			//series of inputs? 
			columns <= 4'b0000; //TODO: should all columns be LOW or HIGH?
			assert(rows == 4'b1000) else $error("rows being written wrong");
			assert(dut.state == ROW1) else $error("wrong state, %b", dut.state); 
			#10
			assert(rows == 4'b0100) else $error("wrong state");	
			#10 //is this one clock cycle?
			assert(rows == 4'b0010) else $error("wrong state");
			#10
			assert(rows == 4'b0001) else $error("wrong state");
			#10
			//should be back to row1 by now
			//test when there IS a column input
			columns <=4'b1000; //TODO: should this be written in the previous clock cycle?
			assert(dut.state == R1P) else $error("wrong state");
			assert(rows == 4'b1000) else $error("wrong state");
			assert(value == 4'b1010) else $error("incorrect output %b", value);
			
			#10 //another clock cycle
			columns <= 4'b0000;
			assert(rows == 4'b1000) else $error("wrong");
			assert(dut.state == ROW1) else $error("wrong state");

			#10
			columns <= 4'b0100; //should be at row 2, column 2
			assert(rows == 4'b0100);

			#10
			assert(dut.state == R2P) else $error("wrong state");
			assert(value == 4'b0101) else $error("wrong value %b", value);

			#10
			columns <= 4'b0000; //columns back to being off 
			// state = row2
			
			#10
			columns <=4'b0010;
			assert(dut.state == ROW3) else $error("wrong state");

			#10 
			assert(dut.state == R3P) else $error("wrong state");
			assert(value == 4'b1001) else $error("wrong value %b", value);

			#10
			columns <=4'b0000; //button unpressed
			assert(dut.state == ROW3) else $error("wrong state");

			#10 
			columns <44'b0001;
			assert(dut.state == ROW4) else $error("wrong state");
			
			#10
			assert(dut.state == R4P) else $error("wrong state");
			//TODO: assert values? i fear it is going to take a longer clock cycle bc of the 2nd fsm

			#40
			assert(value == 4'b1101) else $error("wrong value %b", value);

			
			
		end
	
endmodule 
	