// Code your design here
module multiplier_64bit (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [63:0] multiplicand,
    input wire [63:0] multiplier,
    output reg [127:0] product,
    output reg ready
);

    // State Encoding
    localparam IDLE  = 1'b0;
    localparam COUNT = 1'b1;

    reg state;
    reg [6:0] counter;        // 7-bit counter to count up to 64
    reg [63:0] M;            // Multiplicand register
    reg [127:0] prod_reg;    // Combined Accumulator [127:64] and Multiplier [63:0]

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state    <= IDLE;
            counter  <= 0;
            M        <= 0;
            prod_reg <= 0;
            product  <= 0;
            ready    <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1'b1;
                    if (start) begin
                        M        <= multiplicand;
                        prod_reg <= {64'b0, multiplier}; // Init upper bits to 0, lower to multiplier
                        counter  <= 0;
                        ready    <= 1'b0;
                        state    <= COUNT;
                    end
                end

                COUNT: begin
                    if (counter == 64) begin
                        product <= prod_reg;
                        ready   <= 1'b1;
                        state   <= IDLE;
                    end else begin
                        counter <= counter + 1;
                        // Shift and add step logic
                        if (prod_reg[0] == 1'b1) begin
                            // Perform conditional addition and right shift simultaneously 
                            prod_reg <= { (prod_reg[127:64] + M), prod_reg[63:1] };
                        end else begin
                            // Simply shift right if LSB is 0
                            prod_reg <= { 1'b0, prod_reg[127:1] };
                        end
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule
