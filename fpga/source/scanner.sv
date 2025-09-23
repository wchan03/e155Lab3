// Wava Chan
// wchan@g.hmc.edu
// Sept. 14, 2025
// Module to scan through 4 different rows of a keypad & determine the key pressed

module scanner(input logic clk, 
                input logic reset,
                input logic [3:0] columns,
                input logic key_pressed,
                output logic [3:0] rows,
                output logic enable,
                output logic [7:0] total_val
                );

    //R1P = row 1 pressed
    //for each row, ROW#, row # enabled, row # pressed
    typedef enum logic [7:0] {ROW1, R1E, R1P, ROW2, R2E, R2P, ROW3, R3E, R3P, ROW4, R4E, R4P} //TODO: might need more lol
    statetype;
        statetype state, nextstate;
    
    // set up necessary internal logic
    //logic key_pressed, key_pressed_debounced; //DO I NEED ALL THESE VALUES?
    logic [3:0] debounced_value;

    //assign key_pressed = (columns != 4'b1111); //if any column is pressed


    // state register
	always_ff @(posedge clk) begin
		if (!reset) state <= ROW1;
		else state <= nextstate;
	end

    always_comb begin
        case(state)
            ROW1: begin
                    if(key_pressed) nextstate = R1E;
                    else nextstate = ROW2;
                   end
            R1E: begin
                    if(key_pressed) nextstate = R1P;
                    else nextstate = ROW1;
                end
            R1P: begin
                    if(key_pressed) nextstate = R1P; // stay at this state until key is unpressed
                    else nextstate = ROW1;
                   end //TODO: need a extra state here??
            ROW2: begin
                    if(key_pressed) nextstate = R2E;
                    else nextstate = ROW3;
                   end
            R2E: begin
                    if(key_pressed) nextstate = R2P;
                    else nextstate = ROW2;
                end
            R2P: begin
                    if(key_pressed) nextstate = R2P; // stay here until key is unpressed
                    else nextstate = ROW2;
                   end
            ROW3: begin
                    if(key_pressed) nextstate = R3E;
                    else nextstate = ROW4;
                   end
            R3E: begin 
                    if(key_pressed) nextstate = R3P;
                    else nextstate = ROW3;
                end
            R3P: begin
                    if(key_pressed) nextstate = R3P; // stay here until key is unpressed
                    else nextstate = ROW3;
                   end
            ROW4: begin
                    if(key_pressed) nextstate = R4E;
                    else nextstate = ROW1;
                   end
            R4E: begin 
                    if(key_pressed) nextstate = R4P;
                    else nextstate = ROW4;
                end
            R4P: begin
                    if(key_pressed) nextstate = R4P; // stay here until key is unpressed
                    else nextstate = ROW4;
                   end
            default: nextstate = ROW1;
        endcase
    end


    //assign row logic outside of the FSM? 
    assign rows[3] = (state == ROW1) || (state == R1E) || (state == R1P);
    assign rows[2] = (state == ROW2) || (state == R2E) || (state == R2P);
    assign rows[1] = (state == ROW3) || (state == R3E) || (state == R3P);
    assign rows[0] = (state == ROW4) || (state == R4E) || (state == R4P);

    //debouncer TODO: move out of here??
    // debouncer debounceFSM(.clk(clk), .reset(reset), .sig_in(columns),
    //                      .key_pressed(key_pressed_debounced), .sig_out(debounced_value));


    //decode value from row and column value
    //key_decode kd(rows, ~debounced_value, value); //~debounced_value because of the logic in key_decode
    //assign debounced_col = debounced_value;
    assign key_pressed_debounced = (state == R4P) || (state == R3P) || (state == R2P)|| (state == R1P); //access debouncer only in keypressedconfirmed states
    assign enable = (state == R4E) || (state == R3E) || (state == R2E)|| (state == R1E); 
    assign total_val = {rows, columns};


endmodule