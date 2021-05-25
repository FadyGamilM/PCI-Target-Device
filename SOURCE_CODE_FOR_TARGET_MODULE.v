module TARGET_DEVICE(output reg DEVSELn, output reg TRDYn, input resetn,
		   inout [31:0]AD, input FRAMEn, input IRDYn,
		   input CLK, input [3:0]CBE, output reg STOP);

// ===> in the next 2 lines i defined my buffer with 4 registers from AF0 to AF3.
    reg [31:0]DATA_BUFFER[0:3];

// ==> range of addresses of Basic DATA_BUFFER1 from FA0 : FA3.
    parameter addressR1=32'h00000FA0, addressR2=32'h00000FA1,
		addressR3=32'h00000FA2,addressR4=32'h00000FA3; 
    
    reg [1:0]FROM_WHERE=2'bz;
    integer i_wr=0;
    integer i_r=0;
    integer back=0;
    integer cr=0;

    always@(negedge resetn)
     begin

     TRDYn=1'b1; DEVSELn=1'b1;
     DATA_BUFFER[0]=32'hA0A0B0B0; DATA_BUFFER[1]=32'hC0C0D0D0;
     DATA_BUFFER[2]=32'h00111100; DATA_BUFFER[3]=32'h10101010; 
     DEVSELn=1'b1; TRDYn=1'b1; STOP=1'b1;
     end 

//==> command lines for basic IO read /write operations
    parameter CBE_READ=4'b0010;//readC=2
    parameter CBE_WRITE=4'b0011;//writeC=3
 
    reg address_indicator=1'b0;//indicates that my target encode the address 
    reg writing_indicator=1'b0;
    reg reading_indicator=1'b0; 
    
    always@(posedge CLK)
     begin
     if(AD<=addressR4 && AD>=addressR1&&TRDYn) 
      begin 
	address_indicator=1'b1;// iam the target
	case(AD[0])
	0:FROM_WHERE=0;//start from R1
	1:FROM_WHERE=1;//start from R2
	2:FROM_WHERE=2;//start from R3
	3:FROM_WHERE=3;//start from R4
	endcase i_r=FROM_WHERE; i_wr=FROM_WHERE;
                back=FROM_WHERE; cr=FROM_WHERE; 
      end
     end

// ===> we respond to the event and send our respond at -ve edge .
    always@(negedge CLK)
    begin 
     if(address_indicator)
	begin DEVSELn=1'b0; if(writing_indicator)begin TRDYn=1'b0;end end 
    end 

    reg [31:0] MyDataForReadOperation=32'hzzzzzzzz;
    assign AD=MyDataForReadOperation;


//===> TO know the type of operation " Command "
    always@(posedge CLK)
    begin 
    if(address_indicator)
     begin
     if(CBE==CBE_WRITE) writing_indicator=1'b1; 
     else
     begin
      if(CBE==CBE_READ)
      begin
      reading_indicator=1'b1;
      writing_indicator=1'b0;
      end 
      end 
     end
    end

// ===> this section for READ operation to catch the positive edge which in TURNAROUND CYCLE to 
        //be able to assert the TRDYn signal at the next -Ve edge of same CLK cycle 
   reg targetedReadInd=1'b0; //indication to me to assert TRDYn after TURNAROUND cycle in READ operation
   always@(posedge CLK)
     begin
      if(address_indicator&&reading_indicator&&CBE!=CBE_READ)
      targetedReadInd=1'b1;
     end  

   always@(negedge CLK)
    begin 
     if(targetedReadInd) TRDYn=1'b0;
    end

//===> Data Transfer state :
 reg [31:0]DATA_BUFFER2[0:7];
 always@(negedge resetn) 
  begin
   DATA_BUFFER2[0]=32'hzzzzzzzz; DATA_BUFFER2[1]=32'hzzzzzzzz;
   DATA_BUFFER2[2]=32'hzzzzzzzz; DATA_BUFFER2[3]=32'hzzzzzzzz;
   DATA_BUFFER2[4]=32'hzzzzzzzz; DATA_BUFFER2[5]=32'hzzzzzzzz;
   DATA_BUFFER2[6]=32'hzzzzzzzz; DATA_BUFFER2[7]=32'hzzzzzzzz;
  end

  reg over_flow; integer capacity=0;	//reg pointer=FROM_WHERE; reg capacity=1'b0; reg ratio=1'b1;
  always@(negedge CLK)
  begin
