// Wava Chan
// wchan@g.hmc.edu
// Sept. 14, 2025
// Module to scan through 4 different rows of a keypad & determine the key pressed

module scanner(input logic clk, 
                input logic reset,
                input logic [3:0] columns,
                output logic [3:0] rows,
                output logic [3:0] value,
                output logic enable
                );

    //R1P = row 1 pressed
    typedef enum logic [7:0] {ROW1, R1P, R1E, ROW2, R2P, R2E, ROW3, R3P, R3E, ROW4, R4P, R4E} //TODO: might need more lol
    statetype;
        statetype state, nextstate;
    
    // set up necessary internal logic
    logic key_pressed_raw, key_pressed_debounced;
    logic [3:0] column_data, debounced_value;
    //logic [15:0] clk_div;
    //logic scan_clk;

    assign key_pressed_raw = (columns != 4'b1111); //if any column is pressed


    // state register
	always_ff @(posedge clk) begin
		if (reset == 0) state <= ROW1;
		else state <= nextstate;
	end

    always_comb begin
        nextstate = state;
        rows <= 4'b0000; //initialize all rows to 0
        case(state)
            ROW1: begin
                    rows <= 4'b1000;
                    if(key_pressed_raw) nextstate = R1P;
                    else nextstate = ROW2;
                   end
            R1P: begin
                    rows <= 4'b1000;
                    if(key_pressed_raw) nextstate = R1P; // stay at this state until key is unpressed
                    else nextstate = ROW2;
                   end
            R1E:
            ROW2: begin
                    rows <= 4'b0100;
                    if(key_pressed_raw) nextstate = R2P;
                    else nextstate = ROW3;
                   end
            R2P: begin
                    rows <= 4'b0100;
                    if(key_pressed_raw) nextstate = R2P; // stay here until key is unpressed
                    else nextstate = ROW3;
                   end
            R2E:
            ROW3: begin
                    rows <= 4'b0010;
                    if(key_pressed_raw) nextstate = R3P;
                    else nextstate = ROW4;
                   end
            R3P: begin
                    rows <= 4'b0010;
                    if(key_pressed_raw) nextstate = R3P; // stay here until key is unpressed
                    else nextstate = ROW4;
                   end
            R3E:
            ROW4: begin
                    rows <= 4'b0001;
                    if(key_pressed_raw) nextstate = R4P;
                    else nextstate = ROW1;
                   end
            R4P: begin
                    rows <= 4'b0001;
                    if(key_pressed_raw) nextstate = R4P; // stay here until key is unpressed
                    else nextstate = ROW1;
                   end
            R4E:
            default: nextstate = ROW1;
        endcase
    end

    // Capture column data when key is pressed TODO: this is likely redundant 
    always_ff @(posedge clk) begin
        if (reset == 0) begin
            column_data <= 4'b1111;
        end else if (key_pressed_raw && !key_pressed_debounced) begin // is key_pressed_debounced necessary here?
            column_data <= columns;  // Capture columns when key first pressed
        end
    end

    //debouncer 
    debouncer debounceFSM(.clk(clk), .reset(reset), .sig_in(column_data),
                         .key_pressed(key_pressed_raw), .sig_out(debounced_value), .sig_recieved(key_pressed_debounced));


    //decode value from row and column value
    key_decode kd(rows, ~debounced_value, value); //TODO: need to flip bits of debounced_value?

    assign enable = key_pressed_debounced; //figure out what to do with this
    
endmodule