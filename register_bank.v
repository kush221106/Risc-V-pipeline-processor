module register_file(output wire [31:0]RD1,RD2,input [4:0]A1,A2,A3,input [31:0]WD3,input WE3,clk);
reg [31:0] registers[31:0];
integer i;
initial 
begin 
for(i=0;i<32;i=i+1)
registers[i]<=32'd0;
end
always@(negedge clk)
begin
if(WE3&A3!=0)
registers[A3]<=WD3;
end
assign RD1=(A1==0)?32'd0:registers[A1];
assign RD2=(A2==0)?32'd0:registers[A2];
endmodule