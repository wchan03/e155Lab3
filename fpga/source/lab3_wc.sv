// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// Top level module of TODO: FINISH THIS

module lab3_wc(input logic [3:0] columns,
                output logic [3:0] rows,
                output logic [6:0] seg_out, 
				output logic [1:0] anodes); // Writing to the anodes

    logic int_osc;
    logic reset;
    logic enable; //FIGURE THESE TWO OUT
    logic [3:0] value1, value2, new_value;


    // Set up clock 
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));


    //synchronizer: 2 flip flops to sync input signal 

    logic [3:0] q1, d1, q2, data;
    assign q1 = columns;
    always_ff @(posedge int_osc, reset) begin 
        if(reset) begin 
                  q1 <= 4'b0000;
                  q2 <= 4'b0000;
        end
        else if(enable) begin 
             q1 <= d1;
             q2 <= q1;
        end
        else begin
            q1 <= q1;
            q2 <= q2;
        end
        assign data = q2;
    end

    logic signal_receieved;
    signal_receieved <= ~(data[0] & data[1] & data[2] & data[3]); //TODO: correct syntax?

    // scanning
    scanner scannerFSM(.clk(int_osc), .reset(reset), .columns(columns), .rows(rows), .key_pressed(signal_recieved), .value(new_value)); 

    //debouncing
	debouncer debounceFSM(.clk(clk), .reset(reset), .columns(sig_in), .key_pressed(signal_recieved), .sig_out(//TODO FINISH HERE! , .sig_recieved(FINSIH HERE!!));


    // switch values
    value2 <= value1;
    value1 <= new_value; //TODO: find new value

    // Write to the display
    seg_disp_write sdw(value1, value2, int_osc, seg_out, anodes);


endmodule 