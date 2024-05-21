//****************************************************************
//*     Precompute module calculates the parameters based on the input p, q, and
//* random number x.These parameters includes:
//*     1、Public Key(n,hs)
//*     2、Private Key(lambda)
//*     3、Parameters for encryption and decryption(n_square、p_square and q_square)
//*     4、Parameters for accelerated operations(rho、n_square_inverse、p_square_inverse、q_square_inverse、r1 and r2)
//*     After all the parameters have been calculated, they are sent to DDR3 for storage.
//****************************************************************

`include "../pkg/definitions.sv"
import definitions::*;

module precompute#(
    //Configurable Parameters
    parameter   DATA_WIDTH = 1024
)(
    //Input
    input wire                      clk                                     ,
    input wire                      rst_n                                   ,
    input wire [1024-1:0]           p                                       ,
    input wire [1024-1:0]           q                                       ,
    input wire [1024-1:0]           x                                       ,

    //Output
    output logic [2048-1:0]         n                                       ,
    output logic [4096-1:0]         hs                                      ,
    output logic [2048-1:0]         lambda                                  ,
    output logic [4096-1:0]         n_square                                ,
    output logic [2048-1:0]         p_square                                ,
    output logic [2048-1:0]         q_square                                ,
    output logic [4096:0]           n_square_rho                            ,
    output logic [2048:0]           p_square_rho                            ,
    output logic [2048:0]           q_square_rho                            ,
    output logic [4096-1:0]         n_square_rho_sub1                       ,
    output logic [2048-1:0]         p_square_rho_sub1                       ,
    output logic [2048-1:0]         q_square_rho_sub1                       ,
    output logic [4096-1:0]         n_square_inverse_mod_n_square_rho       ,
    output logic [2048-1:0]         p_square_inverse_mod_p_square_rho       ,
    output logic [2048-1:0]         q_square_inverse_mod_q_square_rho       ,
    output logic [4096-1:0]         n_square_r1                             ,
    output logic [8192-1:0]         n_square_r1_multi_n_square_rho          ,
    output logic [4096-1:0]         n_square_r2                             ,
    output logic [2048-1:0]         p_square_r1                             ,
    output logic [4096-1:0]         p_square_r1_multi_p_square_rho          ,
    output logic [2048-1:0]         p_square_r2                             ,
    output logic [2048-1:0]         q_square_r1                             ,
    output logic [4096-1:0]         q_square_r1_multi_q_square_rho          ,
    output logic [2048-1:0]         q_square_r2                             ,
    output logic [1024-1:0]         x_mod_p2                                ,
    output logic [1024-1:0]         x_mod_q2                                ,
    output logic [2048-1:0]         fai_p2                                  ,
    output logic [2048-1:0]         fai_q2                                  ,
    output logic [2048-1:0]         double_n_mod_fai_p2                     ,
    output logic [2048-1:0]         double_n_mod_fai_q2                     ,
    output logic [2048-1:0]         y_p2                                    ,
    output logic [2048-1:0]         y_q2                                    ,
    output logic [2048-1:0]         p2_inverse_mod_q2                       ,
    output logic [2048-1:0]         y_q2_sub_y_p2_multi_p2_inverse_mod_q2   ,
    output logic [4096-1:0]         y
);

/********************************Define Variables********************************/

/********************************Generate Public Key********************************/

    always_comb begin
        n = cacl_n(p,q);
        lambda = cacl_lambda(p,q);

        n_square = cacl_n_square(n);
        p_square = cacl_p_square(p);
        q_square = cacl_q_square(q);

        n_square_rho = cacl_n_square_rho(n_square);
        p_square_rho = cacl_p_square_rho(p_square);
        q_square_rho = cacl_q_square_rho(q_square);

        n_square_rho_sub1 = cacl_n_square_rho_sub1(n_square_rho);
        p_square_rho_sub1 = cacl_p_square_rho_sub1(p_square_rho);
        q_square_rho_sub1 = cacl_q_square_rho_sub1(q_square_rho);

        n_square_inverse_mod_n_square_rho = cacl_n_square_inverse_mod_n_square_rho(n_square,n_square_rho);
        p_square_inverse_mod_p_square_rho = cacl_p_square_inverse_mod_p_square_rho(p_square,p_square_rho);
        q_square_inverse_mod_q_square_rho = cacl_q_square_inverse_mod_q_square_rho(q_square,q_square_rho);

        n_square_r1 = cacl_n_square_r1(n_square,n_square_rho_sub1);
        n_square_r1_multi_n_square_rho = cacl_n_square_r1_multi_n_square_rho(n_square_r1,n_square_rho);
        n_square_r2 = cacl_n2_r1_multi_n2_rho_mod_n2(n_square_r1_multi_n_square_rho,n_square);

        p_square_r1 = cacl_p_square_r1(p_square,p_square_rho_sub1);
        p_square_r1_multi_p_square_rho = cacl_p_square_r1_multi_p_square_rho(p_square_r1,p_square_rho);
        p_square_r2 = cacl_p2_r1_multi_p2_rho_mod_p2(p_square_r1_multi_p_square_rho,p_square);

        q_square_r1 = cacl_q_square_r1(q_square,q_square_rho_sub1);
        q_square_r1_multi_q_square_rho = cacl_q_square_r1_multi_q_square_rho(q_square_r1,q_square_rho);
        q_square_r2 = cacl_q2_r1_multi_q2_rho_mod_q2(q_square_r1_multi_q_square_rho,q_square);

        x_mod_p2    = cacl_x_mod_p2(x,p_square);
        x_mod_q2    = cacl_x_mod_q2(x,q_square);
        fai_p2     = cacl_fai_p2(p_square,p);
        fai_q2     = cacl_fai_q2(q_square,q);
        double_n_mod_fai_p2 = cacl_2n_mod_fai_p2(n,fai_p2);
        double_n_mod_fai_q2 = cacl_2n_mod_fai_q2(n,fai_q2);
        y_p2        = cacl_y_p2(x_mod_p2,double_n_mod_fai_p2,p_square);
        y_q2        = cacl_y_q2(x_mod_q2,double_n_mod_fai_q2,q_square);
        p2_inverse_mod_q2 = cacl_p2_inverse_mod_q2(p_square,q_square);
        y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = cacl_y_q2_sub_y_p2_multi_p2_inverse_mod_q2(y_p2,y_q2,p2_inverse_mod_q2,q_square);
        y           = cacl_y(y_p2,y_q2_sub_y_p2_multi_p2_inverse_mod_q2,p_square);


        hs = cacl_hs(p,q,x,p_square,q_square,n,n_square);
    end

endmodule