module latch_type1(output reg [31:0]out,input [31:0]in,input clk,input reset_n,input stall);//latch having only stall signal for the register pc and i added the reset to start the pipeline 
always@(posedge clk)
begin 
     if(!reset_n)
     out<=0;
     else if(!stall)
     out<=in;
     else 
     out<=out;
end
endmodule
module latch_type2(output reg [31:0]out,input [31:0]in,input [31:0]flushinstr,input clk,input stall,input flush);
always@(posedge clk)
begin
    if(flush)
    out<=flushinstr;
    else if(!stall)
    out<=in;
    else 
    out<=out;
end
endmodule 
module latch_type3(output reg [31:0]out,input [31:0]in,input clk);
always@(posedge clk)
begin 
     out<=in;
end
endmodule
module latch_type3_extended_for1bit(output reg out,input in,input clk);
always@(posedge clk)
begin 
     out<=in;
end
endmodule
module latch_type2_extended_for1bit(output reg out,input in,input flush_value,input clk,input stall,input flush);
always@(posedge clk)
begin
    if(flush)
    out<=flush_value;
    else if(!stall)
    out<=in;
    else 
    out<=out;
end
endmodule 
module latch_type3_extended_for5bit(output reg [4:0]out,input [4:0]in,input clk);
always@(posedge clk)
begin 
     out<=in;
end
endmodule
module latch_type2_extended_for5bit(output reg [4:0]out,input [4:0]in,input [4:0]flush_value,input clk,input stall,input flush);
always@(posedge clk)
begin
    if(flush)
    out<=flush_value;
    else if(!stall)
    out<=in;
    else 
    out<=out;
end
endmodule
module latch_type3_extended_for2bit(output reg [1:0]out,input [1:0]in,input clk);
always@(posedge clk)
begin 
     out<=in;
end
endmodule
module latch_type2_extended_for2bit(output reg [1:0]out,input [1:0]in,input [1:0]flush_value,input clk,input stall,input flush);
always@(posedge clk)
begin
    if(flush)
    out<=flush_value;
    else if(!stall)
    out<=in;
    else 
    out<=out;
end
endmodule
module latch_type2_extended_for3bit(output reg [2:0]out,input [2:0]in,input [2:0]flush_value,input clk,input stall,input flush);
always@(posedge clk)
begin
    if(flush)
    out<=flush_value;
    else if(!stall)
    out<=in;
    else 
    out<=out;
end
endmodule
module mux2to1(output reg [31:0]out,input [31:0]in0,in1,input sel);
always@(*)
begin 
if(sel)
out=in1;
else 
out=in0;
end
endmodule
module mux3to1(output reg[31:0]out,input [31:0]in1,in2,in3,input [1:0]sel);
always@(*)
begin 
    case(sel)
    0:out=in1;
    1:out=in2;
    2:out=in3;
    default:out=32'dx;
    endcase
