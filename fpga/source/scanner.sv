// Wava Chan
// wchan@g.hmc.edu
// Sept. 14, 2025
// Module to scan through 4 different rows of a keypad & determine the key pressed

module scanner(input logic clk, 
                input logic reset,
                input logic [3:0] columns,
                output logic [3:0] rows,
                //input logic key_pressed,
                output logic [3:0] value 
                );

    //R1P = row 1 pressed
    typedef enum logic [7:0] {ROW1, R1P, ROW2, R2P, ROW3, R3P, ROW4, R4P} // TODO: need more states?
    statetype;
        statetype state, nextstate;
    
    // set up necessary internal logic
    logic key_pressed_raw, key_pressed_debounced;
    logic [3:0] column_data;

    assign key_pressed_raw = (columns != 4'b1111); //active low columns

    // register
	always_ff @(posedge clk) begin //TODO: is this the correct way to set up the clock?
		if (reset == 0) state <= ROW1;
		else state <= nextstate;
	end
    


    always_comb begin
        nextstate = state;
        rows = 4'b0000; 
        case(state)
            ROW1: begin
                    rows <= 4'b1000;
                    if(key_pressed_raw) nextstate = RP1;// go to debouncer FSM
                    else nextstate = ROW2;
                   end
            R1P: begin
                    rows <= 4'b1000;
                    if(key_pressed_raw) nextstate = RP1; // stay at this state until key is unpressed
                    else nextstate = ROW2;
                   end
            ROW2: begin
                    rows <= 4'b0100;
                    if(key_pressed_raw) nextstate = RP2;
                    else nextstate = ROW3;
                   end
            R2P: begin
                    rows <= 4'b0100;
                    if(key_pressed_raw) nextstate = RP2; // stay here until key is unpressed
                    else nextstate = ROW3;
                   end
            ROW3: begin
                    rows <= 4'b0010;
                    if(key_pressed_raw) nextstate = RP3;
                    else nextstate = ROW4;
                   end
            R3P: begin
                    rows <= 4'b0010;
                    if(key_pressed_raw) nextstate = RP3; // stay here until key is unpressed
                    else nextstate = ROW4;
                   end
            ROW4: begin
                    rows <= 4'b0001;
                    if(key_pressed_raw) nextstate = RP4;
                    else nextstate = ROW1;
                   end
            R4P: begin //are these stages redundant?
                    rows <= 4'b0001;
                    if(key_pressed_raw) nextstate = RP4; // stay here until key is unpressed
                    else nextstate = ROW1;
                   end
            default: nextstate = ROW1;
        endcase
    end

    // Capture column data when key is pressed
    always_ff @(posedge clk) begin
        if (reset == 0) begin
            column_data <= 4'b1111;
        end else if (key_pressed_raw && !key_pressed_debounced) begin
            column_data <= columns;  // Capture columns when key first pressed
        end
    end

    //end logic? 

    //debouncer 
    debouncer debounceFSM(.clk(clk), .reset(reset), .sig_in(column_data),
                         .key_pressed(key_pressed_raw), .sig_out(value), .sig_recieved(key_pressed_debounced));


    //decode inside here
    key_decode kd(rows, columns, value);


    
endmodule