// Wava Chan
// wchan@g.hmc.edu
//Sept 15, 2025
// Figure out key value based on row and columns


module key_decode(input logic [7:0] total_val,
                    output logic [3:0] value);
	//unpack total val
	logic [3:0] r, c;
	assign r = total_val[7:4];
	assign c = ~total_val[3:0];

    // rows are encoded 1 hot
    // so are columns. bits are flipped inside call in scanner.sv
	always_comb begin
		if(r[3]) begin
			if(c[0]) value = 4'b0001; // 1
			else if(c[1]) value = 4'b0010; //2
			else if (c[2]) value = 4'b0011; // 3
			else if (c[3]) value = 4'b1010; // A
		end
		else if(r[2]) begin 
			if(c[0])  value = 4'b0100; // 4
			else if(c[1]) value = 4'b0101; // 5
			else if (c[2]) value = 4'b0110; // 6
			else if (c[3]) value = 4'b1011; // B
		end
		else if(r[1]) begin 
			if(c[0]) value = 4'b0111; // 7
			else if(c[1]) value = 4'b1000; // 8
			else if (c[2]) value = 4'b1001; // 9
			else if (c[3]) value = 4'b1100; // C
		end 
		else if(r[0]) begin 
			if(c[0]) value = 4'b1110; // E
			else if(c[1]) value = 4'b0000; // 0
			else if (c[2]) value = 4'b1111; // F
			else if (c[3]) value = 4'b1101; // D
		end 
		else value = 4'b0000; //default to 0
    end
endmodule