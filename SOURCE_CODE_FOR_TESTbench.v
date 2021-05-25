module basic_READ_S1;
wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
   #0  resetn=1'b0; framen=1'b1; wr=1'b0; irdyn=1'b1; cben=4'bzzzz;
   #10 resetn=1'b1; framen=1'b0; DIN =32'h00000FA1; cben=4'b0010; wr=1'b1; //10
   #10 irdyn=1'b0; wr=1'b0; cben=4'b0000;//20
   #20 cben=4'b1111; //30
  #10 cben=4'b0101;framen=1'b1;
  #10 cben=4'bzzzz; irdyn=1'b1; resetn=1'b0;
end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);

endmodule




module READ_IRDY_busy_S2;
	wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
#0  resetn=1'b0; framen=1'b1; wr=1'b0; irdyn=1'b1; cben=4'bzzzz;
#10 resetn=1'b1; framen=1'b0; DIN =32'h00000FA1; cben=4'b0010; wr=1'b1; //10
#10 irdyn=1'b0; wr=1'b0; cben=4'b0000;//20
#20 cben=4'b1111; irdyn=1'b1;
#10 irdyn=1'b0; //30
#10 cben=4'b0101;framen=1'b1;
#10 cben=4'bzzzz; irdyn=1'b1; 

end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);
endmodule





module basic_WRITE_READ_S3;
wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
	#0  resetn=1'b0; framen=1'b1; wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//0
	#10 framen=1'b0; wr=1'b1;  DIN=32'h00000FA1; cben=4'b0011;resetn=1'b1;//10
	#10 DIN=32'h01011010; irdyn=1'b0; cben=4'b0111;//20
	#10 DIN=32'h00011111; cben=4'b0000;//30
	#10 DIN=32'h00001111; cben=4'b0011;//40
	#10 DIN=32'h11000111; cben=4'b1110; framen=1'b1;//60
	#10  wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//70
	#10 framen=1'b0; cben=4'b0010; wr=1'b1; DIN=32'h00000FA1;//80
	#10 wr=1'b0; cben=4'b1011; irdyn=1'b0;//90
	#20 cben=4'b0011; //100	
	#10 cben=4'b1111; //irdyn=1'b1;//110
      	#10 cben=4'b1011; framen=1'b1; //120
	#10 cben=4'bzzzz; wr=1'b1; DIN=32'hzzzzzzzz; irdyn=1'b1; resetn=1'b0;//130
   end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);

endmodule 




module WRITE_READ_IRDY_busy_S4;
	wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
         #0  resetn=1'b0; framen=1'b1; wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//0
	#10 framen=1'b0; wr=1'b1;  DIN=32'h00000FA1; cben=4'b0011;resetn=1'b1;//10
	#10 DIN=32'h01011010; irdyn=1'b0; cben=4'b0111;//20
	#10 DIN=32'h00011111; cben=4'b0000;//30
	#10 DIN=32'h00001111; cben=4'b0011;//40
	#10 DIN=32'h11000111; cben=4'b1110; framen=1'b1;//60
	#10  wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//70
	#10 framen=1'b0; cben=4'b0010; wr=1'b1; DIN=32'h00000FA1;//80
	#10 wr=1'b0; cben=4'b1011; irdyn=1'b0;//90
	#20 cben=4'b0011; //110
	#10 cben=4'b1111; irdyn=1'b1;//120
	#10 irdyn=1'b0;//130
        #10 cben=4'b1011; framen=1'b1; //150
	#10 cben=4'bzzzz; wr=1'b1; DIN=32'hzzzzzzzz; irdyn=1'b1;//160
       end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);
endmodule





module WRITE_READ_TRDY_busy_S5;
	wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
#0  resetn=1'b0; framen=1'b1; wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//0
#10 framen=1'b0; wr=1'b1;  DIN=32'h00000FA1; cben=4'b0011;resetn=1'b1;//10
#10 DIN=32'h01011010; irdyn=1'b0; cben=4'b0111;//20
#10 DIN=32'h00011111; cben=4'b0000;//30
#10 DIN=32'h00001111; cben=4'b0011;//40
#10 DIN=32'h01111111; cben=4'b0101;//50
#10 DIN=32'h11101110; cben=4'b1001; framen=1'b1;//60
#10 framen=1'b1;//70

