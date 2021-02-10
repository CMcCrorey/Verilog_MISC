`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//`define WIDTH ( (WI1+WF1) > (WI2+ WF2) ? (WI1 +WF1+1) : (WI2+ WF2 +1))  // Max of two +1

`define Fmax ( (WF1-WF2) > (WF2 - WF1) ? WF1 : WF2)  //finding larger frac part
`define Fmin ( (WF1-WF2) < (WF2 - WF1) ? WF1 : WF2)  //finding smaller frac part

`define Imax ( (WI1-WI2) > (WI2 - WI1) ? WI1 : WI2 )    //Max(WI1,WI2)
`define ImaxPlus ( (WI1-WI2) > (WI2 - WI1) ? WI1 +1 : WI2 +1)    //Max(WI1,WI2)+1
`define Imin ( (WI1-WI2) < (WI2 - WI1) ? WI1 : WI2)


module fp_adder #(parameter WI1 =8,WF1 =8, WI2 =8 , WF2=8, WI0 =8 , WF0=8 )(
    input rst,
    input signed [WI1+WF1-1:0] in1,
    input signed [WI2+WF2-1:0] in2,
    output reg signed [WI0+WF0-1:0] out, //this RIGHT FIR ADDING????????? maybe add a plus 1
    output reg OFV
    );
    
    reg signed [`ImaxPlus + `Fmax -1 :0] in1T;   // space for extended max inputs
    reg signed [`ImaxPlus + `Fmax -1 :0] in2T;  //?????????????
   
    reg signed [`ImaxPlus + `Fmax  -1:0] outT; //correct full max(WI1,WI2) +1 and max(WF1,Wf2)
    
    
    
    reg        [WI0-1:0] Iwire0;     //output wire Int size    
    reg        [WF0-1:0] Fwire0;    //output wire Frac size     
    
    reg         [`ImaxPlus-1:0] Iwire;  // max Int size  for in1
    reg         [`ImaxPlus-WI0-1:0] tmp;  // tmp for of check
    reg         [`Fmax-1:0] Fwire;  // max Frac size for in1
    
//    reg         [`Imax-1:0] Iwire2;  // max Int size  for in2
//    reg         [`Fmax-1:0] Fwire2;  // max Frac size  for in2
    
    
 
    always@* begin  
        OFV=0;
 //aligning the fixed points
 
 //***************atemp1*******    

    if(WF1 < WF2) 
    in1T = in1 <<< (WF2-WF1);
    else  in1T = in1;
    if(WF2 < WF1) 
    in2T = in2 <<< (WF1-WF2);
    else  in2T = in2;
    
    outT = in1T +in2T;
   {Iwire,Fwire}= outT;   //parse out full Int and Frac again from SUM


 // *****************************
 
        
  //**********alignment attemp 2******************************************************
    
//    Iwire= in1[WI1 +WF1 -1:WF1];            //int part from in1
//    Iwire2=in2[WI2 +WF2 -1:WF2];           //int part from 1n2
//    Fwire =  in1[WF1-1:0];                   //frac part for in1
//    Fwire2 = in2[WF2-1:0];                  //frac part for in2
     
     
//    if(WI2 > WI1) 
//    Iwire = {{(WI2-WI1){in1[WI1 +WF1 -1]}},in1[WI1 +WF1 -1:WF1]}; //sign extned int part of in1 
//    if(WI1 > WI2) 
//    Iwire2 = {{(WI1-WI2){in2[WI1 +WF1 -1]}}, in2[WI1 +WF1 -1:WF2]}; //sign extned int part in2 ??wrong fix in2
//    if(WF1 < WF2) 
//    Fwire = {in1[WF1-1:0],{(WF2-WF1){1'b0}}};  //0 extend frac 1
//    if(WF2 < WF1) 
//    Fwire2 = {in2[WF1-1:0],{(WF1-WF2){1'b0}}};  //0 extend frac2
    
//    in1T = {Iwire,Fwire};   //must  sign extend? or did I already
//    in2T = {Iwire2,Fwire2}; // Both are now same bitwidth
    
        
//       outT = in1T +in2T;   //correct full SUM
       
//       {Iwire,Fwire}= outT;   //parse out full Int and Frac again from SUM
      
 //    //*********************************************************************
 
 
   
    
    if(WI0 > (`ImaxPlus)) begin                       //greater bitwidth than INT part of SUM
    
   Iwire0 = {{(WI0-(`ImaxPlus)){outT[`ImaxPlus + `Fmax -1]}},Iwire};  
    end
    
    
    if(WF0 > (`Fmax +1)) begin
    
   Fwire0=  {Fwire,{(WF0-(`Fmax +1)){1'b0}}};
    end
      
      
      
      
    if(WI0 < (`ImaxPlus )) begin                         //I believe this should be max(WI1,WI2) +1
    
    
          Iwire0 = {Iwire[`ImaxPlus-1],Iwire[WI0-1:0]};      //keep sign bit and drop MSB of INT
//        Iwire0 = Iwire;                               //since lower bits go in first might be ok check on that
          tmp = {  Iwire[`ImaxPlus-1:(`ImaxPlus-WI0)]};

//                 if((in1[WI1+WF1-1] ==in2[WI2 +WF2 -1] ==(&tmp)) || (~in1[WI1+WF1-1] ==~in2[WI2 +WF2 -1] ==(|tmp))) begin  
                    if((Iwire[`ImaxPlus-1] ==(&tmp)) || (~Iwire[`ImaxPlus-1]  ==(|tmp))) begin   //sign bit check with tmp bits
                    OFV= 1'b0;
                    end
                    else OFV =1'b1;
         end
    
    
    
    if(WF0 < (`Fmax )) begin
    
   Fwire0=  Fwire[`Fmax-1:(`Fmax)-WF0];  //drop LSBs keep rest
   
    end
      
      
      
      
      
     
     if(WI0 == `Imax ) begin
     
     Iwire0= Iwire[`ImaxPlus-2:0]; //ignoring MSB only
      
                if((in1[WI1+WF1-1] ==in2[WI2 +WF2 -1] ==~out[WI0+WF0 -1]) || (~in1[WI1+WF1-1] ==~in2[WI2 +WF2 -1] ==out[WI0+WF0 -1]))   //what???
                OFV= 1'b1;
                else OFV =1'b0;
      
      end
      
     if(WF0 == `Fmax ) begin
        Fwire0= Fwire;
      
      end
      
      if(WI0 == `ImaxPlus) begin
       Iwire0= Iwire;
      end
      
      if(WF0 == `Fmax +1) begin   //neccessary since it carries over into INT part?
      Fwire0= Fwire;
      
      end
       
       
       
       
   if(rst)       
   out = 0;      
   else  out = {Iwire0,Fwire0};
   
    
    end   
endmodule
