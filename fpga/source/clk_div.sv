// Wava Chan
// wchan@g.hmc.edu
// Sept. 22, 2025
// Basic clock divider to slow down the HSOSC 

module clk_div(input logic orig_clk, output logic new_clk);

    logic [22:0] counter = 0;


    always_ff @(posedge orig_clk) begin
        counter <= counter + 23'd28; //roughly 80Hz
    end

    assign new_clk = counter[22];

endmodule