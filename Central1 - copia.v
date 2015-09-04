`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
module Instancias(clk, ps2_data, ps2_clk,reset,activadores,sevenseg,display);
	 // I/O sistemalk;
		input wire clk;/////Lo jalo 
		input wire reset;
		input wire ps2_clk, ps2_data;   //// Lo JALO 
		output reg [6:0] activadores;
		output reg [7:0] sevenseg;
		output reg [3:0] display;
		
		wire [7:0] dato; ///Para Recibirps2_data_out 
		wire bandera;  ///Pera Recibir
		Codigo1 codigo2(.clk(clk), .ps2_data(ps2_data), .ps2_clk(ps2_clk), .pulso_done(bandera), .ps2_data_out(dato));
		
		parameter e0=4'b0000,e1=4'b0001,e2=4'b0010,e3=4'b0011,e4=4'b0100,e5=4'b0101,e6=4'b0110,e7=4'b0111,e8=4'b1000,e9=4'b1001,e10=4'b1010,e11=4'b1011,e12=4'b1100,e13=4'b1101,e14=4'b1110,e15=4'b1111;
		parameter m0=4'b0000,m1=4'b0001,m2=4'b0010,m3=4'b0011,m4=4'b1000,m5=4'b0101,m6=4'b0110,m7=4'b0111,m8=4'b1000,m9=4'b1001,m10=4'b1010,m11=4'b1011,m12=4'b1100,m13=4'b1101,m14=4'b1110,m15=4'b1111;
	 
		reg [3:0] estado_p, estado_s;
		
		// Variable Internas 
		reg [3:0] salida;
		reg [3:0] variable;
		reg [2:0] numSensores; 
		//reg F0_flag; 
		reg F02_flag; 

		              
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
						salida=4'b0000;
						////De maquinaE
						estado_p<=m1;
					end
				else if (bandera)
					begin
						actual_state=siguiente_state; 
						///Parte maquina estados
						estado_p<=estado_s;
					end
			end
			
			always @* //always @* 1
				begin //check
					case(actual_state)//check
					central_state :
							begin //check
							numSensores=3'b000;
							salida=4'b0000;
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
											FO: 
												begin
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
							end// de la condicion central state 
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
			end/// always @* 1
			
			always@* /// alwais @*2  //logica de siguiente de estado y logica de salida
				//variable<=salida;
				begin 
					estado_s = estado_p;
					case (estado_p)

					m0: 
						begin 
						if (salida == 4'b0000)
							begin
								activadores=7'b0000001;
								display=4'b1111;
								sevenseg=8'b11111111;
								estado_s=m0;
							end
						else
							if(salida==e0)
								estado_s=m0;
							else if(salida==e1)
								estado_s=m1;
							else if(salida==e2)
								estado_s=m2;
							else if(salida==e3)
								estado_s=m3;
							else if(salida==e4)
								estado_s=m4;
							else if(salida==e5)
								estado_s=m5;
							else if(salida==e6) 
								estado_s=m6;
							else if(salida==e7)
								estado_s=m7;
							else if(salida==e8)
								estado_s=m8;
							else if(salida==e9)
								estado_s=m9;
							else if(salida==e10)
								estado_s=m10;
							else if(salida==e11)
								estado_s=m11;
							else if(salida==e12)
								estado_s=m12;
							else if(salida==e13)
								estado_s=m13;
							else if(salida==e14)
								estado_s=m14;
						else if(salida==e15)
								estado_s=m15;
						end

					m1: 
						begin 
					activadores=7'b1000000;
						if (salida == 4'b0001)
							begin
							estado_s=m1;
							display=4'b1110;
							sevenseg=8'b10011111;
						end

						else
						estado_s=m0;

						end 
						m2:
						begin 
						activadores=7'b1011100;
						if (salida == 4'b0010)
							begin
						estado_s=m2;
						display=4'b1101;
						sevenseg=8'b10011111;
							end
						else
							estado_s=m0;

						end
						m3:
						begin 
						activadores=7'b1011110;
						if (salida == 4'b0011)
							begin
							estado_s=m3;
							display=4'b1100;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end
						m4:
						begin 
						activadores=7'b1100000;
						if (salida == 4'b0100)
							begin
							estado_s=m4;
							display=4'b1011;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

					end
						m5:
						begin 
						activadores=7'b1100010;
						if (salida == 4'b0101)
							begin
							estado_s=m5;
							display=4'b1010;
							sevenseg=8'b10011111;
						end
						else
						estado_s=m0;

						end
						m6:
						begin 
						activadores=7'b1111110;
						if (salida == 4'b0110)
							begin
							estado_s=m6;
							display=4'b1001;
							sevenseg=8'b10011111;
						end
						else
						estado_s=m0;

						end
						m7:
						begin 
						activadores=7'b1111110;
						if (salida == 4'b0111)
							begin
							estado_s=m7;
							display=4'b1000;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end 
						m8:
						begin 
						activadores=7'b1110000;
						if (salida == 4'b1000)
							begin
							estado_s=m8;
							display=4'b0111;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end 
						m9:
						begin 
						activadores=7'b1010010;
						if (salida == 4'b1001)
							begin
							estado_s=m9;
							display=4'b0110;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end
						m10: 
						begin 
						activadores=7'b1011110;
						if (salida == 4'b1010)
							begin
							estado_s=m10;
							display=4'b0101;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end 
						m11:
						begin 
						activadores=7'b1011110;
						if (salida == 4'b1011)
							begin
							estado_s=m11;
							display=4'b0100;
							sevenseg=8'b10011111;
							end
							else
						estado_s=m0;

						end 
						m12:
						begin 
						activadores=7'b1110010;
						if (salida == 4'b1100)
							begin
							estado_s=m12;
							display=4'b0011;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end
						m13:
						begin 
						activadores=7'b1110010;
						if (salida == 4'b1101)
							begin
							estado_s=m13;
							display=4'b0010;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end
						m14:
						begin 
						activadores=7'b1111110;
							if (salida == 4'b1110)
							begin
							estado_s=m14;
							display=4'b0001;
							sevenseg=8'b10011111;
							end
						else
						estado_s=m0;

						end
						m15:
						begin  
						activadores=7'b1111110;
							if (salida == 4'b1111)
								begin
								estado_s=m15;
								display=4'b0000;
								sevenseg=8'b10011111;
								end
						else
						estado_s=m0;

							end

						default estado_s=m0;
						endcase

		end// Always @* 2

			
endmodule
