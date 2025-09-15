// Wava Chan
// wchan@g.hmc.edu
// Sept. 14, 2025
// TODO: fill this out

module scanner(input logic clk, 
                input logic reset,
                input logic [3:0] columns,
                output logic [3:0] rows,
                input logic key_pressed,
                ouput logic [3:0] value 
                );
    //R1P = row 1 pressed
    typedef enum logic [7:0] {ROW1, R1P, ROW2, R2P, ROW3, R3P, ROW4, R4P} // TODO: need more states?
    statetype;
        statetype state, nextstate;
    
    // register
	always_ff @(posedge clk) begin
		if (reset == 0) state <= ROW1;
		state <= nextstate;
	end
    


    always_comb begin
        case(state)
            ROW1: begin
                    rows <= 4'1000;
                    if(key_pressed) nextstate = RP1;// go to debouncer FSM
                    else nextstate = ROW2;
                   end
            RP1: begin
                    rows <= 4'1000;
                    if(key_pressed) nextstate = RP1; // stay at this state until key is unpressed
                    else nextstate = ROW2;
                   end

            ROW2: begin
                    rows <= 4'0100;
                    if(key_pressed) nextstate = RP2;
                    else nextstate = ROW3;
                   end
            RP2: begin
                    rows <= 4'0100;
                    if(key_pressed) nextstate = RP2; // stay here until key is unpressed
                    else nextstate = ROW3;
                   end
            ROW3: begin
                    rows <= 4'0010;
                    if(key_pressed) nextstate = RP3;
                    else nextstate = ROW4;
                   end
            RP3: begin
                    rows <= 4'0010;
                    if(key_pressed) nextstate = RP3; // stay here until key is unpressed
                    else nextstate = ROW4;
                   end
            ROW4: begin
                    rows <= 4'0001;
                    if(key_pressed) nextstate = RP4;
                    else nextstate = ROW1;
                   end
            RP4: begin //are these stages redundant?
                    rows <= 4'0001;
                    if(key_pressed) nextstate = RP4; // stay here until key is unpressed
                    else nextstate = ROW1;
                   end
            default: nextstate = ROW1;
        endcase
    end

    //end logic? 
    //decode inside here
    key_decode kd(rows, columns, value);


    
endmodule