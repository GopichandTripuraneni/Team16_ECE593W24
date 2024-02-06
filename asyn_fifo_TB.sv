module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  logic [DATA_WIDTH-1:0] data_out;
  logic full;
  logic empty;
  logic [DATA_WIDTH-1:0] data_in;
  logic w_en, clk, w_rst;
  logic r_en, r_rst;

  // Queue to push data_in
  logic [DATA_WIDTH-1:0] wdata_q[$], wdata;

  asynchronous_fifo as_fifo (clk, w_rst, r_rst,w_en,r_en,data_in,data_out,full,empty);

  always #10ns clk = ~clk;
  
  initial begin
    clk = 1'b0; w_rst = 1'b0;
    w_en = 1'b0;
    data_in = 0;
    
    repeat(10) @(posedge clk);
    w_rst = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk iff !full);
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_en) begin
          data_in = $urandom;
          wdata_q.push_back(data_in);
        end
      end
      #50;
    end
  end

  initial begin
    clk = 1'b0; r_rst = 1'b0;
    r_en = 1'b0;

    repeat(20) @(posedge clk);
    r_rst = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk iff !empty);
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en) begin
          wdata = wdata_q.pop_front();
          if(data_out !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
          else $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, data_out);
        end
      end
      #50;
    end

    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
