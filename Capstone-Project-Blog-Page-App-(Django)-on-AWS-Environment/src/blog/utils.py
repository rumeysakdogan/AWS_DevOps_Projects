import uuid


def get_random_code():
    code = str(uuid.uuid4())[:11].replace("-", "")
    return code
