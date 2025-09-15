// Wava Chan
// wchan@g.hmc.edu
// Sept. 5, 2025
// Basic demux 1 in 2 out for Lab 2

module demux2_1(input logic select,
				output logic [1:0] com_an); //Common Anode
	
	always_comb begin
		case(select)
			1'b0: com_an = 2'b10; // turn on common anode 1
			1'b1: com_an = 2'b01; // turn on common anode 2
			default: com_an = 2'b00;
		endcase
	end
endmodule