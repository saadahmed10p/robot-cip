import string
import re
import requests
import random
import csv
from bs4 import BeautifulSoup
import requests
from faker import Faker
from lorem_text import lorem


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


def milestone_desc():
    text = lorem.paragraphs(1, 1)
    print(text)
    return text


def get_random_string():
    # choose from all lowercase letter
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(30))
    # print("Random string of length", length, "is:", result_str)
    return result_str


# def get_input_value(url, name):
#     page = requests.get(url, timeout=5)
#     soup = BeautifulSoup(page.text, 'html.parser')
#     input_tag = soup.find('input', {'name': name})
#     return input_tag['value'] if input_tag else None

def get_token_value(url):
    page = requests.get(url, timeout=5)
    soup = BeautifulSoup(page.text, 'html.parser')
    token_input = soup.find('input', {'name': '__RequestVerificationToken'})
    token_value = token_input['value']
    print('Verification Token:', token_value)
    return token_value


def send_post_request(url, data):
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
    }
    response = requests.post(url, headers=headers, data=data)
    print(response.text)
    return response
