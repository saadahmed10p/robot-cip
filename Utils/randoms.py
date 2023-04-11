import string
import random
from faker import Faker


def emails():
    a = ''.join(random.choice(string.ascii_lowercase + string.digits) for i in range(30))
    email = a + '@' + 'gmail.com'
    print(email)
    return email


def firstname():
    faker = Faker()
    name = faker.first_name()
    return name


def lastname():
    faker = Faker()
    name = faker.last_name()
    return name


def number():
    rand_int = random.randint(0, 100)
    return rand_int
