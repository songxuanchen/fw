/********************************KaraTsuba********************************/
module multi1024 #(
    //Parameters
    parameter   DATA_WIDTH = 1024
) (
    //Input
    input wire                      clk     ,
    input wire                      rst_n   ,
    input wire [DATA_WIDTH-1:0]     dat1    ,
    input wire [DATA_WIDTH-1:0]     dat2    ,

    //Output
    output logic [DATA_WIDTH*2-1:0] product
);

/********************************Internal Variables********************************/

    logic [DATA_WIDTH/2-1:0]        a                   ;
    logic [DATA_WIDTH/2-1:0]        b                   ;
    logic [DATA_WIDTH/2-1:0]        c                   ;
    logic [DATA_WIDTH/2-1:0]        d                   ;
    wire  [DATA_WIDTH-1:0]          product_tmp1        ;   //ac
    wire  [DATA_WIDTH-1:0]          product_tmp2        ;   //bd
    wire  [DATA_WIDTH-1:0]          product_tmp3        ;   //ad
    wire  [DATA_WIDTH-1:0]          product_tmp4        ;   //bc

/********************************Split two multipliers to get a, b, c, d********************************/

    always_comb begin
        {a,b,c,d} = {dat1,dat2};
    end

/********************************Calculate ac, bd, ad, bc respectively********************************/

    multi512#(
        .DATA_WIDTH ( 512 )
    )u1_multi512(
        .clk    ( clk           ),
        .rst_n  ( rst_n         ),
        .dat1   ( a             ),
        .dat2   ( c             ),
        .product( product_tmp1  )
    );

    multi512#(
        .DATA_WIDTH ( 512 )
    )u2_multi512(
        .clk    ( clk           ),
        .rst_n  ( rst_n         ),
        .dat1   ( a             ),
        .dat2   ( d             ),
        .product( product_tmp2  )
    );

    multi512#(
        .DATA_WIDTH ( 512 )
    )u3_multi512(
        .clk    ( clk           ),
        .rst_n  ( rst_n         ),
        .dat1   ( b             ),
        .dat2   ( c             ),
        .product( product_tmp3  )
    );

    multi512#(
        .DATA_WIDTH ( 512 )
    )u4_multi512(
        .clk    ( clk           ),
        .rst_n  ( rst_n         ),
        .dat1   ( b             ),
        .dat2   ( d             ),
        .product( product_tmp4  )
    );

/********************************Product = {Product_tmp1,4'b0} + Product_tmp2 + {Product_tmp3 + Product_tmp4,2'b0}********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : compute_product
        if(!rst_n)begin
            product <= '0;
        end
        else begin
            product <= {product_tmp1,{DATA_WIDTH{1'b0}}} + product_tmp2 + {product_tmp3 + product_tmp4,{DATA_WIDTH/2{1'b0}}};
        end
    end : compute_product

endmodule