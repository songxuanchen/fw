`timescale 1ns/1ns
module tb_multi;

/********************************Parameters********************************/

    parameter   DATA_WIDTH  = 2048  ;
    parameter   PERIOD      = 4     ;

/********************************Input********************************/

    logic                               clk     ;
    logic                               rst_n   ;
    logic [DATA_WIDTH/32-1:0][31:0]     dat1    ;
    logic [DATA_WIDTH/32-1:0][31:0]     dat2    ;
    //logic [DATA_WIDTH-1:0]              dat1    ;
    //logic [DATA_WIDTH-1:0]              dat2    ;
    logic                               vld_in  ;

/********************************Output********************************/

    wire [DATA_WIDTH*2-1:0] product ;

/********************************Internal Variables********************************/

    wire  [DATA_WIDTH*2-1:0]        ref_product         ;   //dat1*dat2
    wire  [DATA_WIDTH-1:0]          ref_dat1            ;
    wire  [DATA_WIDTH-1:0]          ref_dat2            ;

/********************************Initialize clock and reset********************************/

    initial begin
            clk = 1;
            rst_n = 0;
#(PERIOD)   rst_n = 1;
    end

    always #(PERIOD/2)  clk = ~clk;

/********************************Generate random data1 and data2********************************/

    initial begin
        dat1    <= '0   ;
        dat2    <= '0   ;
        vld_in  <= 0    ;

        while(!rst_n)
            @(negedge clk);

        for(int i = 0; i < 100; i = i + 1)begin
            @(negedge clk);

            // dat1 <= $urandom_range(1,2**DATA_WIDTH-1);
            // dat2 <= $urandom_range(1,2**DATA_WIDTH-1);

            foreach(dat1[i])begin
                dat1[i] <= $urandom_range(1,2**32-1);
            end

            foreach(dat2[i])begin
                dat2[i] <= $urandom_range(1,2**32-1);
            end
            vld_in <= 1                              ;

            @(negedge clk);
            vld_in <= 0;

                
            repeat(DATA_WIDTH+1)begin
                @(negedge clk);
            end
        end
        @(negedge clk);
        $stop;
    end

/********************************The Reference of Product********************************/

    assign ref_product  = dat1 * dat2   ;
    assign ref_dat1     = dat1          ;
    assign ref_dat2     = dat2          ;

/********************************Instantiate********************************/

    multi#(
        .DATA_WIDTH ( DATA_WIDTH )
    )u_multi(
        //Input
        .clk    ( clk       ),
        .rst_n  ( rst_n     ),
        .dat1   ( dat1      ),
        .dat2   ( dat2      ),
        .vld_in ( vld_in    ),
        //Output
        .product( product   )
    );

/********************************Record product and reference product********************************/

    integer product_file;
    initial product_file = $fopen("D:/product.txt");
    always @(product)   $fdisplay(product_file,"%h",product);

    integer ref_product_file;
    initial ref_product_file = $fopen("D:/ref_product.txt");
    always @(ref_product)   $fdisplay(ref_product_file,"%h",ref_product);
endmodule