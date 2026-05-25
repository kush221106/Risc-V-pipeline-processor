`include "top.v"
`timescale 1ps/1ps
module tb();
reg clk,reset_n;
top tp(clk,reset_n);
always #5 clk=~clk;
initial begin
    clk=0;
    reset_n=0;
    #12 reset_n=1;
end
initial
begin
$dumpfile("zizo.vcd");
$dumpvars(0,tb);
#700 $finish;
end
endmodule