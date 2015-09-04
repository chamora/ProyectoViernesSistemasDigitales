`timescale 1ns / 1ps// recibia

module resiver_central(clk, ps2_data, ps2_clk, ps2_data_out, pulso_done
    );
	 
	 input wire clk;////////////////Lo jalo 
	 input wire ps2_clk, ps2_data;/////// Lo JALO 
	 output wire [7:0] ps2_data_out;/////////Lo JALO//// Para recibirlo en la instanciacion se recibe en una variable interna tipo wire de 8 bits
	// output reg led;
	 output reg pulso_done; /////Se recibe con una variable interna de tipo wire 1 bit

	 ///output wire pulso_done; /////LO JALOOOOOOO ////// me da como 10 errores
	 
	 /////////// JALAMMOS 4 para el la otra funcion 
	 //Frecuencia del teclado 10-16,7kHz
	 //60 and 100ms como periodo
	    
	 //variables del programa   
	 reg [7:0] filtro_antirebote; 
	 reg ps2_clk_negedge; 
	 reg [2:0] estado=0;   
	 reg [7:0] contador=0;
	 reg [7:0] data_p; // variable va a definir a ps2_data_out
	 reg data_in; 
	 
//	 reg led1=1'b1;
	 
	 localparam [2:0]
	 idle = 3'b000,
	 uno = 3'b001,
	 dos = 3'b010,
	 tres = 3'b011,
	 cuatro = 3'b100;
	 /*
	 always @*
	 begin
		clk2=clk;
		led=ps2_clk;
	 end
	 */
	 
	 always @ (posedge clk) 
	 begin 
	 filtro_antirebote [7:0]<= {ps2_clk, filtro_antirebote[7:1]};
	 
	 end
	 //sirve para evitar glitches, toma el flanjo cuando 00001111 
	 always @ (posedge clk)
	
	begin 
	if (filtro_antirebote == 8'b00001111)
		ps2_clk_negedge <= 1'b1;
	else
		ps2_clk_negedge <= 1'b0;
	end 
	
	always @ (posedge clk)
	begin
	if (ps2_clk_negedge)
	data_in <= ps2_data;
	else 
	data_in <= data_in;
	end
	
	 always @ (posedge clk)
	 begin 
	 case (estado)
	 idle: begin
		
		data_p <= data_p;
		contador <= 4'd0;
		pulso_done <=1'b0;
		
			if (ps2_clk_negedge)
				estado<= uno;
			
			else
				estado<= uno;
			
			end
		uno: begin
			data_p<=data_p;
			contador <= contador;
			pulso_done <= 1'b0;
			
			if (ps2_clk_negedge)
			begin 	
				if (contador == 4'd9)
				
					estado<=tres;
				else 	
					estado <= dos;
				end
				
					else 
						estado<= uno;
				end
				
			dos: begin
				data_p [7:0] <= {data_in, data_p[7:1]};
				contador <=  contador +1;
				pulso_done <= 1'b0;
		
				estado <= uno;
				end
				
			tres: begin
				estado <= cuatro;
				pulso_done <=1'b1;
			
				data_p <=data_p;
				contador <= 4'd0;
				end
			cuatro: begin
				data_p <= data_p;
				contador <= 4'd0;
				pulso_done <= 1'b0;
				
				if (ps2_clk_negedge)
					estado <= idle;
				end
			endcase
			end
			
			assign  ps2_data_out = data_p;
			
			///ps2_data_out = data_p;
			
			
endmodule 