end
endmodule
module mux4to1(output reg[31:0]out,input [31:0]in0,in1,in2,in3,input [1:0]sel);
always@(*)
begin
case(sel)
0:out=in0;
1:out=in1;
2:out=in2;
3:out=in3;
default:out=32'dx;
endcase
end
endmodule
module adder(output reg[31:0]out,input [31:0]in1,in2);
always@(*)
out=in1+in2;
endmodule
module alu(output reg[31:0]out,output zero,input [31:0]A,B,input [2:0]Alu_control);
always@(*)
begin 
case(Alu_control)
0:out=A+B;
1:out=A-B;
5:out=A<B;
3:out=A|B;
2:out=A&B;
default:out=32'dx;
endcase
end
assign zero=~|out;
endmodule
module signextent(output reg[31:0]out,input [31:0]in,input[1:0] immsrc);
always@(*)
begin 
case(immsrc)
0:out={{20{in[31]}},in[31:20]};
1:out={{20{in[31]}},in[31:25],in[11:7]};
2:out={{20{in[31]}},in[7],in[30:25],in[11:8],1'b0};
3:out={{20{in[31]}},in[19:12],in[20],in[30:21],1'b0};
default:out=32'dx;
endcase
end
endmodule     //       to memory               register          hazard   hazard           btb          btb     btb    instruc memory+btb  btb    btb                                register               register,memory,memeory                          memory,reg,reg      btb             data_mem     control_path   btb  btb   cp                   cp             btb  btb       hazard    hu       hu       hu        hu          cp         cp         hu   
module datapath(output memory_write_enable,register_write_enable,MEM_jump,misprediction,MEM_regwrite,EX_lw,WB_lw,ID_rtype,ID_branch,ID_jal,update_taken,update_en,was_hit,output [31:0]IF_pc,EX_pc,update_target_address,output wire [4:0]A1,A2,A3,MEM_rs2,EX_rs,EX_rt,EX_rd,MEM_rd,WB_rd,output wire [31:0]WD3,WD,A,output [1:0]update_way,input [31:0]Instr,Rd1,Rd2,predicted_address,ReadData,input [1:0]immsrc,sel_a,sel_b,resultsrc,way,input [2:0]Alu_control,input hit,pred_taken,IF_stall,ID_stall,ID_flush,EX_stall,EX_flush,regwrite,write_enable,srcb,selpc,sel_write_data,clk,reset);
parameter lw=7'b0000011,sw=7'b0100011,Rtype=7'b0110011,beq=7'b1100011,ITYPE=7'b0010011,jal=7'b1101111;
wire [31:0]IF_pc,IF_pcplus4,IF_pcf,IF_pcb;
wire IF_stall,IF_taken;
wire [31:0]ID_pc,ID_pcplus4,ID_IR,ID_predicted_address,ID_extended_immediate,ID_target_address;
wire [4:0]ID_detination_address;
wire ID_taken;
wire [1:0]ID_way;
wire [31:0]EX_pc,EX_pcplus4,EX_IR,EX_predicted_address,EX_target_address,EX_extended_immediate,EX_rd1,EX_rd2,EX_A,EX_B,EX_aluresult,EX_immb;
wire [2:0]EX_alucontrol;
wire [1:0]EX_resultsrc,Ex_way;
wire update_en;
wire EX_index,EX_taken,EX_srcb,EX_regwrite,EX_write_enable,EX_jump,EX_branch,EX_lw,zero;
wire [31:0] MEM_pcplus4,MEM_aluresult,MEM_B,MEM_write_data;
wire [1:0]MEM_resultsrc;
wire [31:0]EX_next_address;
wire MEM_regwrite,MEM_write_enable,MEM_jump;
wire [31:0]WB_pcplus4,WB_aluresult,WB_read_data,WB_result;
wire [1:0]WB_resultsrc;
wire WB_regwrite;
wire was_hit;
assign was_hit=EX_hit;
wire [1:0]update_way;
assign update_way=Ex_way;
wire [31:0]update_target_address;
assign update_target_address=EX_target_address;
wire misprediction;
wire update_taken;
assign A1=ID_IR[19:15];
assign A2=ID_IR[24:20];
assign A3=WB_rd;
assign ID_detination_address=ID_IR[11:7];
assign A=MEM_aluresult;
assign WD=MEM_write_data;
assign memory_write_enable=MEM_write_enable;
assign register_write_enable=WB_regwrite;
assign WD3=WB_result;
//IF section
assign IF_taken=hit&pred_taken;
mux2to1 MUX_to_select_pc(IF_pcb,IF_pcplus4,predicted_address,IF_taken);//these two mux are used to select new pc
mux2to1 MUX_to_includeflush(IF_pcf,IF_pcb,EX_next_address,selpc);
latch_type1 pc_register(IF_pc,IF_pcf,clk,reset,IF_stall);//pc register 
adder IF_PCadder(IF_pcplus4,IF_pc,32'd4);//adder to calculate pc+4
//ID section 
wire ID_jal,ID_rtype,ID_branch;
wire [1:0]ID_immsrc;
wire MEM_lw,WB_lw;
wire[2:0] ID_Alu_control;
wire [1:0]ID_resultsrc;
wire ID_srcb,ID_write_enable,ID_regwrite;
assign ID_jal=ID_IR[6:0]==jal;
assign ID_rtype=ID_IR[6:0]==Rtype;
assign ID_branch=ID_IR[6:0]==beq;
latch_type2 instr(ID_IR,Instr,32'h13,clk,ID_stall,ID_flush);
latch_type2 pc_in_id(ID_pc,IF_pc,0,clk,ID_stall,ID_flush);
latch_type2 pcplus4_in_id(ID_pcplus4,IF_pcplus4,0,clk,ID_stall,ID_flush);
latch_type2 predicted_address_in_id(ID_predicted_address,predicted_address,0,clk,ID_stall,ID_flush);
latch_type2_extended_for1bit taken_in_id(ID_taken,pred_taken,1'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for1bit hit_in_id(ID_hit,hit,1'b0,clk,ID_stall,ID_flush);
// latch_type2 index_in_id(ID_index,index,0,clk,ID_stall,ID_flush);
latch_type2_extended_for2bit way_in_id(ID_way,way,2'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for2bit immediate_select(ID_immsrc,immsrc,2'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for3bit alu_control_inid(ID_Alu_control,Alu_control,3'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for1bit regwrite_inid(ID_regwrite,regwrite,1'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for1bit mem_write_in_id(ID_write_enable,write_enable,1'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for1bit src_b_in_id(ID_srcb,srcb,1'b0,clk,ID_stall,ID_flush);
latch_type2_extended_for2bit resultsrc_in_id(ID_resultsrc,resultsrc,2'b0,clk,ID_stall,ID_flush);
signextent sign_extension_id(ID_extended_immediate,ID_IR,ID_immsrc);
adder calculate_branch_target(ID_target_address,ID_pc,ID_extended_immediate);
//ex
assign EX_branch=(EX_IR[6:0]==beq);
assign EX_jump=(EX_IR[6:0]==jal);
assign EX_lw=EX_IR[6:0]==lw;
assign update_taken=EX_jump|(EX_branch&zero);
assign update_en=hit|EX_branch|EX_jump;
assign misprediction=(update_taken^EX_taken)|(EX_taken&(EX_predicted_address!=EX_target_address));
latch_type2 instr_inex(EX_IR,ID_IR,32'h13,clk,EX_stall,EX_flush);
latch_type2 pc_inex(EX_pc,ID_pc,0,clk,EX_stall,EX_flush);
latch_type2 pcplus4_inex(EX_pcplus4,ID_pcplus4,0,clk,EX_stall,EX_flush);
latch_type2 predicted_address_in_ex(EX_predicted_address,ID_predicted_address,0,clk,EX_stall,EX_flush);
latch_type2_extended_for1bit taken_in_ex(EX_taken,ID_taken,1'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for1bit hit_in_ex(EX_hit,ID_hit,1'b0,clk,EX_stall,EX_flush);
// latch_type2 index_in_ex(EX_index,ID_index,0,clk,EX_stall,EX_flush);
latch_type2_extended_for2bit way_in_ex(Ex_way,ID_way,2'b0,clk,EX_stall,EX_flush);
latch_type2 target_address_inex(EX_target_address,ID_target_address,0,clk,EX_stall,EX_flush);
latch_type2 immediate_in_ex(EX_extended_immediate,ID_extended_immediate,0,clk,EX_stall,EX_flush);
latch_type2_extended_for5bit register1_adr_inex(EX_rs,A1,5'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for5bit register2_adr_inex(EX_rt,A2,5'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for5bit destination_adr_inex(EX_rd,ID_detination_address,5'b0,clk,EX_stall,EX_flush);
latch_type2 register1_value_inex(EX_rd1,Rd1,0,clk,EX_stall,EX_flush);//read data r1
latch_type2 register2_value_inex(EX_rd2,Rd2,0,clk,EX_stall,EX_flush);//read data r2
latch_type2_extended_for3bit alu_control_inex(EX_alucontrol,ID_Alu_control,3'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for1bit regwrite_inex(EX_regwrite,ID_regwrite,1'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for1bit write_enable_inex(EX_write_enable,ID_write_enable,1'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for1bit srcb_inex(EX_srcb,ID_srcb,1'b0,clk,EX_stall,EX_flush);
latch_type2_extended_for2bit resultsrc_inex(EX_resultsrc,ID_resultsrc,2'b0,clk,EX_stall,EX_flush);
// latch_type2 is_instruction_branch(EX_branch,branch,0,clk,EX_stall,EX_flush);
// latch_type2 is_instruction_jump(EX_jump,jump,0,clk,EX_stall,EX_flush);
// latch_type2 is_instruction_load(EX_lw,lw,0,clk,EX_stall,Ex_flush);
mux4to1 to_sel_a_inex(EX_A,EX_rd1,MEM_aluresult,MEM_pcplus4,WB_result,sel_a);
mux4to1 to_sel_b_interm_inex(EX_immb,EX_rd2,MEM_aluresult,MEM_pcplus4,WB_result,sel_b);
mux2to1 to_sel_b_inex(EX_B,EX_immb,EX_extended_immediate,EX_srcb);
alu arithematic_unit(EX_aluresult,zero,EX_A,EX_B,EX_alucontrol);
mux2to1 to_sel_next_address(EX_next_address,EX_pcplus4,EX_target_address,update_taken);
//mem
latch_type3_extended_for1bit is_lw_in_mem(MEM_lw,EX_lw,clk);
latch_type3_extended_for1bit is_jump_in_mem(MEM_jump,EX_jump,clk);
latch_type3 write_address_of_mem(MEM_aluresult,EX_aluresult,clk);
latch_type3 pcplus4_in_mem(MEM_pcplus4,EX_pcplus4,clk);
latch_type3 write_data_of_mem(MEM_B,EX_immb,clk);
latch_type3_extended_for5bit rs2_in_mem(MEM_rs2,EX_rt,clk);
latch_type3_extended_for5bit register3_address_inmem(MEM_rd,EX_rd,clk);
latch_type3_extended_for1bit regwrite_in_mem(MEM_regwrite,EX_regwrite,clk);
latch_type3_extended_for1bit write_enable_in_mem(MEM_write_enable,EX_write_enable,clk);
latch_type3_extended_for2bit resultsrc_inmem(MEM_resultsrc,EX_resultsrc,clk);
mux2to1 to_selct_write_data(MEM_write_data,MEM_B,WB_read_data,sel_write_data);
//wb
latch_type3_extended_for1bit is_lw_in_wb(WB_lw,MEM_lw,clk);
latch_type3 read_data_inwb(WB_read_data,ReadData,clk);
latch_type3 pcplus4_in_wb(WB_pcplus4,MEM_pcplus4,clk);
latch_type3 aluresult_in_wb(WB_aluresult,MEM_aluresult,clk);
latch_type3_extended_for1bit regwrite_in_wb(WB_regwrite,MEM_regwrite,clk);
latch_type3_extended_for2bit resultsrc_in_wb(WB_resultsrc,MEM_resultsrc,clk);
latch_type3_extended_for5bit register3_address_inwb(WB_rd,MEM_rd,clk);
mux3to1 result_selector(WB_result,WB_aluresult,WB_read_data,WB_pcplus4,WB_resultsrc);
endmodule