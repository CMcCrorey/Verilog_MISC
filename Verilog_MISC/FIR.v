`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2020 01:09:07 PM
// Design Name: 
// Module Name: FIR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Q(2.6)
module FIR #(parameter WI =2, WF= 6) (
    input clk,rst,rst2,
    input signed [WI+WF-1: 0] x,
    output signed [WI+WF-1:0] y  //check again for correct output length
    
    
    );
    wire OFV;
    
    
    //LOCAL PARAM
    //multiplier params
     localparam wi=WI,wf=WF,wio=4,wfo=12;
     
     //adder params
    localparam Awi=4,Awf=12,Awio=4,Awfo=12 ,Awio_2=2,Awfo_2=6;
    
    wire signed [wio+wfo-1: 0] xmult_1,xmult_2,xmult_3, Add_1;
    
    
        //Ho =-1/3   H1 =4/5    H2 = 2/5
    localparam signed [WI+WF-1:0] H0=8'b11101011, H1 =8'b00110011, H2 =8'b00011010;
     
  
     
          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wi),.WF0(wfo),.WF1(wf), .WF2(wf)) mu1(
.rst(rst2), .in1(x), .in2(H0),.out(xmult_1),.OFV(OFV));

          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wi),.WF0(wfo),.WF1(wf), .WF2(wf)) mu1_2( 
.rst(rst2), .in1(x_reg), .in2(H1),.out(xmult_2),.OFV(OFV));

          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wi),.WF0(wfo),.WF1(wf), .WF2(wf)) mu1_3( 
.rst(rst2), .in1(x_reg_2), .in2(H2),.out(xmult_3),.OFV(OFV));



fp_adder #(.WI0(Awio),.WI1(Awi),.WI2(Awi),.WF0(Awfo),.WF1(Awf), .WF2(Awf)) adder_1( 
.rst(rst2), .in1(xmult_1), .in2(xmult_2),.out(Add_1),.OFV(OFV));

fp_adder #(.WI0(Awio_2),.WI1(Awi),.WI2(Awi),.WF0(Awfo_2),.WF1(Awf),.WF2(Awf)) adder_2( 
.rst(rst2), .in1(Add_1), .in2(xmult_3),.out(y),.OFV(OFV));
     
    
    
    reg signed [WI+WF-1: 0] temp,x_reg, x_reg_2;
        
     always @(posedge clk) begin
     if(rst) begin
      x_reg <= 0;  //xn-1
     x_reg_2 <= 0;  
      end
      
      else begin    
     x_reg <= x;  //xn-1
     x_reg_2 <= x_reg;  //xn-2
    end  
    end   
endmodule
    
    
    
    
    
 