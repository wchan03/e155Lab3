// Wava Chan
// wchan@g.hmc.edu
// Sept. 5, 2025
// Basic 2-in 1-out mux

module mux #(parameter WIDTH = 4)
			(input logic [WIDTH-1:0] d0, d1,
			input logic s,
			output logic [WIDTH-1:0] out);
			
	assign out = s ? d1 : d0;
	
 endmodule 