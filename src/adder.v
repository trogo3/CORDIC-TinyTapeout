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

module ParamAdder(out, in1, in2, c0)
    parameter bits = 4;

    input [bits - 1:0] in1;
    input [bits - 1:0] in2;
    input c0;
    output [bits - 1 : 0] out;

    wire [bits - 1:0] carrys;

    BitAdder ba0( 
        .s(out[0]), 
        .co(carrys[0]), 
        .a(in1[0]), 
        .b(in2[0]), 
        .ci(c0)
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

module AddSub(out, in1, in2, sub);

    parameter bits = 4;

    output [bits-1:0] out;
    input [bits-1:0] in1;
    input [bits-1:0] in2;
    input sub;

    wire [bits-1:0] in2Prime;
    wire c0;

    assign in2Prime = sub ? ~in2 : in2;
    assign c0 = sub;

    ParamAdder #(.bits(bits)) AddSub_Instance (
        .out(out),
        .in1(in1),
        .in2(in2Prime),
        .c0(c0)
    );

endmodule

module MultK(out, in) //Returns bitshifted by number of bits i.e decimal is at beginning
    parameter bits = 4; //Number of bits for operation
    parameter K = 4'b1011; //Value of K (from wikipedia) with 4 bits
    parameter ZeroBit = 4'd0; //set to 0 with 'bits' number of bits

    input [bits-1:0] in;
    output [2* bits-1:0] out;

    wire [bits-1:0] toSum[2 * bits-1 :0]; //bits are unshifted. should be shifted left by the index.
    
    wire [bits-1:0] SumOuts[2 * bits-1 :0];

    assign SumOuts[0] = {2*bits{1'b0}};

    

    genvar i;
    generate
        for (i = 0; i < bits; i = i + 1) begin : toSumLoop
            generate //we can generate based on K, making it optimized to the K specific multiplication
                if (K[i] == 0)
                    assign toSum[i] = {2*bits{1'b0}};
                else
                    assign toSum[i] = {bits{1'b0}, in} << i;
            endgenerate
        end
    endgenerate

    //Sum toSum
    genvar j;
    generate
        for (j = 1; j <= bits; j = j + 1) begin : sumLoop
            //todo
            AddSub #(.bits(bits)) jthAddSubber (
                .out(SumOuts[j]),
                .in1(toSum[j]),
                .in2(SumOuts[j-1]),
                .sub(1'b0)
            );


        end
    endgenerate

    assign out = SumOuts[bits]


endmodule