from paillier_crt import PaillierKeyGenerator, Paillier, CryptoNumber

print('start paillier origin tests')
key_size = 2048
print(f'n的位宽为{key_size}，p和q的位宽为{key_size//2}')
print('')

# 初始化参数
print('初始化参数')
print('')

# 生成公钥和私钥
print('素数对p,q,公钥和私钥的取值如下')
public_key, private_key = PaillierKeyGenerator.generate_keypair(key_size)
print(f'public_key = {public_key}')
print(f'private_key = {private_key}')

# 加密的密码
encrypt_cipher = Paillier(Paillier.CIPHER_MODE_ENCRYPT, public_key)
print(f'加密密码 encrypt_cipher = {encrypt_cipher.public_key,encrypt_cipher.private_key}')

# 解密的密码
decrypt_cipher = Paillier(Paillier.CIPHER_MODE_DECRYPT, private_key)
print(f'解密密码 decrypt_cipher = {decrypt_cipher.public_key,decrypt_cipher.private_key}')
print('')

# 验证加解密
print('验证加解密')
print('')

# 明文c1
c1 = 34
print(f'明文 c1 = {c1}')

cipher_text_c1 = encrypt_cipher.encrypt(c1)
print(f'密文 cipher_text_c1 = {cipher_text_c1.cipher_text}')

plain_text_c1 = decrypt_cipher.decrypt(cipher_text_c1)
print(f'由密文解密得出的明文 decrypt_cipher_text_c1 = {plain_text_c1}')

print('')

# 验证同态加法
print('验证同态乘法')
print('')

# 明文c2 = 55
c2 = 55
print(f'明文 c2 = {c2}')
print(f'明文 c1 + c2 = {c1 + c2}')

# 对明文c2进行加密
cipher_text_c2 = encrypt_cipher.encrypt(c2)
print(f'密文c2 cipher_text_c2 = {cipher_text_c2.cipher_text}')

# 密文cipher_text_c1与密文cipher_text_c2相加
cipher_text = cipher_text_c1 + cipher_text_c2
print(f'密文 c1 + 密文 c2 cipher_text = {cipher_text.cipher_text}')

# 对明文 c1 + c2 进行加密
cipher_text_origin = encrypt_cipher.encrypt(c1+c2)
print(f'密文 c1 + c2 cipher_text_origin = {cipher_text_origin.cipher_text}')

# 对密文cipher_text_c1和密文cipher_text_c2相加后得到的密文进行解密
plain_text = decrypt_cipher.decrypt(cipher_text)
print(f'由密文相加得到的密文解密出的明文 decrypt_cipher_text = {plain_text}')

# 对 c1 + c2 加密后得到的密文进行解密
plain_text_origin = decrypt_cipher.decrypt(cipher_text_origin)
print(f'由明文相加后加密得到的密文解密出的明文 decrypt_cipher_text_origin = {plain_text_origin}')

print('')

# 验证明文乘密文c1*k
print('验证同态标量乘')
print('')

# 标量k = 3
k = 3
print(f'标量k = {k}')

cipher_text_multi = cipher_text_c1 * k
plain_text_multi = decrypt_cipher.decrypt(cipher_text_multi)
print(f'密文c1乘明文k后解密出的明文 decrypt_cipher_text_multi = {plain_text_multi}')
