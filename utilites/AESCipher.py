# -*- coding: utf-8 -*-
from Crypto.Cipher import AES
import binascii


BLOCK_SIZE = 16  # Bytes
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * \
                chr(BLOCK_SIZE - len(s) % BLOCK_SIZE)
unpad = lambda s: s[:-ord(s[len(s) - 1:])]


class AESCipher(str):
    def __init__(self, *args, **kwargs):
        str.__init__(*args, **kwargs)

    def encrypt(self):
        key = "770A8A65DA156D24EE2A093277530142"
        iv = "92AE31A79FEEB2A3"

        raw = pad(self)
        cipher = AES.new(key, AES.MODE_CBC, iv)
        ciphertext = cipher.encrypt(raw)
        hex_text = binascii.hexlify(ciphertext)

        return hex_text.decode('utf8')

    def decrypt(self):
        key = "770A8A65DA156D24EE2A093277530142"
        iv = "92AE31A79FEEB2A3"

        try:
            ciphertext = binascii.unhexlify(self)
            cipher = AES.new(key, AES.MODE_CBC, iv)
            decrypted = cipher.decrypt(ciphertext)

            return unpad(decrypted).decode('utf8')
        except:
            return None

if __name__ == '__main__':
    some_dict = '{"coins": 111, "instagram_id": "1234", "cookies": "instacookies"}'
    encrypted = AESCipher(some_dict).encrypt()
    print(encrypted)
    # decrypted = AESCipher('dkjsbsdvb').decrypt()
    # print(decrypted)