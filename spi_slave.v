module spi_slave (input sclk,mosi,
                  input ss_pad_o,
                  output miso);

      reg rx_slave = 1'b0;
      reg tx_slave = 1'b0;
 
  reg [127:0]temp1 = {1'b0,{123{1'b0}},4'b0000};
  reg [127:0]temp2 = {1'b0,{123{1'b0}},4'b0000};

  reg miso1 = 1'b0;
  reg miso2 = 1'b0;

 always@(posedge sclk)
    begin
      if ((ss_pad_o != 8'b11111111) && rx_slave && ~tx_slave)
 
           begin
    temp1 <= {temp1[126:0],mosi};
          end
 end

 always@(negedge sclk)
    begin
      if ((ss_pad_o != 8'b11111111) && ~rx_slave && tx_slave)
 
           begin
    temp2 <= {temp2[126:0],mosi};
          end
 end

 always@(negedge sclk)
    begin
      if (rx_slave && ~tx_slave)
 
           begin
    miso1 <= temp1[127];
          end
 end

 always@(posedge sclk)
    begin
      if (~rx_slave && tx_slave)
 
           begin
    miso2 <= temp2[127];
          end
 end

 assign miso = miso1 || miso2 ;

endmodule