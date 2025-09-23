// Wava Chan
// wchan@g.hmc.edu 
// Sept. 15, 2025
// Testing of top-level module of Lab 3, lab3_wc.sv

`timescale 1ns/1ps

module lab3_testbench();

	
	// DUT inputs
    logic [3:0] columns;
    logic reset;

    // DUT outputs
    logic [3:0] rows, value1, value2, debounced_col;
    logic [6:0] seg_out;
    logic [1:0] anodes;
	logic enable;

    // Replace HSOSC with a TB-generated clock
    logic tb_clk;

    // Instantiate DUT
    lab3_wc dut(.columns(columns), .reset(reset), .rows(rows), .seg_out(seg_out), .anodes(anodes));

    // ------------------------------------------------
    // Clock generation: 10 ns period = 100 MHz
    // ------------------------------------------------
    initial tb_clk = 0;
    always #5 tb_clk = ~tb_clk;  

    // Force the DUT’s oscillator to use TB clock
    initial begin
        force dut.int_osc = tb_clk;
    end

    initial begin

		enable = dut.enable;
		value1 = dut.value1;
		value2 = dut.value2;
		debounced_col = dut.debounced_col;

        // Initialize
        reset = 1;
        columns = 4'b1111; // no key pressed
        repeat (5) @(posedge tb_clk);
        reset = 0;

        // Case 1: simulate pressing column 0
        $display("Press key at column[0]");
        columns = 4'b1110;  // column
        repeat (50) @(posedge tb_clk);
        columns = 4'b1111;  // release
        repeat (50) @(posedge tb_clk);

        // Case 2: simulate pressing column 2
        $display("Press key at column[2]");
        columns = 4'b1011;  // column 2 active
        repeat (50) @(posedge tb_clk);
        columns = 4'b1111;  // release
        repeat (50) @(posedge tb_clk);

        // Done
        $display("Simulation complete.");
        $finish;
    end
	
endmodule 