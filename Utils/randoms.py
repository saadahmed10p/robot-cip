import string
import re
import random
import csv
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


def amount_extract(amount_text):
    # amount_text = "$29.99"
    amount_numeric = float(re.sub(r'[^\d.]+', '', amount_text))
    # print(amount_numeric)  # Output: 29.99
    return amount_numeric


def get_row_data(file_path):
    with open(file_path, 'r') as file:
        reader = csv.reader(file)
        # Skip header row
        next(reader)
        # Fetch first row data
        row_data = next(reader)
        # Return data without quotes or brackets
        return [data.strip() for data in row_data]
