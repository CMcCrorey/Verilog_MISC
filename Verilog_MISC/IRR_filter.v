`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//b0=10'b0100000000,b1=10'b0111011111,b2=10'b0100000000,a1=10'b1011001101,a2=10'b0001101110


module IRR_filter #(parameter WI =1, WF= 15, WIO=1, WFO=15, WIC=2, WFC=8) (
    input clk,rst,
    input signed [WI+WF-1: 0] x,
    output signed [WIO+WFO-1:0] y,  
 
    input signed [9:0] b0,b1,b2,a1,a2
    );
    
        reg RESET= 0;
//since its minus a1,a2
        wire [9:0] A1 =a1*-1;
        wire [9:0] A2 =a2*-1;
 //   m1 -m3
    localparam mI_1=WI, mI_2=WIC, mF_1=WF, mF_2= WFC, mIo= WIC +WI, mFo= WF + WFC;
    
  //  m4,m5
    localparam  _mI_1=WIO,   _mI_2=WIC, _mF_1=WFO, _mF_2= WFC, _mIo= WIC +WIO, _mFO= WFO + WFC;
    
    
   // a1 and a3
    localparam aI=mIo  ,Af=mFo,  aIo= mIo +1 ,aFo=mFo;
 //  a2 
   localparam aI1_ =aIo,  a1f_ =aFo,   aI2_ = mIo,  a2f_= mFo, aIo_= aIo, aFo_=aFo;
    
//  a3
//  localparam  aI=mIo  ,Af=mFo,  aIo= mIo +1 ,aFo=mFo;
  
 // a4
    localparam aI1_4 = aIo_, aI2_4 = aIo,  aF1_4 = aFo_, aF2_4 = aFo, OutI = WIO, OutF = WFO; 
  
    
    
wire signed [mIo+mFo-1: 0] xmul,xmu2,xmu3;
wire signed [aIo+aFo-1: 0] add_1;
wire signed [aIo_+ aFo_ -1: 0] add_2;
wire signed [aIo+aFo-1: 0] add_3;
reg signed [WI+WF-1:0] x_n1, x_n2;
//feedback
reg signed [WIO+WFO-1: 0]  y_n1, y_n2;
wire signed [_mIo + _mFO -1:0]  feed1, feed2; 
    
        // int parts frac parts , out, in
   
          Fp_mult #(.WI0(mIo),.WI1(mI_1),.WI2(mI_2),.WF0(mFo),.WF1(mF_1), .WF2(mF_2)) mu1(.rst(RESET), 
          .in1(temp), .in2(b0),.out(xmul),.OFV(OFV));

          Fp_mult #(.WI0(mIo),.WI1(mI_1),.WI2(mI_2),.WF0(mFo),.WF1(mF_1), .WF2(mF_2)) mu1_2( .rst(RESET), 
          .in1(x_n1), .in2(b1),.out(xmu2),.OFV(OFV));

          Fp_mult #(.WI0(mIo),.WI1(mI_1),.WI2(mI_2),.WF0(mFo),.WF1(mF_1), .WF2(mF_2)) mu1_3(.rst(RESET), 
          .in1(x_n2), .in2(b2),.out(xmu3),.OFV(OFV));

                                          
        //feedback mults
          Fp_mult #(.WI0(_mIo),.WI1(_mI_1),.WI2(WIC),.WF0( _mFO),.WF1(_mF_1), .WF2(mF_2)) mu1_4( .rst(RESET), 
          .in1(y_n1), .in2(A1),.out(feed1),.OFV(OFV));

          Fp_mult #(.WI0(_mIo),.WI1(_mI_1),.WI2(WIC),.WF0( _mFO),.WF1(_mF_1), .WF2(mF_2)) mu1_5( .rst(RESET), 
          .in1(y_n2), .in2(A2),.out(feed2),.OFV(OFV));
          
    //adders
          
          fp_adder #(.WI0(aIo),.WI1(aI),.WI2(aI),.WF0(aFo),.WF1(Af), .WF2(Af)) adder_1( .rst(RESET),
          .in1(xmu2), .in2(xmu3),.out(add_1),.OFV(OFV));

          fp_adder #(.WI0(aIo_),.WI1(aI1_),.WI2(aI2_),.WF0(aFo_),.WF1(a1f_),.WF2(a2f_)) adder_2( .rst(RESET), 
          .in1(add_1), .in2(xmul),.out(add_2),.OFV(OFV));
          
           fp_adder #(.WI0(aIo),.WI1(aI),.WI2(aI),.WF0( aFo),.WF1(Af), .WF2(Af)) adder_3( .rst(RESET),
          .in1(feed1), .in2(feed2),.out(add_3),.OFV(OFV));

          fp_adder #(.WI0(OutI),.WI1(aI1_4),.WI2(aI2_4),.WF0(OutF),.WF1(aF1_4),.WF2(aF2_4)) adder_4( .rst(RESET), 
          .in1(add_2), .in2(add_3),.out(y),.OFV(OFV));  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    reg RESET= 0;
////since its minus a1,a2
//        wire [9:0] A1 =a1*-1;
//        wire [9:0] A2 =a2*-1;

//    //params for multipliers
//    //mult params  B0-b3
//     localparam wiC=2, wfC=8, wi=WI,wf=WF, wio=(wiC + wi),wfo=(wfC +wf);
//     //nult params  A1, a2
//     localparam wi2=5,wf2=11,wio_2=7,wfo_2=19;  
     

//     //adder params a1-a4
//    localparam Awi=wio,Awf=wfo,  Awio= (wio+1),Awfo=wfo;
    
//    //diff input lengths
//    localparam Awi_2 =wio,Awf_2 =wfo,   Awi_22= Awio, Awf_22 =Awfo,  Awio_2 =8, Awfo_2=20;
    
    
//    localparam Awi_3 =wio_2 ,Awf_3 = wfo_2,  Awio_3 =8, Awfo_3= 19;
    
    
//    localparam Awi_4 = Awi_2, Awf_4 =Awf_2, Awi_42 =Awio_3, Awf_42 =Awfo_3  ,    Awio_4 =5, Awfo_4= 11;   //assumed 5.11


////wires and regs
//wire signed [wio+wfo-1: 0] xmul,xmu2,xmu3;

//wire signed [Awio+Awfo-1: 0] add_1;
//wire signed [Awio_2+Awfo_2-1: 0] add_2;
//wire signed [Awio_3+Awfo_3-1: 0] add_3;
//reg signed [wio+wfo-1: 0] x_n1, x_n2;
////feedback
//reg signed [Awio_4+Awfo_4-1: 0]  y_n1, y_n2;
//wire signed [wio_2+ wfo_2 -1:0]  feed1, feed2; 




 
     
     
     
//    //int parts frac parts , out, in
   
//          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wiC),.WF0(wfo),.WF1(wf), .WF2(wfC)) mu1(.rst(RESET), 
//          .in1(temp), .in2(b0),.out(xmul),.OFV(OFV));

//          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wiC),.WF0(wfo),.WF1(wf), .WF2(wfC)) mu1_2( .rst(RESET), 
//          .in1(x_n1), .in2(b1),.out(xmu2),.OFV(OFV));

//          Fp_mult #(.WI0(wio),.WI1(wi),.WI2(wiC),.WF0(wfo),.WF1(wf), .WF2(wfC)) mu1_3(.rst(RESET), 
//          .in1(x_n2), .in2(b2),.out(xmu3),.OFV(OFV));

//        //feedback mults
//          Fp_mult #(.WI0(wio_2),.WI1(wi2),.WI2(wiC),.WF0(wfo_2),.WF1(wf2), .WF2(wfC)) mu1_4( .rst(RESET), 
//          .in1(y_n1), .in2(A1),.out(feed1),.OFV(OFV));

//          Fp_mult #(.WI0(wio_2),.WI1(wi2),.WI2(wiC),.WF0(wfo_2),.WF1(wf2), .WF2(wfC)) mu1_5( .rst(RESET), 
//          .in1(y_n2), .in2(A2),.out(feed2),.OFV(OFV));
          
          
    
//    //adders
          
//          fp_adder #(.WI0(Awio),.WI1(Awi),.WI2(Awi),.WF0(Awfo),.WF1(Awf), .WF2(Awf)) adder_1( .rst(RESET),
//          .in1(xmu2), .in2(xmu3),.out(add_1),.OFV(OFV));

//          fp_adder #(.WI0(Awio_2),.WI1(Awi_2),.WI2(Awi_22),.WF0(Awfo_2),.WF1(Awf_2),.WF2(Awf_22)) adder_2( .rst(RESET), 
//          .in1(xmul), .in2(add_1),.out(add_2),.OFV(OFV));
          
//           fp_adder #(.WI0(Awio_3),.WI1(Awi_3),.WI2(Awi_3),.WF0( Awfo_3),.WF1(Awf_3), .WF2(Awf_3)) adder_3( .rst(RESET),
//          .in1(feed1), .in2(feed2),.out(add_3),.OFV(OFV));

//          fp_adder #(.WI0(Awio_4),.WI1(Awi_4),.WI2(Awi_42),.WF0(Awfo_4),.WF1(Awf_4),.WF2(Awf_42)) adder_4( .rst(RESET), 
//          .in1(add_2), .in2(add_3),.out(y),.OFV(OFV));




 reg [WI+WF-1: 0] temp; //to sychronize timing


    always @(posedge clk ) begin
    
    if(rst) begin
    temp <=0;
    x_n1 <=0;
    x_n2 <=0;
    y_n1 <= 0;
    y_n2 <= 0;
    end
    
    else begin 
     temp <=x;         
    x_n1<= temp;          
    x_n2 <= x_n1;
    y_n1 <=y;
    y_n2 <= y_n1;
    
    end
    end



    
    
endmodule
