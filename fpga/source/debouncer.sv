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
	//always_ff @(posedge clk) begin
	//	if (reset) state <= WAIT_LOW;
      //  else state <= nextstate;
	//end

    //counter 

    logic [19:0] counter;  // 20-bit counter for ~20ms at 48MHz
    logic counter_done;
    
    // Register
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= WAIT_LOW; //reset to WAIT_LOW and counter to 0
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
        
    // Counter done signal. for 20ms
    // For 48MHz clock: 48e6 * 0.020 = 960,000 cycles
    assign counter_done = (counter == 20'd960000);

           
    always_comb begin

        case(state)
            WAIT_LOW:   begin 
                            if(key_pressed) nextstate = DEBOUNCEUP;
                            else nextstate = WAIT_LOW;
                        end

            DEBOUNCEUP: if(counter_done) begin 
                                    if (key_pressed) nextstate = WAIT_HIGH;
                                    else nextstate = WAIT_LOW;
                        end 
            WAIT_HIGH: begin
                        if(!key_pressed)  nextstate = DEBOUNCEDOWN;
                        else nextstate = WAIT_HIGH;
                        //sig_out <= sig_in;
                    end
            DEBOUNCEDOWN:       if(counter_done) begin
                                    if(!key_pressed) nextstate = WAIT_LOW;
                                    else nextstate = WAIT_HIGH;
                                end 
            default:    begin 
                            nextstate = WAIT_LOW;
                            //sig_out <= 4'b0000;
            end 
        endcase

    end

    
    always_ff @(posedge clk) begin //TODO: necessary to be in a flip flop?
        if (reset) begin
            sig_out <= 4'b1111;
        end else if (state == WAIT_HIGH) begin//DEBOUNCEUP && counter_done && key_pressed) begin
            sig_out <= sig_in;  // Capture the stable input
        end
    end
    

	assign sig_recieved = (state == WAIT_HIGH); //i feel like this is good to have. no reason why


endmodule