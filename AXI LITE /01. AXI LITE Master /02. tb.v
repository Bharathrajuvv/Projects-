// Code your testbench here
// or browse Examples
module tb;
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  // USER INTERFACE SIGNALS 
  reg aclk,arst,wreq,rreq;
  reg [ADDR_WIDTH-1:0] waddr;
  reg [DATA_WIDTH-1:0] wdata;
  reg [(DATA_WIDTH/8)-1:0] strb;
  reg [ADDR_WIDTH-1:0] raddr;
  wire [DATA_WIDTH-1:0] rdata;
  
  // WRITE ADDR SIGNALS
  wire [ADDR_WIDTH-1:0] axi_awaddr;
  wire axi_awvalid;
  reg axi_awready;
  
  // WRITE DATA SIGNALS 
  wire [DATA_WIDTH-1:0] axi_wdata;
  wire [DATA_WIDTH-1:0] axi_wstrb;
  wire axi_wvalid;
  reg axi_wready;
  
  // WRITE RESPONE SIGNALS 
  reg [1:0] bresp;
  reg bvalid;
  wire bready;
  
  // READ ADDR SIGNALS
  wire [ADDR_WIDTH-1:0] axi_araddr;
  wire axi_arvalid;
  reg axi_arready;
  
  // READ DATA SIGNALS 
  reg [DATA_WIDTH-1:0] axi_rdata;
  reg axi_rvalid;
  reg [1:0] axi_rresp;
  wire axi_rready;
  
  axi_lite_master duv (.aclk(aclk),.arst(arst),
                             .wreq(wreq),.waddr(waddr),.wdata(wdata),.strb(strb),.raddr(raddr),.rreq(rreq),.rdata(rdata),
                             .axi_awaddr(axi_awaddr),.axi_awvalid(axi_awvalid),.axi_awready(axi_awready),
                             .axi_wdata(axi_wdata),.axi_wstrb(axi_wstrb),.axi_wvalid(axi_wvalid),.axi_wready(axi_wready),
                             .bresp(bresp),.bvalid(bvalid),.bready(bready),
                             .axi_araddr(axi_araddr),.axi_arvalid(axi_arvalid),.axi_arready(axi_arready),
                             .axi_rdata(axi_rdata),.axi_rvalid(axi_rvalid),.axi_rresp(axi_rresp),.axi_rready(axi_rready));
  
  always #5 aclk = ~aclk;
  initial begin
    aclk = 0;
    arst = 0;
    wreq = 0;
    rreq = 0;

    axi_awready = 0;
    axi_wready  = 0;
    bvalid      = 0;
    axi_arready = 0;
    axi_rvalid  = 0;

    bresp = 2'b00;
    axi_rresp = 2'b00;
    axi_rdata = 32'h0;

    #20 arst = 1;

  
    @(posedge aclk);
    waddr = 32'h0000_0010;
    wdata = 32'hA5A5_1234;
    strb  = 4'b1111;
    wreq  = 1'b1;

    @(posedge aclk);
    wreq = 1'b0;

    wait(axi_awvalid);
    axi_awready = 1;
    axi_wready  = 1;

    @(posedge aclk);
    axi_awready = 0;
    axi_wready  = 0;

    // Write response
    #10;
    bvalid = 1;
    @(posedge aclk);
    bvalid = 0;

    @(posedge aclk);
    raddr = 32'h0000_0010;
    rreq  = 1'b1;

    @(posedge aclk);
    rreq = 1'b0;

    wait(axi_arvalid);
    axi_arready = 1;

    @(posedge aclk);
    axi_arready = 0;

    // Read data
    #10;
    axi_rdata  = 32'hDEAD_BEEF;
    axi_rvalid = 1;

    @(posedge aclk);
    axi_rvalid = 0;

    // Finish
    #50;
    $finish;
  end
  initial begin
    $monitor("T=%0t | AWV=%b WVV=%b BV=%b ARV=%b RV=%b RDATA=%h",
              $time, axi_awvalid, axi_wvalid, bvalid,
              axi_arvalid, axi_rvalid, rdata);
  end
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
  end

endmodule
