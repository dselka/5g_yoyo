import requests
import threading
import time
import random


def work():
    while True:
        liczba = 37
        result = requests.get(f'http://web-elb-1975825463.us-east-1.elb.amazonaws.com/?fiboIdx={liczba}')
        if result.status_code == 200:
            print('sent successfully')
            time.sleep(random.randint(5, 45))
        else:
            print('pause')
            time.sleep(20)

for i in range(3):
    thread = threading.Thread(target=work)
    thread.start()