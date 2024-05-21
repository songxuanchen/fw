/********************************shift_multi********************************/
module multi #(
    //Parameters
    parameter   DATA_WIDTH = 2048
) (
    //Input
    input wire                      clk     ,
    input wire                      rst_n   ,
    input wire [DATA_WIDTH-1:0]     dat1    ,
    input wire [DATA_WIDTH-1:0]     dat2    ,
    input wire                      vld_in  ,

    //Output
    output logic [DATA_WIDTH*2-1:0] product
);

/********************************Type Define********************************/

    typedef enum logic {
        IDLE = 0,
        BUSY = 1
    } state_t;

/********************************Internal Variables********************************/

    logic [DATA_WIDTH-1:0]          dat1_tmp    ;
    logic [DATA_WIDTH-1:0]          dat2_tmp    ;
    logic [DATA_WIDTH*2-1:0]        product_tmp ;
    state_t                         curr_state  ;
    state_t                         next_state  ;
    logic [$clog2(DATA_WIDTH)-1:0]  cnt         ;
    logic                           flag        ;

/********************************FSM********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : set_curr_state
        if(!rst_n)begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;
        end
    end : set_curr_state

    always_comb begin : set_next_state
        unique case(curr_state)
            IDLE:begin
                if(vld_in)      next_state = BUSY;
                else            next_state = IDLE;
            end

            BUSY:begin
                if(cnt == '1)   next_state = IDLE;
                else            next_state = BUSY;
            end
        endcase
    end : set_next_state

/********************************Register dat1 and dat2********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : register_data
        if(!rst_n)begin
            dat1_tmp <= '0;
            dat2_tmp <= '0;
        end
        else if(curr_state == IDLE && next_state == BUSY)begin
            dat1_tmp <= dat1;
            dat2_tmp <= dat2;
        end
        else begin
            dat1_tmp <= dat1_tmp;
            dat2_tmp <= dat2_tmp;
        end
    end

/********************************Shift and Multiply********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : shift_multi
        if(!rst_n)begin
            product_tmp <= '0;
            cnt         <= '0;
        end
        else if(curr_state == IDLE && next_state == BUSY)begin
            product_tmp <= (dat2[cnt])?({{DATA_WIDTH{1'b0}},dat1} << cnt):0  ;
            cnt         <= cnt + 1                                           ;
        end
        else if(curr_state == BUSY)begin
            product_tmp <= (dat2_tmp[cnt])?(product_tmp + ({{DATA_WIDTH{1'b0}},dat1_tmp} << cnt)):(product_tmp) ;
            cnt         <= cnt + 1                                                                              ;
        end
        else begin
            product_tmp <= '0;
            cnt         <= '0;
        end
    end : shift_multi

/********************************Count overflow flag********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : cnt_overflow_flag
        if(!rst_n)          flag <= 0;
        else if(cnt == '1)  flag <= 1;
        else                flag <= 0;
    end : cnt_overflow_flag

/********************************Output the product********************************/

    always_ff @( posedge clk or negedge rst_n ) begin : output_result
        if(!rst_n)          product <= '0;
        else if(flag)       product <= product_tmp;
        else                product <= product;
    end

endmodule