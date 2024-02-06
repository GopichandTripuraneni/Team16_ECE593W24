module flopsynchronizer #(parameter width=9)(
  input logic clk,rst,[width:0]data_in,
  output logic [width:0]data_out);
  
  always@(posedge clk)begin
    if(!rst)begin
      q1<=0;
      data_out=0;
    end
    else begin
      q1<= data_in;
      data_out<=q1;
    end
endmodule