#10  wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//80
#10 framen=1'b0; cben=4'b0010; wr=1'b1; DIN=32'h00000FA1;//90
#10 wr=1'b0; cben=4'b1011; irdyn=1'b0;//100
#20 cben=4'b0011; //120
#10 cben=4'b1111; //130
#10 cben=4'b0110; //140
#10 cben=4'b0101; framen=1'b1;//150

#10 cben=4'bzzzz; wr=1'b1; DIN=32'hzzzzzzzz; irdyn=1'b1;//180	
end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);

endmodule 




module WRITE_READ_TRDY_IRDY_busy_S6;
wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg clk=0;
	always #5 clk=~clk;
	initial begin
#0  resetn=1'b0; framen=1'b1; wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//0
#10 framen=1'b0; wr=1'b1;  DIN=32'h00000FA1; cben=4'b0011;resetn=1'b1;//10
#10 DIN=32'h01011010; irdyn=1'b0; cben=4'b0111;//20
#10 DIN=32'h00011111; cben=4'b0000;//30
#10 DIN=32'h00001111; cben=4'b0011;//40
#10 DIN=32'h01111111; cben=4'b0101;//50
#10 DIN=32'h11101110; cben=4'b1001; framen=1'b1;//60
#10 framen=1'b1;//70

#10  wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//80
#10 framen=1'b0; cben=4'b0010; wr=1'b1; DIN=32'h00000FA1;//90
#10 wr=1'b0; cben=4'b1011; irdyn=1'b0;//100
#20 cben=4'b0011; irdyn=1'b1; //120
#10 irdyn=1'b0;
#10 cben=4'b1111; //130
#10 cben=4'b0110; //140
#10 cben=4'b0101; framen=1'b1;//150

#10 cben=4'bzzzz; wr=1'b1; DIN=32'hzzzzzzzz; irdyn=1'b1;//180	
end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);
endmodule






module STOP_WRITE_READ_TRDY_IRDY_busy_S7;
wire [31:0] Datastoredinsidepci; wire devseln,trdyn;
	wire [31:0]ad; reg resetn; reg framen;
	reg irdyn; reg [3:0]cben;
	wire stop; reg wr; reg[31:0]DIN=32'h00000000;
	assign ad=(wr==1)?DIN:32'hzzzzzzzz;
        reg stopind=1'b0;
reg clk=0;
	always #5 clk=~clk;
	initial begin

#0  resetn=1'b0; framen=1'b1; wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//0
#10 framen=1'b0; wr=1'b1;  DIN=32'h00000FA1; cben=4'b0011;resetn=1'b1;//10
#10 DIN=32'h01011010; irdyn=1'b0; cben=4'b0111;//20
#10 DIN=32'h00011111; cben=4'b0000;//30
#10 DIN=32'h00001111; cben=4'b0011;//40
#10 DIN=32'h01111111; cben=4'b0101;//50
#10 DIN=32'h11101110; cben=4'b1101;
#20 DIN=32'h11111111; cben=4'b1110;
#10 DIN=32'h10011000; cben=4'b0100;
#10 DIN=32'h01011001; cben=4'b1000;
#10 framen=1'b1; if(stop) begin stopind=1'b1; irdyn=1'b1;  end DIN=32'h01A10011; cben=4'b1101; 
#10 if(stopind) begin wr=1'b0; cben=4'bzzzz; end
else
begin
 wr=1'b0; cben=4'bzzzz; irdyn=1'b1;//70
#10 framen=1'b0; cben=4'b0010; wr=1'b1; DIN=32'h00000FA1;//80
#10 wr=1'b0; cben=4'b1011; irdyn=1'b0;//90
#20 cben=4'b0011; irdyn=1'b1; //110
#10 cben=4'b1111; irdyn=1'b0; 
#10 cben=4'b0110;//140
#10 cben=4'b0101;
#10 cben=4'b1011; framen=1'b1; //150
#10 cben=4'bzzzz; wr=1'b1; DIN=32'hzzzzzzzz; irdyn=1'b1;
end
end
	TARGET_DEVICE PCI(devseln,trdyn,resetn,ad,framen,irdyn,clk,cben,stop);
endmodule

