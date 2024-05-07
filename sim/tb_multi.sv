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
        dat1 <= '0;
        dat2 <= '0;

        while(!rst_n)
            @(posedge clk);

        for(int i = 0; i < 10; i = i + 1)begin
            @(posedge clk);
            #(PERIOD/2);
            fork
                foreach(dat1[i])begin
                    dat1[i] <= $urandom_range(1,2**32-1);
                end

                foreach(dat2[i])begin
                    dat2[i] <= $urandom_range(1,2**32-1);
                end
            join
        end

        repeat(5)begin
            @(posedge clk);
        end
        $stop;
    end

/********************************The Reference of Product********************************/

    assign ref_product  = dat1 * dat2   ;
    assign ref_dat1     = dat1          ;
    assign ref_dat2     = dat2          ;

/********************************Instantiate********************************/

    multi2048#(
        .DATA_WIDTH ( 2048 )
    )u_multi2048(
        //Input
        .clk    ( clk       ),
        .rst_n  ( rst_n     ),
        .dat1   ( dat1      ),
        .dat2   ( dat2      ),
        //Output
        .product( product   )
    );
endmodule