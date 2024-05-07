module encrypt #(
    /********************************Configurable parameters********************************/
    //The width of the plaintext
    parameter DATA_WIDTH    = 10    ,
    parameter N_WIDTH       = 10    ,
    parameter ALPHA_WIDTH   = 5     ,
    parameter HS_WIDTH      = 20    ,
    parameter PRIME_WIDTH   = 5
) (
    //Input
    input wire                      clk         ,
    input wire                      rst_n       ,
    input wire                      vld_in      ,
    input wire [DATA_WIDTH-1:0]     plaintext   ,
    input wire [ALPHA_WIDTH-1:0]    alpha       ,
    input wire [N_WIDTH-1:0]        n           ,
    input wire [HS_WIDTH-1:0]       hs          ,

    //Output
    output logic [N_WIDTH*2-1:0]    ciphertext  ,
    output logic                    done
);

    
endmodule