if(~TRDYn && writing_indicator)
begin 
    if(i_wr<=3)
       begin 
    DATA_BUFFER[i_wr][31:24]=AD[31:24]&{8{CBE[3]}};
    DATA_BUFFER[i_wr][23:16]=AD[23:16]&{8{CBE[2]}};
    DATA_BUFFER[i_wr][15:8]=AD[15:8]&{8{CBE[1]}};
    DATA_BUFFER[i_wr][7:0]=AD[7:0]&{8{CBE[0]}};
    capacity=capacity+1;
    i_wr=i_wr+1;
    //pointer=pointer+1; capacity=capacity+1; 
        end
    else if(capacity<4)
   begin					 
   if(capacity==3 && back==1)
   begin
   DATA_BUFFER[back-1][31:24]=AD[31:24]&{8{CBE[3]}};
   DATA_BUFFER[back-1][23:16]=AD[23:16]&{8{CBE[2]}};
   DATA_BUFFER[back-1][15:8]=AD[15:8]&{8{CBE[1]}};
   DATA_BUFFER[back-1][7:0]=AD[7:0]&{8{CBE[0]}};
   capacity =capacity+1; back=back+1; //i_wr=i_wr+1;
   end

   if(capacity==2 && back==2)
   begin
   DATA_BUFFER[back-1][31:24]=AD[31:24]&{8{CBE[3]}};
   DATA_BUFFER[back-1][23:16]=AD[23:16]&{8{CBE[2]}};
   DATA_BUFFER[back-1][15:8]=AD[15:8]&{8{CBE[1]}};
   DATA_BUFFER[back-1][7:0]=AD[7:0]&{8{CBE[0]}};
   capacity =capacity+1; back=back+1; 
    end
			
   if(capacity==1 && back==3)
   begin
   DATA_BUFFER[back-1][31:24]=AD[31:24]&{8{CBE[3]}};
   DATA_BUFFER[back-1][23:16]=AD[23:16]&{8{CBE[2]}};
   DATA_BUFFER[back-1][15:8]=AD[15:8]&{8{CBE[1]}};
   DATA_BUFFER[back-1][7:0]=AD[7:0]&{8{CBE[0]}};
   capacity =capacity+1; back=back+1; 
   end
   end
  else
   begin
if(capacity>=4) begin
if(i_wr==4) begin TRDYn=1'b1;
   DATA_BUFFER2[0]=DATA_BUFFER[0];  
   DATA_BUFFER2[1]=DATA_BUFFER[1];
   DATA_BUFFER2[2]=DATA_BUFFER[2];
   DATA_BUFFER2[3]=DATA_BUFFER[3]; end
if(capacity<=8)begin

   DATA_BUFFER2[i_wr][31:24]=AD[31:24]&{8{CBE[3]}};
   DATA_BUFFER2[i_wr][23:16]=AD[23:16]&{8{CBE[2]}};
   DATA_BUFFER2[i_wr][15:8]=AD[15:8]&{8{CBE[1]}};
   DATA_BUFFER2[i_wr][7:0]=AD[7:0]&{8{CBE[0]}};   
   i_wr=i_wr+1; capacity=capacity+1; end
else
begin
STOP=1'b0;
end
    end end	
   end		   
   end
/*always@(negedge CLK)
begin
if(capacity>8) begin STOP=1'b0; end
end
*/

wire LastDataTransfer=FRAMEn & ~IRDYn & ~TRDYn ;
reg EndTransactionEn=1'bz;
always@(posedge CLK)
 if(LastDataTransfer)
 begin 
EndTransactionEn=1;
 address_indicator=1'b0;
 end
always@(negedge CLK) 
if(EndTransactionEn)
begin 
TRDYn=1; writing_indicator=1'b0;
 if(address_indicator==1'b0)
begin
 DEVSELn=1;
end 
end



reg NewDataPhase=1'b0;
integer backr=0;

always@(posedge CLK)
begin
  if( ~FRAMEn && CBE!=CBE_READ && reading_indicator) 
    begin 
 if(~IRDYn)
 begin 
NewDataPhase=1'b1; i_r=i_r+1; 
 end
 end 
  else NewDataPhase=1'b0;
end

integer readingcounter=0; integer DB2counter=4;
always@(negedge CLK)
begin
if(NewDataPhase)
 begin 
if (i_r<=4)
 begin 
MyDataForReadOperation=DATA_BUFFER[i_r-1]; 
 TRDYn=1'b0;
 end 
else if(i_r>4)
begin 
if(readingcounter<FROM_WHERE)
 begin
 MyDataForReadOperation=DATA_BUFFER[readingcounter]; 
TRDYn=1'b0;
 readingcounter=readingcounter+1; /*STOP=1'b1;*/ 
 end 
else 
begin
 MyDataForReadOperation=DATA_BUFFER2[DB2counter];
 TRDYn=1'b0;
 DB2counter=DB2counter+1;
 end 
end
 end


end

always@(negedge CLK)
begin 
if(FRAMEn && TRDYn && ~NewDataPhase && IRDYn)
 MyDataForReadOperation=32'hzzzzzzzz;
end




always @(posedge CLK or negedge CLK)
begin
if(~STOP)
begin 
TRDYn=1'b1;
MyDataForReadOperation=32'hzzzzzzzz;
DEVSELn=1'b1;
end

end	



endmodule
/*
always@(negedge CLK)
begin 
if(capacity ==4)
begin TRDYn=1'b1; end
else
begin TRDYn=1'b0; end
 end
*/
/*reg firstoverflow=1'b0;
always@(posedge CLK)
 begin 
if(capacity>4)
 begin
 firstoverflow=1'b1;
end
 else
 begin
 firstoverflow=1'b0;
 end
 end
always@(negedge CLK)
 if
(firstoverflow) 
begin 
TRDYn=1'b1;
 end*/

