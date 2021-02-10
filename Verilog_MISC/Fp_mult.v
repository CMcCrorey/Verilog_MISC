`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2020 02:25:35 PM
// Design Name: 
// Module Name: Fp_mult
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


module Fp_mult#(parameter WI1 =4 ,WF1 =4, WI2 =4 , WF2=4, WI0 =8 , WF0=8 )(
    input rst,  //clk not needed
    input signed [WI1+WF1-1:0] in1,
    input signed [WI2+WF2-1:0] in2,
    output reg signed [WI0+WF0-1:0] out,
    output reg OFV
    );
               
                //calcuate as int
                 //determine where . should be?
                 //base on output parameter truncate or extend

    reg signed [WI1+WI2+WF1+WF2-1:0] outT; //correct full value
    reg signed [WI0-1:0] Iwire0;
    reg  [WF0-1:0] Fwire0;  //be signed?
    reg  signed [WI1+WI2-1:0] Iwire;
    reg  [WF1+WF2-1:0] Fwire;   //be signed?
   
  
     
    
    always@* begin  
        OFV=0;
      outT = in1*in2;       
         
  
       if(rst) outT = 0;
       else   {Iwire,Fwire}= outT; 
    
    
    
      
             
         if(WF0 < (WF1 +WF2) ) begin
          
             Fwire0=  Fwire[WF1+WF2-1:(WF1 +WF2)-WF0];   //take most sig bits from FR
             
        end  
        
        
          if(WF0 > (WF1 +WF2) ) begin
            Fwire0=  {Fwire,{(WF0-(WF1+WF2)){1'b0}}};  //extend 0s
        end 
        
          if(WI0 < (WI1 +WI2) ) begin
        Iwire0 = Iwire; 
            if(Iwire0 != Iwire)   //if not equal there is over flow
            OFV =1'b1;
              
        end 
            
        
          if(WI0 > (WI1 +WI2) ) begin
        
        Iwire0 = {{(WI0-(WI1+WI2)){outT[WI1+WI2+WF1+WF2-1:0]}},Iwire};    //sign extended
              
        end 
        
          if(WF0 == (WF1 +WF2) ) begin
            Fwire0=  Fwire;
              
        end 
        
          if(WI0 == (WI1 +WI2) ) begin
             Iwire0 = Iwire;                  //equal no issue
              
        end   
             
         out = {Iwire0,Fwire0[WF0-1:0]};
      //need to check for OFV compare out value with 
       
   end    
endmodule


