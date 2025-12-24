// Code your design here
module axi_lite_master #(parameter ADDR_WIDTH=32,
                         parameter DATA_WIDTH=32)
  ( // Global signals
    input aclk,arst,
    // User Interface Signals
    input wreq,
    input [ADDR_WIDTH-1:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input [(DATA_WIDTH/8)-1:0] strb,
    input [ADDR_WIDTH-1:0] raddr,
    input rreq,
    output reg [DATA_WIDTH-1:0] rdata,
    
    // WRITE ADDR CHANNEL
    output reg [ADDR_WIDTH-1:0] axi_awaddr,
    output reg axi_awvalid,
    input axi_awready,
    
    // WRITE DATA CHANNEL
    output reg [DATA_WIDTH-1:0] axi_wdata,
    output reg [(DATA_WIDTH/8)-1:0] axi_wstrb,
    output reg axi_wvalid,
    input axi_wready,
    
    // WRITE RESPONE CHANNEL
    input [1:0] bresp,
    input bvalid,
    output reg bready,
    
    // READ ADDR CHANNEL
    output reg [ADDR_WIDTH-1:0] axi_araddr,
    output reg axi_arvalid,
    input axi_arready,
    
    // READ DATA CHANNEL
    input [DATA_WIDTH-1:0] axi_rdata,
    input axi_rvalid,
    input [1:0] axi_rresp,
    output reg axi_rready);
  
  
  // WRITE ADDR CHANNEL LOGIC
  always @(posedge aclk or negedge arst) begin
    if (~arst)begin
      axi_awvalid <= 1'b0;
      axi_awaddr <= {ADDR_WIDTH{1'b0}};
    end
    else begin
      if (wreq && ~axi_awvalid) begin
        axi_awvalid <=1'b1;
        axi_awaddr <= waddr;
      end
      else if (axi_awvalid && axi_awready) begin
        axi_awvalid <= 1'b0;
      end
    end
  end
  
  // WRITE DATA CHANNEL LOGIC
  always @(posedge aclk or negedge arst) begin
    if (~arst) begin
      axi_wvalid <= 1'b0;
      axi_wdata <= {DATA_WIDTH{1'b0}};
      axi_wstrb <= {(DATA_WIDTH/8){1'b0}};
    end
    else begin
      if (wreq && ~axi_wvalid) begin
        axi_wvalid <= 1'b1;
        axi_wdata <= wdata;
        axi_wstrb <= strb;
      end
      else if (axi_wvalid && axi_wready) begin
        axi_wvalid <= 1'b0;
      end
    end
  end
  
  // WRITE RESPONE CHANNEL LOGIC
  always @(posedge aclk or negedge arst) begin
    if (~arst) begin
      bready <= 1'b1;
    end
    else begin
      if (bvalid)
        bready <= 1'b1;
      else 
        bready <= 1'b1;
    end
  end
  
  // READ ADDR CHANNEL LOGIC
  always @(posedge aclk or negedge arst)begin
    if (~arst) begin
      axi_arvalid <= 1'b0;
      axi_araddr <= {ADDR_WIDTH{1'b0}};
    end
    else begin
      if (rreq && ~axi_arvalid)begin
        axi_arvalid <= 1'b1;
        axi_araddr <= raddr;
      end
      else if (axi_arvalid && axi_arready) begin
        axi_arvalid <=1'b0;
      end
    end
  end
  
  // READ DATA CHANNEL LOGIC 
  always @(posedge aclk or negedge arst)begin
    if (~arst) begin
      axi_rready <= 1'b0;
      rdata <= {DATA_WIDTH{1'b0}};
    end
    else begin
      axi_rready <= 1'b1;
      
      if (axi_rvalid && axi_rready) begin
        rdata<= axi_rdata;
      end
    end
  end
endmodule
  
