// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testbench for debouncer module

`timescale 1ns/1ps

module debouncer_tb_2();
   
  // Signal declarations
    logic clk, reset, key_pressed;
    logic [3:0] sig_in, sig_out;
    integer test_count, errors;
   
    // Generate slower clock for practical simulation (1MHz instead of 48MHz)
    always begin
        clk = 1; #500; clk = 0; #500;  // 1MHz clock for faster simulation
    end
   
    // Instantiate DUT
    debouncer dut(
        .clk(clk),
        .reset(reset),
        .sig_in(sig_in),
        .key_pressed(key_pressed),
        .sig_out(sig_out)
    );
   
    // Override the counter_done for simulation (MUCH shorter time)
    // For 1MHz clock, 20 cycles = 20μs instead of 20ms
    //assign dut.counter_done = (dut.counter == 20);
   
    // Test task
    task test_debounce(input logic [3:0] test_sig, input logic test_press,
                       input integer press_cycles, input integer release_cycles,
                       input logic [3:0] expected, string test_name);
        begin
            sig_in = test_sig;
            key_pressed = test_press;
           
            // Wait for specified number of clock cycles
            repeat(press_cycles) @(posedge clk);
           
            if (test_press) begin
                key_pressed = 0;
                repeat(release_cycles) @(posedge clk);
            end
           
            // Check output after allowing for debounce time
            repeat(5) @(posedge clk);
           
            if (sig_out !== expected) begin
                $error("FAIL: %s - Expected %b, Got %b", test_name, expected, sig_out);
                errors = errors + 1;
            end else begin
                $display("PASS: %s - Output %b", test_name, sig_out);
            end
            test_count = test_count + 1;
        end
    endtask
   
    // Run tests
    initial begin
        // Initialize
        errors = 0;
        test_count = 0;
        reset = 1;
        sig_in = 4'b0000;
        key_pressed = 0;
       
        $display("Starting debouncer tests with faster simulation timing...");
        #1000;
       
        // Reset
        $display("\n=== Test 1: Reset ===");
        reset = 0; #1000;
        reset = 1; #1000;
       
        // Test 2: Short glitch (should be filtered out)
        $display("\n=== Test 2: Short glitch filtering ===");
        test_debounce(4'b0001, 1, 5, 5, 4'b0000, "Short glitch filtered");
       
        // Test 3: Valid key press (long enough to debounce)
        $display("\n=== Test 3: Valid key press ===");
        test_debounce(4'b0010, 1, 30, 30, 4'b0010, "Valid key press");
       
        // Test 4: Multiple quick presses
        $display("\n=== Test 4: Multiple quick presses ===");
        test_debounce(4'b0100, 1, 5, 5, 4'b0000, "Quick press 1 filtered");
        #1000;
        test_debounce(4'b0101, 1, 5, 5, 4'b0000, "Quick press 2 filtered");
        #1000;
        test_debounce(4'b0110, 1, 5, 5, 4'b0000, "Quick press 3 filtered");
       
        // Test 5: Edge case - exactly at debounce threshold
        $display("\n=== Test 5: Edge case ===");
        test_debounce(4'b1000, 1, 19, 19, 4'b0000, "Just below threshold");
        #1000;
        test_debounce(4'b1001, 1, 21, 21, 4'b1001, "Just above threshold");
       
        // Summary
        $display("\n=== TEST SUMMARY ===");
        $display("Tests completed: %0d", test_count);
        $display("Errors: %0d", errors);
       
        if (errors == 0) begin
            $display("✅ ALL DEBOUNCER TESTS PASSED!");
        end else begin
            $display("❌ %0d TESTS FAILED!", errors);
        end
       
        #5000;
        $finish;
    end
   
    // Monitor to track behavior
    initial begin
        $monitor("Time %0tns: state=%0d, counter=%0d, key_pressed=%b, sig_out=%b",
                 $time, dut.state.name(), dut.counter, key_pressed, sig_out);
    end
   
endmodule
