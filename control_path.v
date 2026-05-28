module controlpath(output reg RegWrite,MemWrite,AluSrc,output reg [2:0]ImmSrc,output reg[1:0]ResultSrc,output reg [3:0]AluControl,input [31:0]Instr);
wire [6:0]op;wire [2:0]funct3;
reg [1:0]ALUOp;
wire [1:0]decide;
wire dec;
parameter lw=7'b0000011,sw=7'b0100011,Rtype=7'b0110011,beq=7'b1100011,ITYPE=7'b0010011,jal=7'b1101111,jalr=7'b1100111,Auipc=7'b0010111,lui=7'b0110111;
assign op=Instr[6:0];
assign funct3=Instr[14:12];
assign decide={Instr[30],Instr[5]};
assign dec=Instr[30];
always@(*)
begin 
if(op==lw)
begin 
RegWrite=1;
ImmSrc=0;
AluSrc=1;
MemWrite=0;
ResultSrc=1;
ALUOp=0;
end
else if(op==sw)
begin 
RegWrite=0;
ImmSrc=1;
AluSrc=1;
MemWrite=1;
ResultSrc=3;
ALUOp=0;
end
else if(op==Rtype)
begin
RegWrite=1;
ImmSrc=0;
AluSrc=0;
MemWrite=0;
ResultSrc=0;
ALUOp=2;
end
else if(op==beq)
begin 
RegWrite=0;
ImmSrc=2;
AluSrc=0;
MemWrite=0;
ResultSrc=3;
ALUOp=1;
end
else if(op==ITYPE)
begin
RegWrite=1;
ImmSrc=0;
AluSrc=1;
MemWrite=0;
ResultSrc=0;
ALUOp=2;
end
else if(op==jal)
begin 
RegWrite=1;
ImmSrc=3;
AluSrc=1;
MemWrite=0;
ResultSrc=2;
ALUOp=1'bx;
end
else if(op==jalr)
begin 
RegWrite=1;
MemWrite=0;
ResultSrc=2;
AluSrc=1;
ALUOp=0;
ImmSrc=0;
end
else if(op==Auipc)
begin 
ImmSrc=4;
RegWrite=1;
MemWrite=0;
ResultSrc=3;
ALUOp=3;
AluSrc=1;
end
else if(op==lui)
begin 
ImmSrc=4;
RegWrite=1;
MemWrite=0;
ResultSrc=0;
ALUOp=3;
AluSrc=1;
end
else
begin 
RegWrite=1'bx;
ImmSrc=3'bx;
AluSrc=1'bx;
MemWrite=1'bx;
ResultSrc=2'bx;
ALUOp=2'bx;
end
end
always@(*)
begin
if(ALUOp==0)
    AluControl=0;
else if(ALUOp==1)
begin 
    if(funct3==0)
    AluControl=10;
    else if(funct3==1)
    AluControl=11;
    else if(funct3==4)
    AluControl=3;
    else if(funct3==5)
    AluControl=12;
    else if(funct3==6)
    AluControl=4;
    else if(funct3==7)
    AluControl=13;
    else 
    AluControl=4'bx;
end
else if(ALUOp==2)
begin 
    if(funct3==0&decide==3)
    AluControl=1;
    else if(funct3==0)
    AluControl=0;
    else if(funct3==1)
    AluControl=2;
    else if(funct3==2)
    AluControl=3;
    else if(funct3==3)
    AluControl=4;
    else if(funct3==4)
    AluControl=5;
    else if(funct3==5&dec==0)
    AluControl=6;
    else if(funct3==5)
    AluControl=7;
    else if(funct3==6)
    AluControl=8;
    else if(funct3==7)
    AluControl=9;
    else 
    AluControl=4'bx;
end
else if(ALUOp==3)
    AluControl=15;
else 
    AluControl=4'bx;
end
endmodule
