// Wava Chan
// wchan@g.hmc.edu
// Sept. 13, 2025
// Debounces input signal from keypad press

module debouncer(input logic clk, reset,
                input logic [3:0] sig_in, 
                input logic key_pressed,
                output logic [3:0] sig_out);

    // initialize state information
    typedef enum logic [3:0] {WAIT_LOW, DEBOUNCEUP, WAIT_HIGH, DEBOUNCEDOWN}
    statetype;
        statetype state, nextstate;


    //counter 

    logic [19:0] counter;  // 20-bit counter for ~20ms at 48MHz
    logic counter_done;
    
    // Register
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= WAIT_LOW; //reset to WAIT_LOW and counter to 0
            counter <= 0;
            sig_out <= 4'b1111;
        end 
        else begin
            state <= nextstate; 
            if (state == DEBOUNCEUP || state == DEBOUNCEDOWN) begin // count at the waiting states
                if (counter_done) //reset to 0 when the counter is done
                    counter <= 0;
                else
                    counter <= counter + 1; //otherwise, increment the counter
            end
            if(nextstate == WAIT_HIGH && state == DEBOUNCEUP ) begin //only send out signal during change between states
                sig_out <= sig_in;
            end
        end
    end
        
    // Counter done signal. for 20ms
    //TODO: comment out when testing
    // For 48MHz clock: 48e6 * 0.020 = 960,000 cycles TODO: change this if you change scanner clock
    assign counter_done = (counter == 20'd960000); //counter >= 20'd960000

           
    always_comb begin

        case(state)
            WAIT_LOW:   begin 
                            if(key_pressed) nextstate = DEBOUNCEUP;
                            else nextstate = WAIT_LOW;
                        end

            DEBOUNCEUP: begin if(counter_done) begin 
                                    if (key_pressed) nextstate = WAIT_HIGH;
                                    else nextstate = WAIT_LOW;
                                end 
                            else nextstate=DEBOUNCEUP;
                        end
            WAIT_HIGH: begin
                        if(!key_pressed)  nextstate = DEBOUNCEDOWN;
                        else nextstate = WAIT_HIGH;
                    end
            DEBOUNCEDOWN:   begin if(counter_done) begin
                                    if(!key_pressed) nextstate = WAIT_LOW;
                                    else nextstate = WAIT_HIGH;
                                end 
                                else nextstate = DEBOUNCEUP;
                            end
            default:    begin 
                            nextstate = WAIT_LOW;
            end 
        endcase

    end   

endmodule