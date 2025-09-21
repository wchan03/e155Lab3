// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// Top level module of TODO: FINISH THIS

module lab3_wc(input logic [3:0] columns,
                input logic reset, //button reset on board
                output logic [3:0] rows,
                output logic [6:0] seg_out, 
				output logic [1:0] anodes); 

    logic int_osc;
    logic enable; //FIGURE THESE TWO OUT
    logic [3:0] value1, value2, new_value;
    


    // Set up clock 
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))  //48MHz.TODO: is this too fast for my keypad?
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));



    //synchronizer: 2 flip flops to sync input signal 
    // TODO: is this too complex? should i be testing this separately?
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

    //logic signal_receieved;
    //signal_receieved <= ~(data[0] & data[1] & data[2] & data[3]); //TODO: correct syntax?

    // scanning TODO: different clock?
    scanner scannerFSM(.clk(int_osc), .reset(reset), .columns(columns), .rows(rows), .value(new_value)); 


    // switch values
    assign value2 = value1;
    assign value1 = new_value; 

    // Write to the display
    seg_disp_write sdw(.value1(value1), .value(value2), .clk(int_osc), .seg_out(seg_out), .anodes(anodes));


endmodule 