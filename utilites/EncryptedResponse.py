from .Json import Json
from .AESCipher import AESCipher


class EncryptedResponse:

    @staticmethod
    def response(response_dict):
        response_string = Json.to_string(response_dict)
        encrypted_string = AESCipher(response_string).encrypt()
        return encrypted_string