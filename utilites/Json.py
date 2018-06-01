import json


class Json:
    def __init__(self):
        pass

    @staticmethod
    def to_object(json_data):
        obj = json.loads(json_data)
        return obj

    @staticmethod
    def to_string(obj):
        json_data = json.dumps(obj)
        return json_data


if __name__ == '__main__':
    some_dict = {'1': '1', '2': '2'}
    json_data = Json.to_string(some_dict)
    json_obj = Json.to_object(json_data)