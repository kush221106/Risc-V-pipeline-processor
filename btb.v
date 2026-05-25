module btb(
    output reg[31:0]target_address,//for the f stage
    output reg hit,
    output reg pred_taken,
    output reg[1:0]way_id,
    input update_en,
    input clk,
    input reset_n,
    input was_hit,
    input [1:0]update_way_id,
    input [31:0]lookup_pc,//for the f stage 
    input [31:0]update_pc,
    input [31:0]update_target_address,
    input update_taken
              );//created 4 so that i have to create one read ports per sram
reg [56:0] cache_way0[63:0];//here 57 bits =24 bits of the tag +30 predicted address+2 bit counter+1 valid bit 
reg [56:0] cache_way1[63:0];
reg [56:0] cache_way2[63:0];
reg [56:0] cache_way3[63:0];
reg [2:0]plru [63:0];//so my plru is of three bits where     bit[2]
                     //                          bit[1]                bit[0]
                     //                   cache[0]   cache[1]    cache[2]   cache[3] this is how i defined the flow
// read
wire [5:0]base_addr;
wire [23:0]search_tag;
assign base_addr=lookup_pc[7:2];
assign search_tag=lookup_pc[31:8];
always@(*)
begin 
if(cache_way0[base_addr][56:33]==search_tag&cache_way0[base_addr][0])
begin 
    hit=1;
    pred_taken=cache_way0[base_addr][2];
    target_address={cache_way0[base_addr][32:3],2'd0};
    way_id=0;
end
else if(cache_way1[base_addr][56:33]==search_tag&cache_way1[base_addr][0])
begin 
    hit=1;
    pred_taken=cache_way1[base_addr][2];
    target_address={cache_way1[base_addr][32:3],2'd0};
    way_id=1;
end
else if(cache_way2[base_addr][56:33]==search_tag&cache_way2[base_addr][0])
begin 
    hit=1;
    pred_taken=cache_way2[base_addr][2];
    target_address={cache_way2[base_addr][32:3],2'd0};
    way_id=2;
end
else if(cache_way3[base_addr][56:33]==search_tag&cache_way3[base_addr][0])
begin 
    hit=1;
    pred_taken=cache_way3[base_addr][2];
    target_address={cache_way3[base_addr][32:3],2'd0};
    way_id=3;
end
else 
begin 
    hit=0;
    pred_taken=0;
    target_address=0;
    way_id=0;
end
end
//write 
wire [5:0]update_base_addr;
assign update_base_addr=update_pc[7:2];
reg [1:0]old_counter,new_counter;
always@(*)
begin 
    case(update_way_id)
    0:old_counter=cache_way0[update_base_addr][2:1];
    1:old_counter=cache_way1[update_base_addr][2:1];
    2:old_counter=cache_way2[update_base_addr][2:1];
    3:old_counter=cache_way3[update_base_addr][2:1];
    endcase
    if(!was_hit)
      new_counter=2;
    else 
    begin 
      case (old_counter)
      0:new_counter=(update_taken)?1:0;
      1:new_counter=(update_taken)?2:0;
      2:new_counter=(update_taken)?3:1;
      3:new_counter=(update_taken)?3:2;
      endcase
    end
end
wire [56:0]updated_value;
assign updated_value={update_pc[31:8],update_target_address[31:2],new_counter,1'd1};
wire [1:0]update_path;
reg [1:0]victim_way;
wire [3:0]valid;
wire [2:0]plru_value,plru_value_was;
assign plru_value=plru[update_base_addr];
assign plru_value_was=plru[base_addr];
assign valid={cache_way0[update_base_addr][0],cache_way1[update_base_addr][0],cache_way2[update_base_addr][0],cache_way3[update_base_addr][0]};
always@(*)
begin 
    if(!valid[3])
      victim_way=0;
    else if(!valid[2])
      victim_way=1;
    else if(!valid[1])
      victim_way=2;
    else if(!valid[0])
      victim_way=3;
    else 
      victim_way=(plru_value[2])?((plru_value[1])?0:1):((plru_value[0])?2:3);
end 
assign update_path=(was_hit)?update_way_id:victim_way;
integer i,j;
always@(negedge clk)
begin 
    if(!reset_n)
    begin 
        for(i=0;i<64;i=i+1)
        begin
          cache_way0[i]<=57'd0;
          cache_way1[i]<=57'd0;
          cache_way2[i]<=57'd0;
          cache_way3[i]<=57'd0;
        end
    end
    else if(update_en)
    begin 
        case(update_path)
        0:begin cache_way0[update_base_addr]<=updated_value; end
        1:begin cache_way1[update_base_addr]<=updated_value; end
        2:begin cache_way2[update_base_addr]<=updated_value; end
        3:begin cache_way3[update_base_addr]<=updated_value; end
        endcase
    end
end
always@(negedge clk)
begin 
    if(!reset_n)
    begin 
        for(j=0;j<64;j=j+1)
        begin 
          plru[j]<=3'd0;
        end
    end
    else if(update_en)
    begin 
        if(was_hit)
        begin 
           case(update_way_id)
           0:plru[update_base_addr]<={2'b0,plru_value[0]};
           1:plru[update_base_addr]<={2'b01,plru_value[0]};
           2:plru[update_base_addr]<={1'b1,plru_value[1],1'b0};
           3:plru[update_base_addr]<={1'b1,plru_value[1],1'b1};
           endcase
        end
        else 
        begin 
           case(victim_way)
           0:plru[update_base_addr]<={2'b0,plru_value[0]};
           1:plru[update_base_addr]<={2'b01,plru_value[0]};
           2:plru[update_base_addr]<={1'b1,plru_value[1],1'b0};
           3:plru[update_base_addr]<={1'b1,plru_value[1],1'b1};
           endcase
        end
    end
    else if(hit)
    begin 
        case(way_id)
        0:plru[base_addr]<={2'b0,plru_value_was[0]};
        1:plru[base_addr]<={2'b01,plru_value_was[0]};
        2:plru[base_addr]<={1'b1,plru_value_was[1],1'b0};
        3:plru[base_addr]<={1'b1,plru_value_was[1],1'b1};
        endcase
    end
end
endmodule