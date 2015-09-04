`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
module Instancias(clk, ps2_data, ps2_clk,reset);
	 // I/O sistemalk;
		input wire clk;/////Lo jalo 
		input wire reset;
		input wire ps2_clk, ps2_data;   //// Lo JALO 
	 
		wire [7:0] dato;
		//wire bandera;
		wire bandera;
		resiver_central codigo2(.clk(clk), .ps2_data(ps2_data), .ps2_clk(ps2_clk), .pulso_done(bandera), .ps2_data_out(dato));
		reg [3:0] sensores; 
			
		// Variable Internas 
		reg [3:0] salida;
		///wire [3:0] salida;
		reg [2:0] numSensores;
		//reg F0_flag;
		reg F02_flag;
	   //	reg unobinario=1'b1; 
		//reg cerobinario=1'b0;
		
		localparam[7:0]
		
		///s1=8'b00111000,/// A // Sensor 1
		s1=8'b00111000,/// A // Sensor 1
		s2=8'b11011000,/// S // sensor 2
		s3=8'b11000100,/// D  // Sensor 3  
		s4=8'b11010100,/// F  // Sensor 4 
		FO=8'b00001111, //// FO 
		reset_tecla=8'b10010100;/// Espacio 
		
		localparam [2:0]
		cero=3'b000,/// D  // Sensor 3  
		uno=3'b001,/// F  // Sensor 4 
		dos=3'b010,
		tres=3'b011,
		cuatro=3'b1000;
		////  http://www.disfrutalasmatematicas.com/numeros/binario-decimal-hexadecimal-conversor.html
		/// PDF Nexys 3 pag 14 taclado ver HEX y poner en sitio web, escribirlo al revés
		
		reg [2:0] estado_p, estado_s; /// Estados 
		//reg dato;
		localparam [2:0]
		central_state = 3'b000,
		unSensor = 3'b001,
		dosSensores = 3'b010,
		tresSensores= 3'b011,
		cuatroSensores		= 3'b100,
		F0_state= 3'b101;
		
		reg [2:0] actual_state, siguiente_state;
		
		always @(posedge clk, posedge reset)
			begin
				if(reset )
					begin
					actual_state=central_state;
					sensores=4'b0000;
					salida=4'b0000;
					end
				else if (bandera)
					actual_state=siguiente_state; 
			end
			
	always @*
			begin //check
			sensores=salida;
			
			case(actual_state)//check
			central_state :
			
			
					begin //check
					numSensores=3'b000;
					
						salida=4'b0000;
						//siguiente_state=actual_state;
						sensores=salida;
						
						if(F02_flag )
						begin//check
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b0;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=central_state;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=central_state;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=central_state;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b0;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=central_state;
								end
							FO: begin
							siguiente_state=F0_state;
							end
						
							endcase
							end
						else if (bandera)
							begin
							
							case(dato)
							s1://A// Sensor 1
									begin
									salida[0]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=unSensor;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b1;
									F02_flag=1'b0;
								//	F0_flag=1'b0;
									siguiente_state=unSensor;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b1;
									F02_flag=1'b0;
									//F0_flag=1'b0;
									siguiente_state=unSensor;
								end
							s4:/// F  // Sen
								begin
									
									salida[3]=1'b1;
									F02_flag=1'b0;
									//F0_flag=1'b0;
									siguiente_state=unSensor;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
							endcase
							end 
					end 
		/////
				unSensor :
				begin//check
				numSensores=3'b001;
			//	siguiente_state=central_state;
					
						if(F02_flag)
						begin//check
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=unSensor;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b0;
									F02_flag=1'b0;
									//F0_flag=1'b0;
									siguiente_state=unSensor;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b0;
									F02_flag=1'b0;
									//F0_flag=1'b0;
									siguiente_state=unSensor;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=unSensor;
								end
								FO: 
								begin
									siguiente_state=F0_state;
									end
						
							endcase//check
							end//check
						else if (bandera)
							begin
							//siguiente_state=dosSensores;
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
						FO: 
								begin
									siguiente_state=F0_state;
									end
							endcase//check
							end 
						
					end//check		
		/////
		
			dosSensores:
				begin//check
				numSensores=2'b10;
				//siguiente_state=unSensor;
					
						if(F02_flag)
						begin//check
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=dosSensores;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
							endcase//check
							end//check
						else if (bandera)
							begin
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b1;
									///F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b1;
									F02_flag=1'b0;
								//	F0_flag=1'b0;
									siguiente_state=tresSensores;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
							endcase//check
							end 
					end//check
		/////	
				tresSensores :
				begin//check
				numSensores=2'b11;
			//	siguiente_state=dosSensores;	
						if(F02_flag & bandera)
						begin//check
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;	
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;	
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b0;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=tresSensores;	
								end
							s4:/// F  // Sensor 4 
								begin
									siguiente_state=tresSensores;	
									salida[3]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
						//siguiente_state=dosSensores;
							endcase//check
							end//check
						else if (bandera)
							begin
							//siguiente_state=tresSensores;
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;	
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;	
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;	
								end
							s4:/// F  // Sensor 4 
								begin
									siguiente_state=cuatroSensores;	
									salida[3]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
						//siguiente_state=dosSensores;
							endcase//check
							end 
					end//check
		/////
				cuatroSensores :
				begin//check
				numSensores=3'b100;
			//	siguiente_state=tresSensores;
					
						if(F02_flag )
						begin//check
							case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b0;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b0;
									F02_flag=1'b0;
									//F0_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
						//siguiente_state=tresSensores;
							endcase//check
							end//check
						else if (bandera)
							begin
						//	siguiente_state=cuatroSensores;
						case(dato)//check
							s1://A// Sensor 1
									begin
									salida[0]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
									end
							
							s2:/// S // sensor 2
								begin
									salida[1]=1'b1;
									//F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							s3:/// D  // Sensor 3  
								begin
									salida[2]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							s4:/// F  // Sensor 4 
								begin
									
									salida[3]=1'b1;
								//	F0_flag=1'b0;
									F02_flag=1'b0;
									siguiente_state=cuatroSensores;
								end
							FO: 
								begin
									siguiente_state=F0_state;
									end
						
						//siguiente_state=tresSensores;
							endcase//check
							end 
					end//check
		/////
		
					F0_state :
					begin//check
					F02_flag=1'b1;
					begin//check
						case(numSensores)//check
							//begin//check
							cero:
									begin
									siguiente_state=central_state;

									end
							
							uno:
								begin
									siguiente_state=central_state;
								end
							dos:
								begin
									siguiente_state=unSensor;
								end
							tres:
								begin
									siguiente_state=dosSensores;
								end
							cuatro:
								begin
									siguiente_state=tresSensores;
								end
						default siguiente_state=central_state;
						//end
					
					//end//check
				
				endcase//check
			end //check

		//////
		end
			endcase
end			
endmodule 
