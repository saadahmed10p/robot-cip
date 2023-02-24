import string
import random


def emails():
    a = ''.join(random.choice(string.ascii_lowercase + string.digits) for i in range(30))
    email = a + '@' + 'gmail.com'
    print(email)
    return email


