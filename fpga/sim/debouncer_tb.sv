`timescale 1ns/1ps

module debouncer_tb();

    // DUT inputs
    logic clk;
    logic reset;
    logic [3:0] sig_in;
    logic key_pressed;

    // DUT outputs
    logic [3:0] sig_out;

    // Instantiate DUT
    debouncer dut (
        .clk(clk),
        .reset(reset),
        .sig_in(sig_in),
        .key_pressed(key_pressed),
        .sig_out(sig_out)
    );

    // ------------------------
    // Clock generation: 10 ns period = 100 MHz
    // ------------------------
    initial clk = 0;
    always #5 clk = ~clk;  

    // ------------------------
    // Override counter_done for simulation
    // (this replaces the 960000 cycle wait with 20 cycles)
    // ------------------------
    // force is a testbench trick: it overrides internal nets
    initial begin
        force dut.counter_done = (dut.counter == 20);
    end

    // ------------------------
    // Stimulus
    // ------------------------
    initial begin
        // Dump waves if using a simulator with VCD
        $dumpfile("debouncer_tb.vcd");
        $dumpvars(0, debouncer_tb);

        // Initialize
        reset = 1;
        sig_in = 4'b0000;
        key_pressed = 0;
        @(posedge clk);
        reset = 0;

        // Case 1: simulate a clean press
        $display("Test 1: clean key press");
        sig_in = 4'b1010;
        key_pressed = 1;
        repeat(40) @(posedge clk);  // hold long enough to debounce
        key_pressed = 0;
        repeat(40) @(posedge clk);

        // Case 2: simulate bouncing input
        $display("Test 2: bouncing input");
        sig_in = 4'b0101;
        key_pressed = 1; @(posedge clk);
        key_pressed = 0; @(posedge clk);
        key_pressed = 1; @(posedge clk);
        key_pressed = 0; @(posedge clk);
        key_pressed = 1;
        repeat(40) @(posedge clk);  // eventually stable
        key_pressed = 0;
        repeat(40) @(posedge clk);

        // Finish
        $display("Simulation complete");
        $finish;
    end

endmodule
