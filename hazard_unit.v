module hazardunit(output reg IF_stall,
                  output reg ID_stall,
                  output reg ID_flush,
                  output reg EX_stall,
                  output reg EX_flush,
                  output reg sel_write_data,
                  output reg selpc,
                  output reg [1:0]sela,
                  output reg [1:0]selb,
                  input [4:0]ID_rs1,
                  input [4:0]ID_rs2,
                  input [4:0]EX_rs1,
                  input [4:0]EX_rs2,
                  input [4:0]EX_rd,
                  input [4:0]MEM_rd,
                  input [4:0]MEM_rs2,
                  input [4:0]WB_rd,
                  input MEM_regwrite,
                  input WB_regwrite,
                  input ID_jal,
                  input ID_rtype,
                  input ID_branch,
                  input MEM_jump,
                  input WB_lw,
                  input EX_lw,
                  input misprediction,
                  input reset_n);
//this is for the data hazard
always@(*)
begin
if(!reset_n)
begin 
     IF_stall=0;
     ID_flush=0;
     ID_stall=0;
     EX_stall=0;
     EX_flush=0;
     selpc=0;
end
//this is to include stall cycle and one bubble in the ex
else if(misprediction)
begin  
      IF_stall=0;
      ID_stall=0;
      EX_stall=0;
      ID_flush=1;
      EX_flush=1;
      selpc=1;
end
else if(EX_lw&((EX_rd==ID_rs1&(!ID_jal))|((EX_rd==ID_rs2)&(ID_rtype|ID_branch))))
begin
      ID_flush=0;
      EX_stall=0;
      selpc=0;
      IF_stall=1;
      ID_stall=1;
      EX_flush=1;
end
else 
begin
     IF_stall=0;
     ID_flush=0;
     ID_stall=0;
     EX_stall=0;
     EX_flush=0;
     selpc=0;
end
//this is to select the A operand of the alu
if(MEM_regwrite&MEM_jump&(MEM_rd==EX_rs1)&(MEM_rd!=0))
sela=2;
else if(MEM_regwrite&(MEM_rd==EX_rs1)&(MEM_rd!=0))
sela=1;
else if(WB_regwrite&(WB_rd==EX_rs1)&(WB_rd!=0))
sela=3;
else
sela=0;
//this is to select the B operand of the alu
if(MEM_regwrite&MEM_jump&(MEM_rd==EX_rs2)&(MEM_rd!=0))
selb=2;
else if(MEM_regwrite&(MEM_rd==EX_rs2)&(MEM_rd!=0))
selb=1;
else if(WB_regwrite&(WB_rd==EX_rs2)&(WB_rd!=0))
selb=3;
else
selb=0;
//this is to select the memory data write 
if(WB_regwrite&(MEM_rs2==WB_rd)&WB_lw)
sel_write_data=1;
else 
sel_write_data=0;
end
endmodule
//lw sw r-type i-type branch jal