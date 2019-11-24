
module SPI (
    output wire MOSI, 
    output wire SCK, 
    output wire CS, 

    //  Interface
    input wire RESET, 
    input wire CLK, 
    input wire [7:0] DATA,
    input wire TRG, 
    input wire RDY, 

) ;
reg [7:0] nbits;
reg [7:0] inner_data;

always @(posedge CLK) begin
    if (RESET) begin
        MOSI <= 0;
        CS <= 1;
        RDY <= 0;
        SCK <= 0;
        nbits <= 0;
    end
    else begin
        if (TRG && nbits == 0) begin
            inner_data <= DATA; 
            RDY <= 0;
            SCK <= 0;
            CS <= 1;
            MOSI <= DATA[7];
            nbits <= 8;
        end           
        else if (nbits > 0 && SCK == 1) begin
	        MOSI <= inner_data[nbits-2];
            nbits <= nbits - 1;
            SCK <= 0;
        end
        else if (SCK == 0 && nbits > 0) begin
            SCK <= 1;
        end
        else begin
            MOSI <= 0;
            CS <= 0;
            RDY <= 1;
            SCK <= 0;
        end
    end
end

    
endmodule


