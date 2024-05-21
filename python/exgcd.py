import gmpy2
from paillier_crt import PaillierKeyGenerator

num = 0
error_num = 0

def exgcd(a,b):
    x0 = 1
    r0 = a

    x1 = 0
    r1 = b

    while(r1 != 1):
        quo = r0 // r1
        x_tmp = x0 - quo * x1
        r_tmp = r0 - quo * r1

        x0 = x1
        r0 = r1

        x1 = x_tmp
        r1 = r_tmp
    return x1


# while(num != 120):
#     p, q = PaillierKeyGenerator._generate_p_q(1024)
#     result = exgcd(p**2, q**2)
#     ref_result = gmpy2.invert(p**2,q**2)
#     # print(f'处理前result = {result}')
#     num = num + 1
#     if result < 0:
#         result = result + q**2
#     else:
#         result = result

#     if result == ref_result:
#         error_num = error_num
#     else :
#         error_num = error_num + 1
# print(f'error_num = {error_num}')

while(num != 120):
    p, q = PaillierKeyGenerator._generate_p_q(1024)
    n = p * q

    n_square = n**2
    p_square = p**2
    q_square = q**2

    rho_n_square = pow(2,n_square.bit_length())
    rho_p_square = pow(2,p_square.bit_length())
    rho_q_square = pow(2,q_square.bit_length())

    result_n = exgcd(n_square, rho_n_square)
    result_p = exgcd(p_square, rho_p_square)
    result_q = exgcd(q_square, rho_q_square)

    ref_result_n = gmpy2.invert(n_square, rho_n_square)
    ref_result_p = gmpy2.invert(p_square, rho_p_square)
    ref_result_q = gmpy2.invert(q_square, rho_q_square)

    num = num + 1

    if result_n < 0:
        result_n = result_n + rho_n_square
    else:
        result_n = result_n

    if result_p < 0:
        result_p = result_p + rho_p_square
    else:
        result_p = result_p

    if result_q < 0:
        result_q = result_q + rho_q_square
    else:
        result_q = result_q

    if result_n == ref_result_n and result_p == ref_result_p and result_q == ref_result_q:
        error_num = error_num
    else :
        error_num = error_num + 1
print(f'error_num = {error_num}')
