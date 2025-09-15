// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// TODO: Summary

module debouncer(input logic clk, reset,
                input logic [3:0] sig_in, 
                input logic key_pressed,
                output logic [3:0] sig_out);

    // initialize state information
    typedef enum logic [3:0] {WAIT_LOW, DEBOUNCEUP, WAIT_HIGH, DEBOUNCEDOWN}
    statetype;
        statetype state, nextstate;

    // register
	always_ff @(posedge clk) begin
		if (reset == 0) state <= WAIT_LOW;
		state <= nextstate;
	end

    logic [3:0] sig;
    // debouncer : FSM
    always_ff @(posedge int_osc) begin  
       counter <= counter + 19'd2; //operates at ~46.2 Hz
    end

            
    always_comb begin

        case(state)
            WAIT_LOW:   if(signal_receieved) nextstate = DEBOUNCEUP; 
                        else nextstate = WAIT_LOW;

            DEBOUNCEUP:         begin 
                                    #4000000 // wait ~83ms. or should i be using a counter
                                    nextstate = WAIT_HIGH;
                                    sig_out <= sig_in; //TODO: Where else should i assign values?
                                end 
            WAIT_HIGH:
                        if(~signal_receieved)  nextstate = DEBOUNCEDOWN;
                        else nextstate = WAIT_HIGH;
            DEBOUNCEDOWN:       begin 
                                    #4000000 // wait ~83ms
                                    nextstate = WAIT_LOW;
                                end 
            default:    nextstate = WAIT_LOW;
        endcase

    end
    //TODO: where is my output logic??

endmodule