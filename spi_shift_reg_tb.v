`define SPI_MAX_CHAR 8   // Example value, replace with your desired width
`define SPI_DIVIDER_LEN 8 

module spi_clgen_tb();
  // Inputs
  reg wb_clk_in, wb_rst, go, tip, last_clk;
  reg [`SPI_DIVIDER_LEN-1:0] divider;
  wire sclk_out, cpol_0, cpol_1;
  
  // Instantiate the spi_clgen module
  spi_clgen DUT(.wb_clk_in(wb_clk_in), .wb_rst(wb_rst), .go(go),
		.tip(tip), .last_clk(last_clk), .divider(divider),
		.sclk_out(sclk_out), .cpol_0(cpol_0), .cpol_1(cpol_1));
   
  // Clock generation
  always #5 wb_clk_in = ~wb_clk_in;
   
  // Stimulus generation
  initial begin
    wb_clk_in = 0;
    wb_rst = 1;
    #13;
    wb_rst = 0;
    go = 0;
    tip = 0;
    divider = 0;
    #7;
    divider = 1;
    #10;
    go = 1;
    #10;
    tip = 1;
    last_clk = 0;
    #100;
    $finish;
  end
endmodule

module spi_shift_reg_tb;
  // Inputs
  parameter SPI_MAX_CHAR = `SPI_MAX_CHAR;
  parameter SPI_DIVIDER_LEN = `SPI_DIVIDER_LEN;
  reg wb_clk_in, wb_rst, lsb, go, miso, tx_negedge, rx_negedge;
  wire [SPI_MAX_CHAR-1:0] p_out;
  reg [3:0] latch, byte_sel;
  wire sclk, cpol_0, cpol_1, tip, mosi, last;
  reg [2:0] len;
  reg [31:0] p_in;
  reg [SPI_DIVIDER_LEN-1:0] divider;
  
  spi_clgen dut(.wb_clk_in(wb_clk_in), .wb_rst(wb_rst), .tip(tip),
		.go(go), .last_clk(last), .divider(divider),
		.sclk_out(sclk), .cpol_0(cpol_0), .cpol_1(cpol_1));

  spi_shift_reg dut1( .wb_clk_in(wb_clk_in), .wb_rst(wb_rst), .latch(latch),
		.byte_sel(byte_sel), .lsb(lsb), .go(go), .sclk(sclk),		// Connect sclk from spi_clgen to spi_shift_reg
		.cpol_0(cpol_0), .cpol_1(cpol_1), .len(len), .p_in(p_in),
		.tip(tip), .mosi(mosi), .miso(miso), .last(last), .p_out(p_out),
		.tx_negedge(tx_negedge), .rx_negedge(rx_negedge));

  // Generate clock
  always #10 wb_clk_in = ~wb_clk_in;

  initial begin
    // Initialize inputs
    wb_rst = 1;
    wb_clk_in = 0;
    latch = 4'b0001;
    byte_sel = 4'b0001;
    lsb = 1;
    p_in = 8'b101101;
    len = 3'b100;
    miso = 0;
    tx_negedge = 1;
    rx_negedge = 0;
    wb_rst = 1;
    divider = 1;
    go = 1;
    
    // Apply reset
    #10 wb_rst = 0;

    // Wait for reset to complete
    #20;
   
    // Wait for transmission to complete or timeout
    #1000
    $finish;
  end
endmodule
