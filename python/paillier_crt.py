import random
import math
from collections import namedtuple

import gmpy2

"""使用中国剩余定理优化Paillier算法"""
"""Optimize paillier algorithm's use Chinese Remainder Theorem"""


class PaillierKeyGenerator:
    @staticmethod
    def _get_prime_over(N):
        rand_func = random.SystemRandom()
        r = gmpy2.mpz(rand_func.getrandbits(N))
        r = gmpy2.bit_set(r, N - 1)
        return int(gmpy2.next_prime(r))

    @staticmethod
    def _generate_p_q(key_size):
        p = q = None
        n_len = 0
        while n_len != key_size:
            p = PaillierKeyGenerator._get_prime_over(key_size // 2)
            while gmpy2.mod(p, 4) != 3:
                p = PaillierKeyGenerator._get_prime_over(key_size // 2)
            q = p
            while q == p:
                q = PaillierKeyGenerator._get_prime_over(key_size // 2)
                while gmpy2.mod(q, 4) != 3:
                    q = PaillierKeyGenerator._get_prime_over(key_size // 2)
            n = p * q
            n_len = n.bit_length()
        return p, q

    @staticmethod
    def generate_keypair(key_size, s=1):
        p, q = PaillierKeyGenerator._generate_p_q(key_size)
        print(f'p = {hex(p)}')
        print(f'q = {hex(q)}')

        n = p * q
        lam = (p - 1) * (q - 1) // 2
        print(f'lam = {hex(lam)}')

        mu = gmpy2.invert(lam, n)
        x = random.randint(2, min(p, q))
        print(f'x = {hex(x)}')
        h = -pow(x, 2)
        print(f'h = {h}')

        f_data = open('./temp/input_dat_py', 'w')
        f_data.write(str(format(int(hex(p),16),'x')) + '\n')
        f_data.write(str(format(int(hex(q),16),'x')) + '\n')
        f_data.write(str(format(int(hex(x),16),'x')) + '\n')
        f_data.close()

        n_square = pow(n, 2)
        hs = gmpy2.powmod(h, n, n_square)
        max_alpha = pow(2, int(gmpy2.ceil(key_size // 2)))

        PublicKey = namedtuple("PublicKey", "n hs max_alpha")
        PrivateKey = namedtuple("PrivateKey", "public_key p q")
        public_key = PublicKey(n=n, hs=hs, max_alpha=max_alpha)
        private_key = PrivateKey(public_key=public_key, p=p, q=q)

        p_square = pow(p, 2)
        q_square = pow(q, 2)

        n_square_rho = pow(2, (n_square.bit_length()))
        p_square_rho = pow(2, (p_square.bit_length()))
        q_square_rho = pow(2, (q_square.bit_length()))

        n_square_rho_sub1 = n_square_rho - 1;
        p_square_rho_sub1 = p_square_rho - 1;
        q_square_rho_sub1 = q_square_rho - 1;

        n_square_inverse_mod_n_square_rho = gmpy2.invert(n_square,n_square_rho)
        p_square_inverse_mod_p_square_rho = gmpy2.invert(p_square,p_square_rho)
        q_square_inverse_mod_q_square_rho = gmpy2.invert(q_square,q_square_rho)

        n_square_r1 = n_square_rho % n_square
        n_square_r1_multi_n_square_rho = n_square_r1 * n_square_rho
        n_square_r2 = n_square_rho**2 % n_square

        p_square_r1 = p_square_rho % p_square
        p_square_r1_multi_p_square_rho = p_square_r1 * p_square_rho
        p_square_r2 = p_square_rho ** 2 % p_square

        q_square_r1 = q_square_rho % q_square
        q_square_r1_multi_q_square_rho = q_square_r1 * q_square_rho
        q_square_r2 = q_square_rho ** 2 % q_square

        x_mod_p2 = x % p_square
        x_mod_q2 = x % q_square
        fai_p2   = p_square - p
        fai_q2   = q_square - q
        double_n_mod_fai_p2 = 2 * n % fai_p2
        double_n_mod_fai_q2 = 2 * n % fai_q2
        y_p2 = gmpy2.powmod(x_mod_p2,double_n_mod_fai_p2,p_square)
        y_q2 = gmpy2.powmod(x_mod_q2,double_n_mod_fai_q2,q_square)
        p2_inverse_mod_q2 = gmpy2.invert(p_square,q_square)
        y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = ((y_q2 - y_p2) * p2_inverse_mod_q2) % q_square
        y = y_p2 + ((y_q2 - y_p2) * p2_inverse_mod_q2 % q_square) * p_square

        diff = y_q2 - y_p2
        print('\n')
        print(f'处理前diff = {hex(diff)}')
        while diff < 0:
            diff = diff + q_square
        print(f'处理后diff = {hex(diff)}')
        print('\n')

        f_result = open('./temp/output_dat_py', 'w')
        f_result.write('n                                 = ' + format(n,                                 f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('hs                                = ' + format(hs,                                f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('lambda                            = ' + format(lam,                               f'0{math.ceil(2047/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square                          = ' + format(n_square,                          f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square                          = ' + format(p_square,                          f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square                          = ' + format(q_square,                          f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_rho                      = ' + format(n_square_rho,                      f'0{math.ceil(4097/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_rho                      = ' + format(p_square_rho,                      f'0{math.ceil(2049/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_rho                      = ' + format(q_square_rho,                      f'0{math.ceil(2049/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_rho_sub1                 = ' + format(n_square_rho_sub1,                 f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_rho_sub1                 = ' + format(p_square_rho_sub1,                 f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_rho_sub1                 = ' + format(q_square_rho_sub1,                 f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_inverse_mod_n_square_rho = ' + format(n_square_inverse_mod_n_square_rho, f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_inverse_mod_p_square_rho = ' + format(p_square_inverse_mod_p_square_rho, f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_inverse_mod_q_square_rho = ' + format(q_square_inverse_mod_q_square_rho, f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_r1                       = ' + format(n_square_r1,                       f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_r1_multi_n_square_rho    = ' + format(n_square_r1_multi_n_square_rho,    f'0{math.ceil(8192/4 + 2)}x')[2:] + '\n')
        f_result.write('n_square_r2                       = ' + format(n_square_r2,                       f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_r1                       = ' + format(p_square_r1,                       f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_r1_multi_p_square_rho    = ' + format(p_square_r1_multi_p_square_rho,    f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('p_square_r2                       = ' + format(p_square_r2,                       f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_r1                       = ' + format(q_square_r1,                       f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_r1_multi_q_square_rho    = ' + format(q_square_r1_multi_q_square_rho,    f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.write('q_square_r2                       = ' + format(q_square_r2,                       f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('x_mod_p2                          = ' + format(x_mod_p2                          ,f'0{math.ceil(1024/4 + 2)}x')[2:] + '\n')
        f_result.write('x_mod_q2                          = ' + format(x_mod_q2                          ,f'0{math.ceil(1024/4 + 2)}x')[2:] + '\n')
        f_result.write('fai_p2                            = ' + format(fai_p2                            ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('fai_q2                            = ' + format(fai_q2                            ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('double_n_mod_fai_p2               = ' + format(double_n_mod_fai_p2               ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('double_n_mod_fai_q2               = ' + format(double_n_mod_fai_q2               ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('y_p2                              = ' + format(y_p2                              ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('y_q2                              = ' + format(y_q2                              ,f'0{math.ceil(2048/4 + 2)}x')[2:] + '\n')
        f_result.write('p2_inverse_mod_q2                 = ' + format(p2_inverse_mod_q2                 ,f'0x') + '\n')
        f_result.write('y_q2_sub_y_p2_multi_p2_inverse_mod_q2 = ' + format(y_q2_sub_y_p2_multi_p2_inverse_mod_q2,f'0x') + '\n')
        f_result.write('y                                 = ' + format(y                                 ,f'0x') + '\n')
        f_result.write(f'p2_inverse_mod_q2                 = {p2_inverse_mod_q2}' + '\n')
        f_result.write('n2 - y                            = ' + format(n_square-y                        ,f'0{math.ceil(4096/4 + 2)}x')[2:] + '\n')
        f_result.close()

        return public_key, private_key


class Paillier:
    CIPHER_MODE_ENCRYPT = 0
    CIPHER_MODE_DECRYPT = 1

    def __init__(self, cipher_mode, cipher_key):
        if cipher_mode == Paillier.CIPHER_MODE_ENCRYPT:
            self.public_key = cipher_key
            self.private_key = None
        elif cipher_mode == Paillier.CIPHER_MODE_DECRYPT:
            self.public_key = cipher_key.public_key
            self.private_key = cipher_key

            self.hp = gmpy2.invert((self.private_key.p - 1) * self.private_key.q, self.private_key.p)
            self.hq = gmpy2.invert((self.private_key.q - 1) * self.private_key.p, self.private_key.q)
            self.p_square = pow(self.private_key.p, 2)
            self.q_square = pow(self.private_key.q, 2)
            self.p_inverse = gmpy2.invert(self.private_key.p, self.private_key.q)
        else:
            raise ValueError('cipher_mode value must be either CIPHER_MODE_ENCRYPT or CIPHER_MODE_DECRYPT')
        self.cipher_mode = cipher_mode
        self.n_square = pow(self.public_key.n, 2)

    def fn_L(self, x, denominator):
        return (x - 1) // denominator

    def encrypt(self, m):
        alpha = random.randint(2, self.public_key.max_alpha - 1)
        print(f'alpha = {alpha}')
        # 使用powmod优化模幂运算
        cipher_text = gmpy2.mod((m * self.public_key.n + 1) * gmpy2.powmod(self.public_key.hs, alpha, self.n_square),
                                self.n_square)
        return CryptoNumber(cipher_text, self.n_square)

    def decrypt(self, crypto_number):
        # 使用powmod优化模幂运算
        mp = gmpy2.mod(self.fn_L(gmpy2.powmod(crypto_number.cipher_text, self.private_key.p - 1, self.p_square),
                                 self.private_key.p) * self.hp, self.private_key.p)
        mq = gmpy2.mod(self.fn_L(gmpy2.powmod(crypto_number.cipher_text, self.private_key.q - 1, self.q_square),
                                 self.private_key.q) * self.hq, self.private_key.q)
        return gmpy2.mod(self.crt(mp, mq), self.public_key.n)

    def crt(self, mp, mq):
        u = gmpy2.mod(gmpy2.mul(mq - mp, self.p_inverse), self.private_key.q)
        return mp + (u * self.private_key.p)


class CryptoNumber:
    def __init__(self, cipher_text, n_square):
        self.cipher_text = cipher_text
        self.n_square = n_square

    def __add__(self, other):
        if isinstance(other, CryptoNumber):
            sum_ciphertext = gmpy2.mod(self.cipher_text * other.cipher_text, self.n_square)
            return CryptoNumber(sum_ciphertext, self.n_square)
        else:
            pass

    def __mul__(self, other):
        if isinstance(other, CryptoNumber):
            raise NotImplementedError('not supported between instance of "CryptoNumber" and "CryptoNumber"')
        else:
            mul_cipher_text = gmpy2.mod(pow(self.cipher_text, other), self.n_square)
            return CryptoNumber(mul_cipher_text, self.n_square)
