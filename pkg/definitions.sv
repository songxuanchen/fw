`ifndef DEF_DONE
    `define DEF_DONE

    package definitions;
/********************************Define Functions********************************/

    //* 大数相乘计算n=pq
    function logic [2048-1:0]   cacl_n(logic [1024-1:0] p, logic [1024-1:0] q);
        logic [2048-1:0] product;
        logic [2048-1:0] ex_p   ;
        product = 0             ;
        ex_p    = {1024'b0,p}   ;
        for(int i = 0; i < 1024; i = i + 1)begin
            if(q[0] == 1)begin
                product = product + ex_p;
            end
            else begin
                product = product;
            end
            ex_p = ex_p << 1;
            q = q >> 1;
        end
        return product;
    endfunction

    //* 大数相乘计算lambda = (p-1)(q-1)/2，p、q均为素数（奇数），p-1和q-1均为偶数，所以最后的除以2就是移一位
    function logic [2048-1-1:0]   cacl_lambda(logic [1024-1:0] p, logic [1024-1:0] q);
        logic [2048-1:0]    product ;
        logic [2048-1:0]    ex_p    ;
        p = p - 1;
        q = q - 1;
        product = 0             ;
        ex_p    = {1024'b0,p}   ;
        for(int i = 0; i < 1024; i = i + 1)begin
            if(q[0] == 1)begin
                product = product + ex_p;
            end
            else begin
                product = product;
            end
            ex_p = ex_p << 1;
            q = q >> 1;
        end
        return product[2047:1];
    endfunction

    //* 大数相乘计算n^2
    function logic [4096-1:0]   cacl_n_square(logic [2048-1:0] n);
        logic [4096-1:0]    power   ;
        logic [4096-1:0]    ex_n    ;
        power = 0                   ;
        ex_n  = {2048'b0,n}         ;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(n[0] == 1)begin
                power = power + ex_n;
            end
            else begin
                power = power;
            end
            ex_n = ex_n << 1;
            n = n >> 1;
        end
        return power;
    endfunction

    //* 大数相乘计算p^2和q^2
    function logic [2048-1:0]   cacl_p_square(logic [1024-1:0] p);
        logic [2048-1:0] power  ;
        logic [2048-1:0] ex_p   ;
        power = 0               ;
        ex_p  = {1024'b0,p}     ;
        for(int i = 0; i < 1024; i = i + 1)begin
            if(p[0] == 1)begin
                power = power + ex_p;
            end
            else begin
                power = power;
            end
            ex_p = ex_p << 1;
            p = p >> 1      ;
        end
        return power;
    endfunction

    function logic [2048-1:0]   cacl_q_square(logic [1024-1:0] q);
        logic [2048-1:0] power  ;
        logic [2048-1:0] ex_q   ;
        power = 0               ;
        ex_q  = {1024'b0,q}     ;
        for(int i = 0; i < 1024; i = i + 1)begin
            if(q[0] == 1)begin
                power = power + ex_q;
            end
            else begin
                power = power;
            end
            ex_q = ex_q << 1;
            q = q >> 1      ;
        end
        return power;
    endfunction

    //* 求n^2_rho
    function logic [4096:0]     cacl_n_square_rho(logic [4096-1:0] n_square);
        logic [4096-1:0]    n_square_reverse    ;
        logic [4096-1:0]    n_square_rho_reverse;
        logic [4096-1:0]    n_square_rho        ;
        for(int i = 0; i < 4096; i = i + 1)begin
            n_square_reverse[i] = n_square[4096 - 1 - i];
        end
        n_square_rho_reverse = ~(n_square_reverse-1) & n_square_reverse;
        for(int i = 0; i < 4096; i = i + 1)begin
            n_square_rho[i] = n_square_rho_reverse[4096 - 1 -i];
        end
        return {n_square_rho,1'b0};
    endfunction

    //TODO 求n2_rho - 1(n2_rho是个独热码，这个计算过程类似001000 - 1 = 000111，应该有优化关键路径长度的方案，但是我只能想到4096周期算完的，太慢了)
    function logic [4096-1:0]   cacl_n_square_rho_sub1(logic [4096:0] n_square_rho);
        logic [4096-1:0] n_square_rho_sub1;
        n_square_rho_sub1 = n_square_rho - 1;
        return n_square_rho_sub1;
    endfunction

    //* 求p^2_rho和q^2_rho
    function logic [2048:0]     cacl_p_square_rho(logic [2048-1:0] p_square);
        logic [2048-1:0]    p_square_reverse    ;
        logic [2048-1:0]    p_square_rho_reverse;
        logic [2048-1:0]    p_square_rho        ;
        for(int i = 0; i < 2048; i = i + 1)begin
            p_square_reverse[i] = p_square[2048 - 1 - i];
        end
        p_square_rho_reverse = ~(p_square_reverse-1) & p_square_reverse;
        for(int i = 0; i < 2048; i = i + 1)begin
            p_square_rho[i] = p_square_rho_reverse[2048 - 1 -i];
        end
        return {p_square_rho,1'b0};
    endfunction

    function logic [2048:0]     cacl_q_square_rho(logic [2048-1:0] q_square);
        logic [2048-1:0]    q_square_reverse    ;
        logic [2048-1:0]    q_square_rho_reverse;
        logic [2048-1:0]    q_square_rho        ;
        for(int i = 0; i < 2048; i = i + 1)begin
            q_square_reverse[i] = q_square[2048 - 1 - i];
        end
        q_square_rho_reverse = ~(q_square_reverse-1) & q_square_reverse;
        for(int i = 0; i < 2048; i = i + 1)begin
            q_square_rho[i] = q_square_rho_reverse[2048 - 1 -i];
        end
        return {q_square_rho,1'b0};
    endfunction

    //TODO 求p2_rho - 1和q2_rho - 1
    function logic [2048-1:0]   cacl_p_square_rho_sub1(logic [2048:0] p_square_rho);
        logic [2048-1:0] p_square_rho_sub1;
        p_square_rho_sub1 = p_square_rho - 1;
        return p_square_rho_sub1;
    endfunction

    function logic [2048-1:0]   cacl_q_square_rho_sub1(logic [2048:0] q_square_rho);
        logic [2048-1:0] q_square_rho_sub1;
        q_square_rho_sub1 = q_square_rho - 1;
        return q_square_rho_sub1;
    endfunction

    //TODO 扩展欧几里得算法求n^2对于n^2_rho的模逆(这个函数需要再考虑一下怎么用硬件实现，主要问题是怎么判断怎么结束)
    function logic [4096:0]     cacl_4096bit_r0_divide_r1(logic [4096:0] r0,r1);
        logic [8193:0]  ex_r0   ;
        logic [8193:0]  ex_r1   ;
        logic [4096:0]  quo     ;
        ex_r0 = {4097'b0,r0};
        ex_r1 = {r1,4097'b0};
        quo = 0;
        for(int i = 0; i < 4097; i = i + 1)begin
            ex_r1 = ex_r1 >> 1;
            if(ex_r0 >= ex_r1)begin
                ex_r0 = ex_r0 - ex_r1;
                quo[4096 - i] = 1;
            end
            else begin
                ex_r0 = ex_r0;
                quo[4096 - i] = 0;
            end
        end
        return quo;
    endfunction

    function logic [4096-1:0]   cacl_n_square_inverse_mod_n_square_rho(logic [4096-1:0] square, logic [4096:0] rho);
        logic [4096:0]      r0,r1,r_tmp ;
        logic [4096-1:0]    x0,x1,x_tmp ;
        logic [4096-1:0]    quo         ;
        //Initial
        x0      =   1                       ;
        r0      =   {1'b0,square}           ;

        x1      =   0                       ;
        r1      =   rho                     ;

        //Loop
        while(r1 != 1)begin
            //r_n/r_n+1
            //quo = cacl_4096bit_r0_divide_r1(r0,r1);
            quo = r0/r1;
            //r_n+2 = r_n - quo * r_n+1
            r_tmp = r0 - quo*r1;
            x_tmp = x0 - quo*x1;

            //r0 <- r1,r1 <- r_tmp
            r0 = r1     ;
            r1 = r_tmp  ;
            x0 = x1     ;
            x1 = x_tmp  ;
        end
        if(x1 >= rho)   return (x1 - rho);
        else            return x1;
    endfunction

    //TODO 扩展欧几里得算法求p^2对于p^2_rho的模逆和q^2对于q^2_rho的模逆
    function logic [2048:0]     cacl_2048bit_r0_divide_r1(logic [2048:0] r0,r1);
        logic [4097:0]  ex_r0   ;
        logic [4097:0]  ex_r1   ;
        logic [2048:0]  quo     ;
        ex_r0 = {2049'b0,r0};
        ex_r1 = {r1,2049'b0};
        quo = 0;
        for(int i = 0; i < 2049; i = i + 1)begin
            ex_r1 = ex_r1 >> 1;
            if(ex_r0 >= ex_r1)  begin
                ex_r0 = ex_r0 - ex_r1;
                quo[2048 - i] = 1;
            end
            else begin
                ex_r0 = ex_r0;
                quo[2048 - i] = 0;
            end
        end
        return quo;
    endfunction

    function logic [2048-1:0]   cacl_p_square_inverse_mod_p_square_rho(logic [2048-1:0] square, logic [2048:0] rho);
        logic [2048:0]      r0,r1,r_tmp ;
        logic [2048-1:0]    x0,x1,x_tmp ;
        logic [2048-1:0]    quo         ;
        //Initial
        x0      =   1                       ;
        r0      =   {1'b0,square}           ;

        x1      =   0                       ;
        r1      =   rho                     ;

        //Loop
        while(r1 != 1)begin
            //r_n/r_n+1
            //quo = cacl_2048bit_r0_divide_r1(r0,r1);
            quo = r0/r1;
            //r_n+2 = r_n - quo * r_n+1
            r_tmp = r0 - quo*r1;
            x_tmp = x0 - quo*x1;

            //r0 <- r1,r1 <- r_tmp
            r0 = r1     ;
            r1 = r_tmp  ;
            x0 = x1     ;
            x1 = x_tmp  ;
        end
        if(x1 >= rho)   return (x1 - rho);
        else            return x1;
    endfunction

    function logic [2048-1:0]   cacl_q_square_inverse_mod_q_square_rho(logic [2048-1:0] square, logic [2048:0] rho);
        logic [2048:0]      r0,r1,r_tmp ;
        logic [2048-1:0]    x0,x1,x_tmp ;
        logic [2048-1:0]    quo         ;
        //Initial
        x0      =   1               ;
        r0      =   {1'b0,square}   ;

        x1      =   0               ;
        r1      =   rho             ;

        //Loop
        while(r1 != 1)begin
            //r_n/r_n+1
            //quo = cacl_2048bit_r0_divide_r1(r0,r1);
            quo = r0/r1;
            //r_n+2 = r_n - quo * r_n+1
            r_tmp = r0 - quo*r1;
            x_tmp = x0 - quo*x1;

            //r0 <- r1,r1 <- r_tmp
            r0 = r1     ;
            r1 = r_tmp  ;
            x0 = x1     ;
            x1 = x_tmp  ;
        end
        if(x1 >= rho)   return (x1 - rho);
        else            return x1;
    endfunction

/********************************计算n2_r1和n2_r2********************************/

    //* 求n_square_r1 = n_square_rho mod n_square (001000 - 000101 = 000011这种怎么算好一点)
    function logic [4096-1:0]   cacl_n_square_r1(logic [4096-1:0] n_square, logic [4096-1:0] n_square_rho_sub1 );
        logic [4096-1:0]    n_square_r1;
        n_square_r1 = n_square ^ n_square_rho_sub1;
        n_square_r1 = n_square_r1 + 1;
        return n_square_r1;
    endfunction

    //* 计算n_square_r2时会用到n_square_r1 * n_square_rho
    function logic [8192-1:0]     cacl_n_square_r1_multi_n_square_rho(logic [4096-1:0] n_square_r1, logic [4096:0] n_square_rho);
        logic [8192-1:0] product          ;
        logic [8192-1:0] ex_n_square_r1   ;
        product = 0;
        ex_n_square_r1 = {4096'b0,n_square_r1};
        for(int i = 0; i < 4097; i= i + 1)begin
            if(n_square_rho[0] == 1)    product = ex_n_square_r1;
            else                        product = product       ;
            ex_n_square_r1 = ex_n_square_r1 << 1;
            n_square_rho = n_square_rho >> 1;
        end
        return product;
    endfunction

    //* 高位相减求n_square_r2 = n_square_r1 * n_square_rho mod n_square
    function logic [4096-1:0] cacl_n2_r1_multi_n2_rho_mod_n2(logic [8192-1:0] n2_r1_multi_n2_rho, logic [4096-1:0] n2);
        logic [8192-1:0]    remainder       ;
        logic [8192-1:0]    divisor         ;
        remainder   = n2_r1_multi_n2_rho    ;
        divisor     = {n2,4096'b0}          ;
        for(int i = 0; i < 4096; i = i + 1)begin
            if(remainder >= divisor)    remainder = remainder - divisor ;
            else                        remainder = remainder           ;
            divisor = divisor >> 1;
        end
        if(remainder >= divisor)    return (remainder - divisor);
        else                        return remainder            ;
    endfunction

/********************************计算p2_r1和p2_r2********************************/

    //* 求p_square_r1 = p_square_rho mod p_square
    function logic [2048-1:0]   cacl_p_square_r1(logic [2048-1:0] p_square, logic [2048-1:0] p_square_rho_sub1 );
        logic [2048-1:0]    p_square_r1;
        p_square_r1 = p_square ^ p_square_rho_sub1;
        p_square_r1 = p_square_r1 + 1;
        return p_square_r1;
    endfunction

    //* 计算p_square_r2时会用到p_square_r1 * p_square_rho，p_square_rho是一个独热码
    function logic [4096-1:0]     cacl_p_square_r1_multi_p_square_rho(logic [2048-1:0] p_square_r1, logic [2048:0] p_square_rho);
        logic [4096-1:0] product          ;
        logic [4096-1:0] ex_p_square_r1   ;
        product = 0;
        ex_p_square_r1 = {2048'b0,p_square_r1};
        for(int i = 0; i < 2049; i= i + 1)begin
            if(p_square_rho[0] == 1)    product = ex_p_square_r1;
            else                        product = product       ;
            ex_p_square_r1 = ex_p_square_r1 << 1;
            p_square_rho = p_square_rho >> 1;
        end
        return product;
    endfunction

    //* 高位相减求p_square_r2 = p_square_r1 * p_square_rho mod p_square
    function logic [2048-1:0] cacl_p2_r1_multi_p2_rho_mod_p2(logic [4096-1:0] p2_r1_multi_p2_rho, logic [2048-1:0] p2);
        logic [4096-1:0]    remainder       ;
        logic [4096-1:0]    divisor         ;
        remainder   = p2_r1_multi_p2_rho    ;
        divisor     = {p2,2048'b0}          ;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(remainder >= divisor)    remainder = remainder - divisor ;
            else                        remainder = remainder           ;
            divisor = divisor >> 1;
        end
        if(remainder >= divisor)    return (remainder - divisor);
        else                        return remainder            ;
    endfunction

/********************************计算q2_r1和q2_r2********************************/

    //* 求q_square_r1 = q_square_rho mod q_square
    function logic [2048-1:0]   cacl_q_square_r1(logic [2048-1:0] q_square, logic [2048:0] q_square_rho_sub1 );
        logic [2048-1:0]    q_square_r1;
        q_square_r1 = q_square ^ q_square_rho_sub1;
        q_square_r1 = q_square_r1 + 1;
        return q_square_r1;
    endfunction

    //* 计算q_square_r2时会用到q_square_r1 * q_square_rho，q_square_rho是一个独热码
    function logic [4096-1:0]     cacl_q_square_r1_multi_q_square_rho(logic [2048-1:0] q_square_r1, logic [2048:0] q_square_rho);
        logic [4096-1:0] product          ;
        logic [4096-1:0] ex_q_square_r1   ;
        product = 0;
        ex_q_square_r1 = {2048'b0,q_square_r1};
        for(int i = 0; i < 2049; i= i + 1)begin
            if(q_square_rho[0] == 1)    product = ex_q_square_r1;
            else                        product = product       ;
            ex_q_square_r1 = ex_q_square_r1 << 1;
            q_square_rho = q_square_rho >> 1;
        end
        return product;
    endfunction

    //* 高位相减求q_square_r2 = q_square_r1 * q_square_rho mod q_square
    function logic [2048-1:0] cacl_q2_r1_multi_q2_rho_mod_q2(logic [4096-1:0] q2_r1_multi_q2_rho, logic [2048-1:0] q2);
        logic [4096-1:0]    remainder       ;
        logic [4096-1:0]    divisor         ;
        remainder   = q2_r1_multi_q2_rho    ;
        divisor     = {q2,2048'b0}          ;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(remainder >= divisor)    remainder = remainder - divisor ;
            else                        remainder = remainder           ;
            divisor = divisor >> 1;
        end
        if(remainder >= divisor)    return (remainder - divisor);
        else                        return remainder            ;
    endfunction

/********************************计算hs********************************/

    //TODO 计算x mod p2
    function logic [2048-1:0]   cacl_x_mod_p2(logic [1024-1:0] x, logic [2048-1:0] p2);
        logic [3072-1:0] ex_p2      ;
        logic [3072-1:0] remainder  ;
        remainder   = {2048'b0,x    };
        ex_p2       = {p2,1024'b0   };
        for(int i = 3072 - 1; i >= 2048 - 1; i = i - 1)begin
            if(remainder >= ex_p2)begin
                remainder = remainder - ex_p2;
            end
            else begin
                remainder = remainder;
            end
            ex_p2 = ex_p2 >> 1;
        end
        return remainder[2048-1:0];
    endfunction

    //TODO 计算x mod q2
    function logic [2048-1:0]   cacl_x_mod_q2(logic [1024-1:0] x, logic [2048-1:0] q2);
        logic [3072-1:0] ex_q2      ;
        logic [3072-1:0] remainder  ;
        remainder   = {2048'b0,x    };
        ex_q2       = {q2,1024'b0   };
        for(int i = 3072 - 1; i >= 2047; i = i - 1)begin
            if(remainder >= ex_q2)begin
                remainder = remainder - ex_q2;
            end
            else begin
                remainder = remainder;
            end
            ex_q2 = ex_q2 >> 1;
        end
        return remainder[2048-1:0];
    endfunction

    //* 计算fai_p2
    function logic [2048-1:0]   cacl_fai_p2(logic [2048-1:0] p2, logic [1024-1:0] p);
        return (p2 - p);
    endfunction

    //* 计算fai_q2
    function logic [2048-1:0]   cacl_fai_q2(logic [2048-1:0] q2, logic [1024-1:0] q);
        return (q2 - q);
    endfunction

    //TODO 计算2n mod fai_p2
    function logic [2048-1:0] cacl_2n_mod_fai_p2(logic [2048-1:0] n, logic [2048-1:0] fai_p2);
        logic [4096:0]  remainder       ;
        logic [4096:0]  ex_fai_p2       ;
        remainder = {2048'b0,n,1'b0}  ;
        ex_fai_p2 = {fai_p2,2049'b0}  ;
        for(int i = 4096; i >= 2048-1; i = i - 1)begin
            if(remainder >= ex_fai_p2)  remainder = remainder - ex_fai_p2;
            else                        remainder = remainder;
            ex_fai_p2 = ex_fai_p2 >> 1;
        end
        return remainder[2048-1:0];
    endfunction

    //TODO 计算2n mod fai_q2
    function logic [2048-1:0] cacl_2n_mod_fai_q2(logic [2048-1:0] n, logic [2048-1:0] fai_q2);
        logic [4096:0]  remainder       ;
        logic [4096:0]  ex_fai_q2       ;
        remainder = {2048'b0,n,1'b0}    ;
        ex_fai_q2 = {fai_q2,2049'b0}  ;
        for(int i = 4096; i >= 2048-1; i = i - 1)begin
            if(remainder >= ex_fai_q2)  remainder = remainder - ex_fai_q2;
            else                        remainder = remainder;
            ex_fai_q2 = ex_fai_q2 >> 1;
        end
        return remainder[2048-1:0];
    endfunction

    //TODO 计算y_p2 = pow((x mod p2),(2n mod fai_p2)) mod p2
    function logic [2048-1:0] cacl_y_p2(logic [2048-1:0] x_mod_p2, logic [2048-1:0] double_n_mod_fai_p2, logic [2048-1:0] p2);
        logic [4096-1:0] x_powmod_p2;
        logic [4096-1:0] result     ;
        x_powmod_p2     = x_mod_p2  ;
        result          = 1         ;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(double_n_mod_fai_p2[i] == 1)begin
                result = result * x_powmod_p2 % p2;
            end
            else begin
                result = result;
            end
            x_powmod_p2 = (x_powmod_p2**2) % p2;
        end
        return result[2048-1:0];
    endfunction

    //TODO 计算y_q2 = pow((x mod q2),(2n mod fai_q2)) mod q2
    function logic [2048-1:0] cacl_y_q2(logic [2048-1:0] x_mod_q2, logic [2048-1:0] double_n_mod_fai_q2, logic [2048-1:0] q2);
        logic [4096-1:0] x_powmod_q2;
        logic [4096-1:0] result     ;
        x_powmod_q2     = x_mod_q2  ;
        result          = 1         ;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(double_n_mod_fai_q2[i] == 1)begin
                result = result * x_powmod_q2 % q2;
            end
            else begin
                result = result;
            end
            x_powmod_q2 = (x_powmod_q2**2) % q2;
        end
        return result[2048-1:0];
    endfunction

    //TODO 扩展欧几里得算法计算p2_inverse mod q2
    function logic [2048-1:0]   cacl_p2_inverse_mod_q2(logic [2048-1:0] p2, logic [2048-1:0] q2);
        logic [2048-1:0]      r0,r1,r_tmp ;
        logic [2048:0]        x0,x1,x_tmp ;
        logic [2048-1:0]      quo         ;
        //Initial
        x0      =   1               ;
        r0      =   p2              ;

        x1      =   0               ;
        r1      =   q2              ;

        //Loop
        while(r1 != 1)begin
            //r_n/r_n+1
            //quo = cacl_2048bit_r0_divide_r1(r0,r1);
            quo = r0/r1;
            //r_n+2 = r_n - quo * r_n+1
            r_tmp = r0 - quo*r1;
            x_tmp = x0 - {x1[2048],quo*x1[2048-1:0]};

            //r0 <- r1,r1 <- r_tmp
            r0 = r1     ;
            r1 = r_tmp  ;
            x0 = x1     ;
            x1 = x_tmp  ;
        end
        if(x1[2048] == 1)    return (x1[2048-1:0] + q2);
        else            return x1[2048-1:0];
    endfunction

    //TODO 计算(y_q2 - y_p2) * p2_inverse mod q2
    function logic [2048-1:0] cacl_y_q2_sub_y_p2_multi_p2_inverse_mod_q2(logic [2048-1:0] y_p2, logic [2048-1:0] y_q2, logic [2048-1:0] p2_inverse_mod_q2, logic [2048-1:0] q2);
        logic [2048:0]      diff        ;
        logic [4096-1:0]    ex_diff     ;
        logic [4096-1:0]    product     ;
        logic [6144-1:0]    remainder   ;
        logic [6144-1:0]    divisor     ;
        diff = {1'b0,y_q2} - {1'b0,y_p2};
        while(diff[2048] == 1)begin
            diff = diff + q2;
        end

        ex_diff = {2048'b0,diff[2048-1:0]};
        product = 0;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(p2_inverse_mod_q2[0])    product = product + ex_diff;
            else                        product = product;
            ex_diff = ex_diff << 1;
            p2_inverse_mod_q2 = p2_inverse_mod_q2 >> 1;
        end

        remainder = {2048'b0,product};
        divisor   = {q2,4096'b0};

        for(int i = 0; i <= 4096; i = i + 1)begin
            if(remainder >= divisor)    remainder = remainder - divisor;
            else                        remainder = remainder;
            divisor = divisor >> 1;
        end

        return remainder[2048-1:0] ;
    endfunction

    //TODO 计算y = y_p2 + (y_q2 - y_p2) * p2_inverse_mod_q2 * p2
    function logic [4096-1:0]   cacl_y(logic [2048-1:0] y_p2, logic [2048-1:0] y_q2_sub_y_p2_multi_p2_inverse_mod_q2, logic [2048-1:0] p2);
        logic [4096-1:0] result;
        logic [4096-1:0] ex_y_q2_sub_y_p2_multi_p2_inverse_mod_q2;
        logic [4096-1:0] product;
        ex_y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = {2048'b0,y_q2_sub_y_p2_multi_p2_inverse_mod_q2};
        product = 0;
        for(int i = 0; i < 2048; i = i + 1)begin
            if(p2[0])   product = product + ex_y_q2_sub_y_p2_multi_p2_inverse_mod_q2;
            else        product = product;
            p2 = p2 >> 1;
            ex_y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = ex_y_q2_sub_y_p2_multi_p2_inverse_mod_q2 << 1;
        end
        result = y_p2 + product;
        return result;
    endfunction

    //TODO 计算hs = y
    function logic [4096-1:0]   cacl_hs(logic [1024-1:0] p, q, x, logic [2048-1:0] p2, q2, n, logic [4096-1:0] n_square);
        logic [1024-1:0] x_mod_p2               ;
        logic [1024-1:0] x_mod_q2               ;
        logic [2048-1:0] fai_p2                 ;
        logic [2048-1:0] fai_q2                 ;
        logic [2048-1:0] double_n_mod_fai_p2    ;
        logic [2048-1:0] double_n_mod_fai_q2    ;
        logic [2048-1:0] y_p2                   ;
        logic [2048-1:0] y_q2                   ;
        logic [2048-1:0] p2_inverse_mod_q2      ;
        logic [2048-1:0] y_q2_sub_y_p2_multi_p2_inverse_mod_q2;
        logic [4096-1:0] y                      ;
        x_mod_p2 = cacl_x_mod_p2(x,p2);
        x_mod_q2 = cacl_x_mod_q2(x,q2);
        fai_p2  = cacl_fai_p2(p2,p);
        fai_q2  = cacl_fai_q2(q2,q);
        double_n_mod_fai_p2 = cacl_2n_mod_fai_p2(n,fai_p2);
        double_n_mod_fai_q2 = cacl_2n_mod_fai_q2(n,fai_q2);
        y_p2     = cacl_y_p2(x_mod_p2,double_n_mod_fai_p2,p2);
        y_q2     = cacl_y_q2(x_mod_q2,double_n_mod_fai_q2,q2);
        p2_inverse_mod_q2 = cacl_p2_inverse_mod_q2(p2,q2);
        y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = cacl_y_q2_sub_y_p2_multi_p2_inverse_mod_q2(y_p2,y_q2,p2_inverse_mod_q2,q2);
        y = cacl_y(y_p2,y_q2_sub_y_p2_multi_p2_inverse_mod_q2,p2);
        return (n_square-y);
    endfunction
    endpackage

`endif