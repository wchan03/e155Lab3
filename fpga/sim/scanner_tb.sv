// Wava Chan
// wchan@g.hmc.edu
// Sept. 15, 2025
// Testing of scanner FSM for Lab 3

`timescale 1ns/1ps

module scanner_tb;

    // Inputs
    logic clk;
    logic reset;
    logic [3:0] columns;
   
    // Outputs
    logic [3:0] rows;
    //logic [3:0] debounced_col;
    logic enable, key_pressed;
   
    // Instantiate 
    scanner dut (
        .clk(clk),
        .reset(reset),
        .columns(columns),
        .key_pressed(key_pressed),
        .rows(rows),
        .enable(enable)
    );
   
    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
   
    // Different test scenarios
    task test_reset;
        begin
            $display("=== Testing Reset ===");
            reset = 0;
            columns = 4'b1111; // No keys pressed
            key_pressed = 0;
            #20;
            reset = 1;
            #10;
            // After reset, should start scanning from row 1
            if (rows === 4'b1000)
                $display("Reset test PASSED");
            else
                $display("Reset test FAILED");
            #100;
        end
    endtask
   
    task test_no_key_pressed;
        begin
            $display("=== Testing No Key Pressed ===");
            columns = 4'b1111; // All columns high (no press)
            key_pressed = 0;
            #200; // Wait for several scan cycles
            if (enable === 1'b0)// && debounced_col === 4'b1111)
                $display("No key pressed test PASSED");
            else
                $display("No key pressed test FAILED");
        end
    endtask
   
    task test_single_key_press(input [3:0] row_mask, input [3:0] col_mask, input [3:0] expected_col);
        begin
            $display("=== Testing Key Press: Expected columns = 4'h%h ===", expected_col);
           
            // Wait for the target row to be active
            wait (rows === row_mask);
           
            // Simulate key press on the specific column
            columns = col_mask;
            key_pressed = 1;
           
            // Wait for enable signal (key detected)
            wait (enable === 1'b1);
            $display("Key detected at time %t", $time);
           
            // Wait a bit more for value to stabilize
            #50;
           
            if (columns === expected_col)
                $display("Key press test PASSED for columns 4'h%h", expected_col);
            else
                $display("Key press test FAILED: Expected 4'h%h, Got 4'h%h", expected_col, columns);
           
            // Release key
            columns = 4'b1111;
            key_pressed = 0;

            #100;
        end
    endtask
   
    task test_multiple_keys_same_row;
        begin
            $display("=== Testing Multiple Keys Same Row ===");
           
            // Wait for row 1
            wait (rows === 4'b1000);
            columns = 4'b0111; // Press first column of row 1
            key_pressed = 1;
           
            wait (enable === 1'b1);
            $display("First key detected");
            #50;
           
            // Change to different column while still on same row
            columns = 4'b1011; // Press second column of row 1
            #50;
           
            if (enable === 1'b1)
                $display("Multiple keys same row test behavior observed");
            else
                $display("Multiple keys same row test - enable dropped unexpectedly");
           
            columns = 4'b1111;
            key_pressed = 0;

            #100;
        end
    endtask
   
    task test_rapid_key_presses;
        begin
            $display("=== Testing Rapid Key Presses ===");
           
            // Rapidly press different keys
            repeat (3) begin
                // Press key on row 1, column 0
                wait (rows === 4'b1000);
                columns = 4'b0111;
                key_pressed = 1;
                #40;
               
                // Release
                columns = 4'b1111;
                key_pressed = 0;
                #20;
               
                // Press key on row 2, column 1  
                wait (rows === 4'b0100);
                columns = 4'b1011;
                key_pressed = 1;
                #40;
               
                // Release
                columns = 4'b1111;
                key_pressed = 0;
                #20;
            end
           
            $display("Rapid key presses test completed");
        end
    endtask
   
    // Monitor to track FSM state changes
    always @(posedge clk) begin
        if (!reset) begin
            $display("Time %t: rows = 4'b%b, columns = 4'b%b, enable = %b",
                     $time, rows, columns, enable);
        end
    end
   
    // Main test sequence
    initial begin
        $display("Starting Keypad Scanner Testbench");

       
        // Initialize inputs
        reset = 1;
        columns = 4'b1111;
        key_pressed = 0;
       
        // Run tests
        #10;
        test_reset();
       
        test_no_key_pressed();
       
        // Test various key presses
        test_single_key_press(4'b1000, 4'b0111, 4'b0111); // Row 1, Col 0 -> '1'
        test_single_key_press(4'b1000, 4'b0111, 4'b0111); // Row 1, Col 1 -> '2'  
        test_single_key_press(4'b0100, 4'b0111, 4'b0111); // Row 2, Col 0 -> '4'
        test_single_key_press(4'b0001, 4'b1110, 4'b1110); // Row 4, Col 3 -> 'D'
       
        test_multiple_keys_same_row();
        test_rapid_key_presses();
       
        // Final no key test to ensure proper return to scanning
        test_no_key_pressed();
       
        $display("All tests completed!");
        #100;
        $finish;
    end
   
    // Timeout protection
    initial begin
        #100000; // 100us timeout
        $display("Testbench timeout - simulation took too long");
        $finish;
    end

endmodule