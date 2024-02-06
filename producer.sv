module producer #(parameter ADDR_WIDTH=9)(
  input logic clk,w_en,w_rst,
  input logic [ADDR_WIDTH:0]Gray_rptrsync,
  output logic full, [ADDR_WIDTH:0]gray_wptr,binary_wptr
);
  
  logic w_full;
  logic[ADDR_WIDTH:0]binary_wptr_nxt;
  logic[ADDR_WIDTH:0]gray_wptr_nxt;
  
  always@(posedge clk or negedge w_rst)begin
    if(!w_rst)begin
      binary_wptr <= 0;
      gray_wptr <=0;
    end
    else begin
      binary_wptr <= binary_wptr_nxt;
      gray_wptr <= gray_wptr_nxt;
    end
  end
  
  assign binary_wptr_nxt = !w_full ? binary_wptr+ w_en: binary_wptr;
  assign gray_wptr_nxt = (binary_wptr_nxt>>1) ^ binary_wptr_nxt; 
  
  always@(posedge clk or negedge w_rst) begin
    if(!w_rst) full <= 0;
    else       full <= w_full;
  end
  
endmodule