import requests
import threading
import time
import random


def work():
    while True:
        liczba = random.randint(5, 20) # 5-20 wartości ciągu Fibbonaciego - powiedziałbym, że to jest ruch normalny, a 20-45 to już wymusza większy effort CPU, do triggerowania ruchu anormalnego
        result = requests.get(f'http://web-elb-1975825463.us-east-1.elb.amazonaws.com/?fiboIdx={liczba}')
        if result.status_code == 200:
            print('sent successfully')
            time.sleep(random.randint(0.1, 10)) # czas oczekiwania
        else:
            print('pause')
            time.sleep(20)

for i in range(3):
    thread = threading.Thread(target=work)
    thread.start()