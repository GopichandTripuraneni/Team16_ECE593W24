`include "flopsynchronizer.sv"
`include "producer.sv"
`include "consumer.sv"
`include "fifomemory.sv"

module asynchronous_fifo #(parameter DEPTH=512, DATA_WIDTH=8) (
  input logic clk, w_rst,
  input logic r_rst,
  input logic w_en, r_en,
  input logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out,
  output logic full, empty
);
  
  parameter ADDR_WIDTH = $clog2(DEPTH);
 
  logic [ADDR_WIDTH:0] gray_wptrsync, gray_rptrsync;
  logic [ADDR_WIDTH:0] binary_wptr, binary_rptr;
  logic [ADDR_WIDTH:0] gray_wptr, gray_rptr;


  flopsynchronizer #(ADDR_WIDTH) sync_wptr (clk, r_rst, gray_wptr, gray_wptrsync); //write pointer to read clock domain
  flopsynchronizer #(ADDR_WIDTH) sync_rptr (clk, w_rst, gray_rptr, gray_rptrsync); //read pointer to write clock domain 
  
  producer #(ADDR_WIDTH) w_ptr_h(wclk, w_rst, w_en,gray_rptrsync,binary_wptr,gray_wptr,full);
  consumer #(ADDR_WIDTH) r_ptr_h(rclk, r_rst, r_en,gray_wptrsync,binary_rptr,gray_rptr,empty);
  fifomemory fifomem(clk, w_en, r_en,binary_wptr, binary_rptr, data_in,full,empty, data_out);

endmodule