`timescale 1ns/1ns

module alu_tb;

  // Use a localparam for testbench-specific constants
  parameter BW = 16;

  // Signals to connect to the DUT (Design Under Test)
  logic signed [BW-1:0]   in_a;
  logic signed [BW-1:0]   in_b;
  logic        [2:0]      opcode;
  logic signed [BW-1:0]   out;
  logic        [2:0]      flags; // {overflow, negative, zero}

  // Instantiate the ALU module
  alu #(
    .BW(BW)
  ) dut (
    .in_a(in_a),
    .in_b(in_b),
    .opcode(opcode),
    .out(out),
    .flags(flags)
  );

  // Main stimulus block
  initial begin

    $dumpfile("waveform.vcd");
    $dumpvars(0, dut); 

    $display("Starting ALU Testbench...");
    $display("Time\t Op\t in_a\t\t in_b\t\t out\t\t Flags (OV, N, Z)");
    $monitor("%0t\t %b\t %d\t\t %d\t\t %d\t\t %b", 
             $time, opcode, in_a, in_b, out, flags);

    // Test case 1: ADD (000)
    opcode = 3'b000;
    in_a = 100; in_b = 50; #10;   
    in_a = 20;  in_b = -5;  #10;   
    in_a = -10; in_b = -20; #10;   
    
    // Test ADD overflow
    in_a = (2**(BW-1))-1; in_b = 1; #10; 

    // Test case 2: SUB (001)
    opcode = 3'b001;
    in_a = 100; in_b = 50; #10;
    in_a = 5;   in_b = 10; #10;  

    // Test SUB overflow
    in_a = -(2**(BW-1)); in_b = 1; #10;
    
    // Test for Zero flag
    in_a = 10; in_b = 10; #10;

    // Test case 3: AND (010)
    opcode = 3'b010;
    in_a = 16'hAAAA; in_b = 16'hF0F0; #10;

    // Test case 4: OR (011)
    opcode = 3'b011;
    in_a = 16'hAAAA; in_b = 16'hF0F0; #10;

    // Test case 5: XOR (100)
    opcode = 3'b100;
    in_a = 16'hAAAA; in_b = 16'hF0F0; #10;

    // Test case 6: INC (101)
    opcode = 3'b101;
    in_a = 99; in_b = 'x; #10; 
    in_a = -1; in_b = 'x; #10; 

    // Test case 7: MOVA (110)
    opcode = 3'b110;
    in_a = 12345; in_b = 'x; #10;

    // Test case 8: MOVB (111)
    opcode = 3'b111;
    in_a = 'x; in_b = 54321; #10;

    $display("Testbench finished.");
    $finish;
  end

endmodule