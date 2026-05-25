`include "control_path.v"
`include "data_memory.v"
`include "register_bank.v"
`include "btb.v"
`include "hazard_unit.v"
`include "data_path.v"
`include "instruction_memory.v"
module top(input clk,reset_n);
wire memory_write_enable,register_write_enable,MEM_jump,misprediction,update_taken,update_en,was_hit,MEM_regwrite,EX_lw,WB_lw,ID_rtype,ID_branch,ID_jal;
wire [31:0]pc,update_pc,update_target_address,WD3,WD,A,Instr,Rd1,Rd2,predicted_address,ReadData;
wire [4:0]A1,A2,A3,MEM_rs2,EX_rs,EX_rt,EX_rd,MEM_rd,WB_rd;
wire [1:0]update_way,immsrc,sel_a,sel_b,resultsrc,way;
wire [2:0]Alu_control;
wire hit,pred_taken,IF_stall,ID_stall,ID_flush,EX_stall,EX_flush,regwrite,write_enable,srcb,selpc,sel_write_data;
datapath data(memory_write_enable,register_write_enable,MEM_jump,misprediction,MEM_regwrite,EX_lw,WB_lw,ID_rtype,ID_branch,ID_jal,update_taken,update_en,was_hit,pc,update_pc,update_target_address,A1,A2,A3,MEM_rs2,EX_rs,EX_rt,EX_rd,MEM_rd,WB_rd,WD3,WD,A,update_way,Instr,Rd1,Rd2,predicted_address,ReadData,immsrc,sel_a,sel_b,resultsrc,way,Alu_control,hit,pred_taken,IF_stall,ID_stall,ID_flush,EX_stall,EX_flush,regwrite,write_enable,srcb,selpc,sel_write_data,clk,reset_n);
controlpath control_unit(regwrite,write_enable,srcb,immsrc,resultsrc,Alu_control,Instr);
hazardunit hazard_unit(IF_stall,ID_stall,ID_flush,EX_stall,EX_flush,sel_write_data,selpc,sel_a,sel_b,A1,A2,EX_rs,EX_rt,EX_rd,MEM_rd,MEM_rs2,WB_rd,MEM_regwrite,register_write_enable,ID_jal,ID_rtype,ID_branch,MEM_jump,WB_lw,EX_lw,misprediction,reset_n);
btb preiction_unit(predicted_address,hit,pred_taken,way,update_en,clk,reset_n,was_hit,update_way,pc,update_pc,update_target_address,update_taken);
data_memory data_memory_unit(ReadData,A,WD,memory_write_enable,clk);
instruction_memory i_memory(Instr,pc);
register_file r_bank(Rd1,Rd2,A1,A2,A3,WD3,register_write_enable,clk);
endmodule