module consumer #(parameter ADDR_WIDTH=9) (
  input logic clk, r_rst, r_en,
  input logic [ADDR_WIDTH:0] gray_wptrsync,
  output logic [ADDR_WIDTH:0] binary_rptr, gray_rptr,
  output logic empty
);

  logic [ADDR_WIDTH:0] binary_rptr_nxt;
  logic [ADDR_WIDTH:0] gray_rptr_nxt;

  assign binary_rptr_nxt = binary_rptr+(r_en & !empty);
  assign gray_rptr_nxt = (binary_rptr_nxt >>1)^binary_rptr_nxt;
  assign rempty = (gray_wptrsync == gray_rptr_nxt);
  
  always@(posedge clk or negedge r_rst) begin
    if(!r_rst) begin
      binary_rptr <= 0;
      gray_rptr <= 0;
    end
    else begin
      binary_rptr <= binary_rptr_nxt;
      gray_rptr <= gray_rptr_nxt;
    end
  end
  
  always@(posedge clk or negedge r_rst) begin
    if(!r_rst) empty <= 1;
    else        empty <= rempty;
  end
endmodule