module spi_clkgen(wb_clk_in,wb_rst,go,tip,last_clk,divider,sclk_out,cpol_0,cpol_1);
input wb_clk_in;  //input clock
input wb_rst;     //reset
input tip;        //transfer in progress
input go;         //start transfer
input last_clk;   //last clock
input [7:0] divider;   //clock divider is divided by this amount
output sclk_out;       //output clock
output cpol_0;        //pulse marking positive edge of sclk_out
output cpol_1;       //pulse marking negative edge of sclk_out

reg sclk_out;
reg cpol_0;
reg cpol_1;
reg [7:0]cnt;      //counter

//counter counting half period
always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
  cnt<=8'b0;
  else if(tip)
  begin
    if(cnt==(divider+1))
      cnt<=8'b0;
    else
      cnt<=cnt+1;
  end
  else if(cnt==0)
    cnt <= 8'b00000001;

end

//generation of serial clock
always@(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
   begin
    sclk_out<=1'b0;
   end
  else if(tip) 
             begin
          if(cnt==(divider+1))
       begin
                if(!last_clk || sclk_out)
      sclk_out<= ~sclk_out;
                    end    
           end  
end

//posedge and negedge detection of sclk
always @(posedge wb_clk_in or posedge wb_rst)
begin
  if(wb_rst)
  begin
    cpol_0<=1'b0;
    cpol_1<=1'b0;
  end
  else 
  begin
    cpol_0<=1'b0;
    cpol_1<=1'b0;
    if(tip)
      begin
      if(~sclk_out)
        begin
        if(cnt==divider)
          begin
               cpol_0<=1;
          end
        end
      end
    if(tip)
       begin
      if(sclk_out)
         begin
        if(cnt==divider)
        begin
          cpol_1<=1;
        end
         end
       end
  end
end
initial begin
sclk_out=1'b0;
cnt=1'b0;
end
endmodule
