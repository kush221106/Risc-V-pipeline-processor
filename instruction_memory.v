module instruction_memory(output [31:0] instr, input [31:0] Pc);
    reg [31:0] memory [0:63]; // 64 words (256 bytes)
    
    initial begin
        $readmemh("C:/test_the_pipeline.txt", memory); // Loads your Hex file!
    end
    assign instr = memory[Pc[7:2]]; 
endmodule