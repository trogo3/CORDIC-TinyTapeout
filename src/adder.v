//
// This file is part of VERILOG_TEMPLATE.
//

/// # Counter Example Specification
///
//
`default_nettype none

module BitAdder(s,co,a,b,ci)
    output s,co;
    input a,b,ci;
    wire m;

    assign m = a ^ b;
    assign s = m ^ ci;
    assign co = (a & b) | (ci & m); 

endmodule

module ParamAdder(in1,in2,out)
    parameter bits = 4;

    input [bits - 1:0] in1;
    input [bits - 1:0] in2;
    output [bits - 1 : 0] out;

    wire [bits - 1:0] carrys;

    BitAdder ba0(
        .s(out[0]), 
        .co(carrys[0]), 
        .a(in1[0]), 
        .b(in2[0]), 
        .ci(1'b0)
        );

    genvar i;
    generate
        for (i = 1; i < bits; i = i + 1) begin: Genloop
            BitAdder bai(
                .s(out[i]), 
                .co(carrys[i]), 
                .a(in1[i]), 
                .b(in2[i]), 
                .ci(carrys[i-1])
                );
        end
    endgenerate

endmodule