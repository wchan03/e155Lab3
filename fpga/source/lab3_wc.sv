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
    logic clk;
    logic [7:0] value1, value2, new_value;
    logic [7:0] debounced_value;
    logic [7:0] total_val;


    // Set up clock 
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01))  //24MHz
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc)); //int_osc
		
	//clock divider to slow down input signal. EVERYTHING SHOULD RUN ON THIS CLOCK!
    clk_div ck(int_osc, clk); 


    //synchronizer: 2 flip flops to sync input signal 
    // TODO: sync reset???? would need another double flip flop
    
    logic [3:0] sync_1, sync_2, sync_col;
    /*
    always_ff @(posedge clk) begin 
        if(!reset) begin 
                  sync_1 <= 4'b1111;
                  sync_2 <= 4'b1111;
        end
        else begin 
             sync_1 <= columns;
             sync_2 <= sync_1;
        end
    end
    */
    always_ff @(posedge clk) begin //not transferring values??
        
             sync_1 <= columns;
             sync_2 <= sync_1;

    end

    //use syncronized data 
    assign sync_col = sync_2;
    

    assign key_pressed = (sync_col!= 4'b1111); //if any column is pressed
    //assign key_pressed = (columns != 4'b1111);

    //debouncer debounceFSM(.clk(clk), .reset(reset), .sig_in(sync_col),
    //                     .key_pressed(key_pressed), .sig_out(debounced_value));
    
    //logic debounced_key_pressed;
    //assign debounced_key_pressed = (debounced_value != 4'b1111);
    //do i want the debounced column into the scanner or the scanner into the debouncer?

    // scanning TODO: does enable work the way i want it to?
    scanner scannerFSM(.clk(clk), .reset(reset), .columns(sync_col), .key_pressed(key_pressed), //inputs
                        .rows(rows), .total_val(total_val));//, .enable(enable)); //outputs

    debouncer debounceFSM(.clk(clk), .reset(reset), .sig_in(total_val),
                         .key_pressed(key_pressed), .sig_out(debounced_value), .enable(enable));
   //.columns(columns works)

    //decode value from row and column values
    //key_decode kd(.r(rows), .c(debounced_value), .value(new_value)); 
    key_decode kd(debounced_value, new_value);
    
    always_ff @(posedge clk) begin
        if (!reset) begin
            value1 <= 4'b0110;
            value2 <= 4'b0001;
        end
        else begin
            if(enable) begin //only update when a new value is recieved
                value2 <= value1;
                value1 <= new_value;
            end
            else begin //TODO: is this line necessary?
                value1 <= value1;
                value2 <= value2;
            end
        end
    end

    // Write to the display TODO: clock values here?
    seg_disp_write sdw(.value1(value1), .value2(value2), .clk(clk), .seg_out(seg_out), .anodes(anodes));


endmodule 