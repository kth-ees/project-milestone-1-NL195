module alu #(
  BW = 16 // bitwidth
  ) (
  input  logic signed   [BW-1:0]  in_a,
  input  logic signed   [BW-1:0]  in_b,
  input  logic          [2:0]     opcode,
  output logic signed   [BW-1:0]  out,
  output logic          [2:0]     flags // {overflow, negative, zero}
  );

  logic f_overflow;

  always_comb begin : opcode_logic

    //Default assignment
    f_overflow = 1'b0;

    case(opcode)
      3'b000: begin                 //ADD
        out = in_a + in_b;
        if((in_a[BW-1] == in_b[BW-1]) && (out[BW-1] !== in_a[BW-1]))
          f_overflow = 1'b1;
      end
      3'b001: begin
        out = in_a - in_b;          //SUB
        if((in_a[BW-1] !== in_b[BW-1]) && (out[BW-1] == in_b[BW-1]))
          f_overflow = 1'b1;
      end
      3'b010: out = in_a & in_b;    //AND
      3'b011: out = in_a | in_b;    //OR
      3'b100: out = in_a ^  in_b;   //XOR
      3'b101: out = in_a + 1;       //INC
      3'b110: out = in_a;           //MOVA
      3'b111: out = in_b;           //MOVB
      default: out = '0;
    endcase

    flags[2] = f_overflow;
    flags[1] = out[BW-1];    // Negative
    flags[0] = (out == '0);  // Zero

  end

endmodule




