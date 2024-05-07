/********************************Montgomery ModMulti********************************/
module modmulti#(
    parameter DATA1_WIDTH   =   2048    ,
    parameter DATA2_WIDTH   =   2048    ,
    parameter MOD_WIDTH     =   2048
)(
    //Input
    input wire                      clk     ,
    input wire                      rst_n   ,
    input wire [DATA1_WIDTH-1:0]    dat1    ,
    input wire [DATA2_WIDTH-1:0]    dat2    ,
    input wire [MOD_WIDTH-1:0]      mod     ,

    //Output
    output logic [MOD_WIDTH-1:0]   result
);

    
endmodule