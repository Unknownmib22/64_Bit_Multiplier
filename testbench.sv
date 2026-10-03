// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_multiplier_64bit;

    // Testbench Inputs
    reg clk;
    reg reset;
    reg start;
    reg [63:0] multiplicand;
    reg [63:0] multiplier;

    // Testbench Outputs
    wire [127:0] product;
    wire ready;

    // Instantiate the Unit Under Test (UUT)
    multiplier_64bit uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .ready(ready)
    );

    // Clock Generation (100 MHz clock -> 10ns period)
    always #5 clk = ~clk;

    // Stimulus Block
    initial begin
        // Required for EDA Playground to display waveform plots
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_multiplier_64bit);

        // Initialize Inputs
        clk = 0;
        reset = 1;
        start = 0;
        multiplicand = 0;
        multiplier = 0;

        // Hold reset for 20ns
        #20;
        reset = 0;
        #20;

        // --- Test Case 1: Simple Multiplication (15 x 10) ---
        $display("[TB] Starting Test Case 1: 15 x 10");
        multiplicand = 64'd15;
        multiplier   = 64'd10;
        start = 1;
        #10; // Wait 1 clock cycle
        start = 0;
        
        @(posedge ready);
        #1;
        if (product == 128'd150)
            $display("[SUCCESS] Test Case 1 Passed! 15 x 10 = %0d", product);
        else
            $display("[ERROR] Test Case 1 Failed! Expected 150, Got %0d", product);

        #40;

        // --- Test Case 2: Multiplying by Zero (245,392 x 0) ---
        $display("[TB] Starting Test Case 2: 245392 x 0");
        multiplicand = 64'd245392;
        multiplier   = 64'd0;
        start = 1;
        #10;
        start = 0;
        
        @(posedge ready);
        #1;
        if (product == 128'd0)
            $display("[SUCCESS] Test Case 2 Passed! 245392 x 0 = %0d", product);
        else
            $display("[ERROR] Test Case 2 Failed! Expected 0, Got %0d", product);

        #40;

        // --- Test Case 3: Large Number Boundaries (2^32 x 5) ---
        $display("[TB] Starting Test Case 3: 4294967296 x 5");
        multiplicand = 64'h100000000; // 2^32
        multiplier   = 64'd5;
        start = 1;
        #10;
        start = 0;
        
        @(posedge ready);
        #1;
        if (product == 128'h500000000)
            $display("[SUCCESS] Test Case 3 Passed! Expected %0h, Got %0h", 128'h500000000, product);
        else
            $display("[ERROR] Test Case 3 Failed! Got %0h", product);

        #40;

        // --- Test Case 4: Absolute Max 64-bit Values (Max x Max) ---
        $display("[TB] Starting Test Case 4: Max 64-bit integers");
        multiplicand = 64'hFFFFFFFFFFFFFFFF; 
        multiplier   = 64'hFFFFFFFFFFFFFFFF;
        start = 1;
        #10;
        start = 0;
        
        @(posedge ready);
        #1;
        if (product == 128'hFFFFFFFFFFFFFFFF0000000000000001)
            $display("[SUCCESS] Test Case 4 Passed! Max Value Math is flawless.");
        else
            $display("[ERROR] Test Case 4 Failed! Got Hex: %0h", product);

        #100;
        $display("[TB] Simulation Completed successfully.");
        $finish;
    end

endmodule
