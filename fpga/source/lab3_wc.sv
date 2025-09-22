// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// Top level module of E155 Lab 3-- 4x4 keyboard processing

module lab3_wc(input logic [3:0] columns,
                input logic reset, //button reset on board
                output logic [3:0] rows,
                output logic [6:0] seg_out, 
				output logic [1:0] anodes); 

    logic int_osc;
    logic enable;
    logic [3:0] value1, value2, new_value;


    // Set up clock 
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))  //48MHz
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    //synchronizer: 2 flip flops to sync input signal 
    // TODO: is this too complex? should i be testing this separately?
    logic [3:0] q1, d1, q2, data;
    //assign d1 = columns;
    always_ff @(posedge int_osc, reset) begin 
        if(reset) begin 
                  q1 <= 4'b0000;
                  q2 <= 4'b0000;
        end
        else if(enable) begin 
             q1 <= columns;
             q2 <= q1;
        end
        else begin
            q1 <= q1;
            q2 <= q2;
        end
        data <= q2;
    end

    // scanning TODO: different clock?
    scanner scannerFSM(.clk(int_osc), .reset(reset), .columns(columns), .rows(rows), .value(new_value)); 

    // switch values
    //TODO: should I be doing this every clock cycle?
    //only do this if a button was pressed and a value was changed. add an enable to the scanner
    assign value2 = value1;
    assign value1 = new_value; 

    // Write to the display
    seg_disp_write sdw(.value1(value1), .value2(value2), .clk(int_osc), .seg_out(seg_out), .anodes(anodes));

    //right  now: flashing super quick, unless a button is pressed, in which case both disp show the same value
    // only permits 7, 4, 1, and E. AKA-- only depends on the row, so just whatever stage it happens to be in at that moment

	//when using flip flop instead of inside FSM to apply logic, only showing C (and 1 when reset is presse/held)
	//no longer responding to key presses
	


endmodule 