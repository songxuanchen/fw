`timescale 1ns/1ns
`include "../pkg/definitions.sv"
import definitions::*;
module tb_precompute;

/********************************Parameters********************************/

    parameter   DATA_WIDTH  = 1024  ;
    parameter   PERIOD      = 4     ;

/********************************Input********************************/

    logic                               clk                                 ;
    logic                               rst_n                               ;
    logic [1024-1:0]                    p                                   ;
    logic [1024-1:0]                    q                                   ;
    logic [1024-1:0]                    x                                   ;

/********************************Output********************************/

    wire  [2048-1:0]                    n                                  ;
    wire  [4096-1:0]                    hs                                 ;
    wire  [2048-1:0]                    lambda                             ;
    wire  [4096-1:0]                    n_square                           ;
    wire  [2048-1:0]                    p_square                           ;
    wire  [2048-1:0]                    q_square                           ;
    wire  [4096:0]                      n_square_rho                       ;
    wire  [2048:0]                      p_square_rho                       ;
    wire  [2048:0]                      q_square_rho                       ;
    wire  [4096-1:0]                    n_square_rho_sub1                  ;
    wire  [2048-1:0]                    p_square_rho_sub1                  ;
    wire  [2048-1:0]                    q_square_rho_sub1                  ;
    wire  [4096-1:0]                    n_square_inverse_mod_n_square_rho  ;
    wire  [2048-1:0]                    p_square_inverse_mod_p_square_rho  ;
    wire  [2048-1:0]                    q_square_inverse_mod_q_square_rho  ;
    wire  [4096-1:0]                    n_square_r1                        ;
    wire  [8192-1:0]                    n_square_r1_multi_n_square_rho     ;
    wire  [4096-1:0]                    n_square_r2                        ;
    wire  [2048-1:0]                    p_square_r1                        ;
    wire  [4096-1:0]                    p_square_r1_multi_p_square_rho     ;
    wire  [2048-1:0]                    p_square_r2                        ;
    wire  [2048-1:0]                    q_square_r1                        ;
    wire  [4096-1:0]                    q_square_r1_multi_q_square_rho     ;
    wire  [2048-1:0]                    q_square_r2                        ;
    wire  [1024-1:0]                    x_mod_p2                           ;
    wire  [1024-1:0]                    x_mod_q2                           ;
    wire  [2048-1:0]                    fai_p2                             ;
    wire  [2048-1:0]                    fai_q2                             ;
    wire  [2048-1:0]                    double_n_mod_fai_p2                ;
    wire  [2048-1:0]                    double_n_mod_fai_q2                ;
    wire  [2048-1:0]                    y_p2                               ;
    wire  [2048-1:0]                    y_q2                               ;
    wire  [2048-1:0]                    p2_inverse_mod_q2                  ;
    wire  [2048-1:0]                    y_q2_sub_y_p2_multi_p2_inverse_mod_q2;
    wire  [4096-1:0]                    y                                  ;

/********************************Internal Variables********************************/

    logic [1023:0]  mem [2:0]       ;
    // logic [128:0][31:0]  ex_r0       ;
    // logic [128:0][31:0]  ex_r1       ;
    // logic [4096:0]      r0          ;
    // logic [4096:0]      r1          ;
    // logic [4096:0]      quo         ;
    logic [1:0]        quo         ;

/********************************Initialize clock and reset********************************/

    initial begin
            clk = 1;
            rst_n = 0;
#(PERIOD)   rst_n = 1;
#(PERIOD*5) $stop;
    end

    always #(PERIOD/2)  clk = ~clk;

/********************************Initialize p,q and x********************************/

    initial begin
        $readmemh("../temp/input_dat_py",mem);
        p = mem[0];
        q = mem[1];
        x = {mem[3],mem[2]};
        quo = 3-4;
    end

/********************************Verify r0/r1********************************/

    // integer r0_div_r1_result_file;

    // initial begin

    //     r0_div_r1_result_file = $fopen("../temp/r0_div_r1_result");

    //     foreach(ex_r0[i])begin
    //         ex_r0[i] = $urandom_range(1,2**32-1);
    //     end

    //     foreach(ex_r1[i])begin
    //         ex_r1[i] = $urandom_range(1,2**32-1);
    //     end

    //     r0 = ex_r0[4096:0];
    //     r1 = ex_r1[4096:0];
    //     r1 = r1 >> 16;

    //     $fdisplay(r0_div_r1_result_file,"%d",r0);
    //     $fdisplay(r0_div_r1_result_file,"%d",r1);

    //     quo = cacl_4096bit_r0_divide_r1(r0,r1);

    //     $fdisplay(r0_div_r1_result_file,"%d",quo);
    // end

/********************************Instantiate********************************/

