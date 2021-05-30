// Verilog module for Asynchronous Decade counter
// Mixed mode


module FlipFlop(input clk, input reset, output reg q);
    initial begin
        q=0;
    end
	always @(posedge clk or negedge reset)
	begin
		if (reset)
			q <= 0;
		else
			q <= !q;
	end
endmodule

module AsyncDecadeCounter(input clk, output reset, output [3:0] q);
    reg res;
    FlipFlop D(clk, res, q[0]);
    FlipFlop C(q[0], res, q[1]);
    FlipFlop B(q[1], res, q[2]);
    FlipFlop A(q[2], res, q[3]);
    always @ ( posedge clk ) begin
        res <= (!q[0] &&  q[2] && q[1] && !q[3]);
    end
    assign reset = res;
endmodule

module async10();
    // Numbers in binary will be in the form ABCD where A is the MSB and D is the LSB
    // JKFlipFlop ff1(clk, reset, j, k, q, q_not);
    reg clk=1'b1;
    wire [3:0] out;
    // wire q_B;
    // wire q_C;
    // wire q_D;
    wire reset;
    AsyncDecadeCounter c1(clk, reset, out);
// Test Bench code
    integer i, w;
    // always #1 clk = ~clk;

    initial begin
        // reset <= 0;
        $dumpfile("AsyncDecadeCounter.vcd");
        $dumpvars(0, async10);
        $display(" Asynchronous Decade counter ");
        $display(" ----------------------------");
        $display(" | Clock | reset | ABCD | Value |");
        $display(" ----------------------------");
        $monitor(" |   ", clk, "   |   ", reset, "   | ", out[3], out[2], out[1], out[0], " |  ", out,"  | ");
            // reset<=1;
            // #1
            // reset <=0;
            for (i=0; i<20; i=i+1) begin
                // and and0(reset, q_A, q_D);
                // clk <= i%2;
                clk <= ~clk;
                // w = {out};
                #1;
            end
        $display(" ----------------------------");
        $finish;
        end
endmodule
