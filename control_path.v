module controlpath(output reg RegWrite,MemWrite,AluSrc,output reg [1:0]ImmSrc,ResultSrc,output reg [2:0]AluControl,input [31:0]Instr);
wire [6:0]op;wire [2:0]funct3;
reg Branch,Jump;
reg [1:0]ALUOp;
wire [1:0]decide;
parameter lw=7'b0000011,sw=7'b0100011,Rtype=7'b0110011,beq=7'b1100011,ITYPE=7'b0010011,jal=7'b1101111;
assign op=Instr[6:0];
assign funct3=Instr[14:12];
assign decide={Instr[5],Instr[30]};
always@(*)
begin 
if(op==lw)
begin 
RegWrite=1;
ImmSrc=0;
AluSrc=1;
MemWrite=0;
ResultSrc=1;
Branch=0;
ALUOp=0;
Jump=0;
end
else if(op==sw)
begin 
RegWrite=0;
ImmSrc=1;
AluSrc=1;
MemWrite=1;
ResultSrc=3;
Branch=0;
ALUOp=0;
Jump=0;
end
else if(op==Rtype)
begin
RegWrite=1;
ImmSrc=0;
AluSrc=0;
MemWrite=0;
ResultSrc=0;
Branch=0;
ALUOp=2;Jump=0;
end
else if(op==beq)
begin 
RegWrite=0;
ImmSrc=2;
AluSrc=0;
MemWrite=0;
ResultSrc=3;
Branch=1;
ALUOp=1;
Jump=0;
end
else if(op==ITYPE)
begin
RegWrite=1;
ImmSrc=0;
AluSrc=1;
MemWrite=0;
ResultSrc=0;
Branch=0;
ALUOp=2;
Jump=0;
end
else if(op==jal)
begin 
RegWrite=1;
ImmSrc=3;
AluSrc=1;
MemWrite=0;
ResultSrc=2;
Branch=0;
ALUOp=1'bx;
Jump=1;
end
else
begin 
RegWrite=1'bx;
ImmSrc=2'bxx;
AluSrc=1'bx;
MemWrite=1'bx;
ResultSrc=2'bxx;
Branch=1'bx;
ALUOp=1'bx;
Jump=1'bx;
end
end
always@(*)
begin
if(ALUOp==0)
AluControl=0;
else if(ALUOp==1)
AluControl=1;
else if(ALUOp==2)
begin 
if(funct3==2)
AluControl=5;
else if(funct3==6)
AluControl=3;
else if(funct3==7)
AluControl=2;
else if(funct3==0)
begin
if(decide==3)
AluControl=1;
else 
AluControl=0;
end
else 
AluControl=3'dx;
end
else 
AluControl=3'dx;
end
endmodule