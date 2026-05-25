module data_memory(output reg [31:0]read_data,input [31:0]A,input [31:0]WD,input MemWrite,clk);
reg [31:0]momory[63:0];
integer i;
initial 
begin 
for(i=0;i<256;i=i+1)
momory[i]<=32'd0;
end 
always@(posedge clk)
begin 
if(MemWrite)
momory[A[7:2]]<=WD;
end
always@(*)
begin
if(!MemWrite)
read_data=momory[A[7:2]];
end
endmodule