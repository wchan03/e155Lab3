// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// TODO: Summary

module debouncer(input logic clk, reset,
                input logic [3:0] sig_in, 
                input logic key_pressed,
                output logic [3:0] sig_out,
				output logic sig_recieved); // do i do anything with this signal?


    // initialize state information
    typedef enum logic [3:0] {WAIT_LOW, DEBOUNCEUP, WAIT_HIGH, DEBOUNCEDOWN}
    statetype;
        statetype state, nextstate;

    // register
	always_ff @(posedge clk) begin
		if (reset) state <= WAIT_LOW;
        else state <= nextstate;
	end

    //counter 

    logic [19:0] counter;  // 20-bit counter for ~83ms at 48MHz
    logic counter_done;
    
    // Register
    always_ff @(posedge clk) begin
        if (reset == 0) begin
            state <= WAIT_LOW;
            counter <= 0;
        end 
        else begin
            state <= nextstate;
            if (state == DEBOUNCEUP || state == DEBOUNCEDOWN) begin // count at the waiting states
                if (counter_done)
                    counter <= 0;
                else
                    counter <= counter + 1;
            end
            else counter <= 0;
    end
end
    
    // Counter done signal. for 20ms. TODO: make shorter?
    // For 48MHz clock: 48e6 * 0.020 = 960,000 cycles
    assign counter_done = (counter == 20'd960000);

    logic [3:0] sig;


            
    always_comb begin

        case(state)
            WAIT_LOW:   begin 
                            if(key_pressed) nextstate = DEBOUNCEUP; //do i ned more begin and end statements here?
                            else nextstate = WAIT_LOW;
                        end

            DEBOUNCEUP:        if(counter_done) begin 
                                    if (key_pressed) nextstate = WAIT_HIGH;
                                    else nextstate = WAIT_LOW;
                                end 
            WAIT_HIGH:
                        if(!key_pressed)  nextstate = DEBOUNCEDOWN;
                        else nextstate = WAIT_HIGH;
            DEBOUNCEDOWN:       if(counter_done) begin
                                    if(!key_pressed) nextstate = WAIT_LOW;
                                    else nextstate = WAIT_HIGH;
                                end 
            default:    nextstate = WAIT_LOW;
        endcase

    end

    //TODO: where is my output logic??
    always_ff @(posedge clk) begin //necessary to be in a flip flop?
        if (reset == 0) begin
            sig_out <= 4'b0000;
        end else if (state == DEBOUNCEUP && counter_done && key_pressed) begin
            sig_out <= sig_in;  // Capture the stable input
        end
    end
	assign sig_recieved = (state == WAIT_HIGH); //i feel like this is good to have. no reason why

endmodule