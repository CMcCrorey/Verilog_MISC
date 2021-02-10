`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


  
  
  




`define segment_1 16'b0000000110010010 //0.392

`define segment_2 16'b0000001100100100 
                                       
`define segment_3 16'b0000010010110110 
                                       
`define segment_4 16'b0000011001001000 
                                       
`define segment_5 16'b0000011111011011 
                                       
`define segment_6 16'b0000100101101101 
                                       
`define segment_7 16'b0000101011111111 
                                       
`define segment_8 16'b0000110010010001 
                                       
`define segment_9 16'b0000111000100011 
                                       
`define segment_10 16'b0000111110110101
                                       
`define segment_11 16'b0000111110110101
                                       
`define segment_12 16'b0001000101000111
                                       
`define segment_13 16'b0001001011011001
                                       
`define segment_14 16'b0001010111111110
                                       
`define segment_15 16'b0001011110010000
                                       
`define segment_16 16'b0001100100100010




//x  in Q(6,10)

// Y= Ax + B
module Function_approx #(parameter WL =16)(

    input [WL-1 :0] x,
    input rst,
    output [WL-1 :0] y
    );
    
    
    //text is Coeff and Test_vec
    
      IM_ROM #(.DWL(32), .AWL(8))  LUT(.addr(seg) ,.instruct(Coeff_A_B_wire));  //16 spots for memory
  
     Fp_mult #(.WI0(6),.WI1(6),.WI2(6),.WF0(10),.WF1(10), .WF2(10)) m1(.clk(), 
.rst(rst), .in1(x), .in2(A),.out(x_mult),.OFV(OFV));

fp_adder #(.WI0(6),.WI1(6),.WI2(6),.WF0(10),.WF1(10), .WF2(10)) adder(.clk(clk), 
.rst(rst), .in1(x_mult), .in2(B),.out(y),.OFV(OFV));
    
    
    reg [31:0] mem [63:0];
    
    
    wire OFV =0;
    reg [4:0] i;
    reg [7:0] seg; //since address 8 bit
   reg  [15:0] segmentValue ;
    wire signed [15:0] x_mult;
    wire [31:0]  Coeff_A_B_wire;
    wire signed [15:0] A;
    wire signed [15:0] B;
    
    
    assign  {A,B} =Coeff_A_B_wire;
 
    
    //segment decoder
    
    always@* begin
 
//     if(x <= `segment_1) 
//     seg= 0;
//     else if(x <= `segment_2) 
//     seg= 1;
//      else if(x <= `segment_3) 
//     seg= 2;
//     else if(x <= `segment_4) 
//     seg= 3;
//      else if(x <= `segment_5) 
//     seg= 4;
//     else if(x <= `segment_6) 
//     seg= 5;
//      else if(x <= `segment_7) 
//     seg= 6;
//     else if(x <= `segment_8) 
//     seg= 7;
//      else if(x <= `segment_9) 
//     seg= 8;
//     else if(x <= `segment_10) 
//     seg= 9;
//      else if(x <= `segment_11) 
//     seg= 10;
//     else if(x <= `segment_12) 
//     seg= 11;
//      else if(x <= `segment_13) 
//     seg= 12;
//     else if(x <= `segment_14) 
//     seg= 13;
//     else if(x <= `segment_15) 
//     seg= 14;
//     else seg= 15;   
    
begin :loop
for (i =0; i < 16; i =i+1) begin
    if(x <= mem[i]) begin
     seg= i; 
     disable loop;
     end
    
end
end


    
   end 
   
   
   
   
   initial begin
   
   $readmemb("C:/Users/Jackie/Documents/FPGA_Projects/debug/seggyV",mem);
   
   end
   
   
   
   
   
   
endmodule
