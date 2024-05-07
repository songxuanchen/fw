/********************************KaraTsuba********************************/
module multi #(
    //Parameters
    parameter   DATA_WIDTH = 8
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
    logic [DATA_WIDTH-1:0]          product_tmp1        ;   //ac
    logic [DATA_WIDTH-1:0]          product_tmp2        ;   //bd
    logic [DATA_WIDTH-1:0]          product_tmp3        ;   //ad
    logic [DATA_WIDTH-1:0]          product_tmp4        ;   //bc

/********************************Split two multipliers to get a, b, c, d********************************/

    always_ff @( posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            {a,b,c,d} <= '0;
        end
        else begin
            {a,b,c,d} <= {dat1,dat2};
        end
    end

/********************************Calculate ac, bd, ad, bc respectively********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : compute_product_tmp
        if(!rst_n)begin
            product_tmp1 <= '0;
            product_tmp2 <= '0;
            product_tmp3 <= '0;
            product_tmp4 <= '0;
        end
        else begin
            product_tmp1 <= a*c;
            product_tmp2 <= b*d;
            product_tmp3 <= a*d;
            product_tmp4 <= b*c;
        end
    end : compute_product_tmp

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