precompute#(
    .DATA_WIDTH                         ( 1024 )
)u_precompute(
    .clk                                ( clk                                ),
    .rst_n                              ( rst_n                              ),
    .p                                  ( p                                  ),
    .q                                  ( q                                  ),
    .x                                  ( x                                  ),
    .n                                  ( n                                  ),
    .hs                                 ( hs                                 ),
    .lambda                             ( lambda                             ),
    .n_square                           ( n_square                           ),
    .p_square                           ( p_square                           ),
    .q_square                           ( q_square                           ),
    .n_square_rho                       ( n_square_rho                       ),
    .p_square_rho                       ( p_square_rho                       ),
    .q_square_rho                       ( q_square_rho                       ),
    .n_square_rho_sub1                  ( n_square_rho_sub1                  ),
    .p_square_rho_sub1                  ( p_square_rho_sub1                  ),
    .q_square_rho_sub1                  ( q_square_rho_sub1                  ),
    .n_square_inverse_mod_n_square_rho  ( n_square_inverse_mod_n_square_rho  ),
    .p_square_inverse_mod_p_square_rho  ( p_square_inverse_mod_p_square_rho  ),
    .q_square_inverse_mod_q_square_rho  ( q_square_inverse_mod_q_square_rho  ),
    .n_square_r1                        ( n_square_r1                        ),
    .n_square_r1_multi_n_square_rho     ( n_square_r1_multi_n_square_rho     ),
    .n_square_r2                        ( n_square_r2                        ),
    .p_square_r1                        ( p_square_r1                        ),
    .p_square_r1_multi_p_square_rho     ( p_square_r1_multi_p_square_rho     ),
    .p_square_r2                        ( p_square_r2                        ),
    .q_square_r1                        ( q_square_r1                        ),
    .q_square_r1_multi_q_square_rho     ( q_square_r1_multi_q_square_rho     ),
    .q_square_r2                        ( q_square_r2                        ),
    .x_mod_p2                           ( x_mod_p2                           ),
    .x_mod_q2                           ( x_mod_q2                           ),
    .fai_p2                             ( fai_p2                             ),
    .fai_q2                             ( fai_q2                             ),
    .double_n_mod_fai_p2                ( double_n_mod_fai_p2                ),
    .double_n_mod_fai_q2                ( double_n_mod_fai_q2                ),
    .y_p2                               ( y_p2                               ),
    .y_q2                               ( y_q2                               ),
    .p2_inverse_mod_q2                  ( p2_inverse_mod_q2                  ),
    .y_q2_sub_y_p2_multi_p2_inverse_mod_q2 (y_q2_sub_y_p2_multi_p2_inverse_mod_q2),
    .y                                  ( y                                  )
);


/********************************Record Input********************************/

    integer input_file;
    initial input_file = $fopen("../temp/input_dat_hdl");
    initial begin
        while(!rst_n)
            @(posedge clk);
        $fdisplay(input_file,"p = %d",p);
        $fdisplay(input_file,"q = %d",q);
        $fdisplay(input_file,"x = %d",x);
    end


/********************************Record Output********************************/

    integer output_file;
    initial output_file = $fopen("../temp/output_dat_hdl");
    initial begin
        while(!rst_n)
            @(posedge clk);
        $fdisplay(output_file,"n                                 = %h",n                                );
        $fdisplay(output_file,"hs                                = %h",hs                               );
        $fdisplay(output_file,"lambda                            = %h",lambda                           );
        $fdisplay(output_file,"n_square                          = %h",n_square                         );
        $fdisplay(output_file,"p_square                          = %h",p_square                         );
        $fdisplay(output_file,"q_square                          = %h",q_square                         );
        $fdisplay(output_file,"n_square_rho                      = %h",n_square_rho                     );
        $fdisplay(output_file,"p_square_rho                      = %h",p_square_rho                     );
        $fdisplay(output_file,"q_square_rho                      = %h",q_square_rho                     );
        $fdisplay(output_file,"n_square_rho_sub1                 = %h",n_square_rho_sub1                );
        $fdisplay(output_file,"p_square_rho_sub1                 = %h",p_square_rho_sub1                );
        $fdisplay(output_file,"q_square_rho_sub1                 = %h",q_square_rho_sub1                );
        $fdisplay(output_file,"n_square_inverse_mod_n_square_rho = %h",n_square_inverse_mod_n_square_rho);
        $fdisplay(output_file,"p_square_inverse_mod_p_square_rho = %h",p_square_inverse_mod_p_square_rho);
        $fdisplay(output_file,"q_square_inverse_mod_q_square_rho = %h",q_square_inverse_mod_q_square_rho);
        $fdisplay(output_file,"n_square_r1                       = %h",n_square_r1                      );
        $fdisplay(output_file,"n_square_r1_multi_n_square_rho    = %h",n_square_r1_multi_n_square_rho   );
        $fdisplay(output_file,"n_square_r2                       = %h",n_square_r2                      );
        $fdisplay(output_file,"p_square_r1                       = %h",p_square_r1                      );
        $fdisplay(output_file,"p_square_r1_multi_p_square_rho    = %h",p_square_r1_multi_p_square_rho   );
        $fdisplay(output_file,"p_square_r2                       = %h",p_square_r2                      );
        $fdisplay(output_file,"q_square_r1                       = %h",q_square_r1                      );
        $fdisplay(output_file,"q_square_r1_multi_q_square_rho    = %h",q_square_r1_multi_q_square_rho   );
        $fdisplay(output_file,"q_square_r2                       = %h",q_square_r2                      );
        $fdisplay(output_file,"x_mod_p2                          = %h",x_mod_p2                         );
        $fdisplay(output_file,"x_mod_q2                          = %h",x_mod_q2                         );
        $fdisplay(output_file,"fai_p2                            = %h",fai_p2                           );
        $fdisplay(output_file,"fai_q2                            = %h",fai_q2                           );
        $fdisplay(output_file,"double_n_mod_fai_p2               = %h",double_n_mod_fai_p2              );
        $fdisplay(output_file,"double_n_mod_fai_q2               = %h",double_n_mod_fai_q2              );
        $fdisplay(output_file,"y_p2                              = %h",y_p2                             );
        $fdisplay(output_file,"y_q2                              = %h",y_q2                             );
        $fdisplay(output_file,"p2_inverse_mod_q2                 = %h",p2_inverse_mod_q2                );
        $fdisplay(output_file,"y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = %h",y_q2_sub_y_p2_multi_p2_inverse_mod_q2);
        $fdisplay(output_file,"y                                 = %h",y                                );
        $fdisplay(output_file,"p2_inverse_mod_q2                 = %d",p2_inverse_mod_q2                );
        $fdisplay(output_file,"n2 - y                            = %h",n_square - y                     );
    end
endmodule