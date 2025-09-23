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
    logic [3:0] debounced_col;


    // Set up clock 
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))  //48MHz
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		
	//TODO: clock divider to accept the signal slower

    //synchronizer: 2 flip flops to sync input signal 

    logic [3:0] sync_1, sync_2, sync_col;

    always_ff @(posedge int_osc or posedge reset) begin 
        if(reset) begin 
                  sync_1 <= 4'b1111;
                  sync_2 <= 4'b1111;
        end
        else begin 
             sync_1 <= columns;
             sync_2 <= sync_1;
        end
    end

    //use syncronized data 
    assign sync_col = sync_2;

    // scanning TODO: different (slower)does t clock?
    scanner scannerFSM(.clk(int_osc), .reset(reset), .columns(sync_col), .rows(rows), .debounced_col(debounced_col), .enable(enable)); 


    //decode value from row and column value
    key_decode kd(rows, ~debounced_col, new_value); //~debounced_value because of the logic in key_decode    // switch values
    
    always_ff @(posedge int_osc) begin
        if (reset) begin
            value1 <= 4'b0100;
            value2 <= 4'b0001;
        end
        else begin
            if(enable) begin //only update when a new value is recieved
                value2 <= value1;
                value1 <= new_value;
            end
        end
    end

    // Write to the display
    seg_disp_write sdw(.value1(value1), .value2(value2), .clk(int_osc), .seg_out(seg_out), .anodes(anodes));

endmodule 