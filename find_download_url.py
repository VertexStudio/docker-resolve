#!/usr/bin/env python3

"Search the actual Resolve for Linux Download URL"

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import logging, random, os

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--window-size=1920x1080")
chrome_options.add_argument('--no-sandbox')

driver = webdriver.Chrome(chrome_options=chrome_options)

driver.get('https://www.blackmagicdesign.com/products/davinciresolve/')

driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
b = driver.find_element_by_link_text('Download Now')
b.click()

wait = WebDriverWait(driver, 10)
element = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, 'Linux')))
b = driver.find_element_by_link_text('Linux')
b.click()

wait = WebDriverWait(driver, 10)
element = wait.until(EC.element_to_be_clickable((By.ID, 'firstname')))
f = driver.find_element_by_id('firstname')
f.send_keys("Dziga")
f = driver.find_element_by_id('lastname')
f.send_keys("Vertov")
f = driver.find_element_by_id('company')
f.send_keys("ЛЕФ (Left Front of the Arts)")
f = driver.find_element_by_id('email')
f.send_keys("spam@kino-pravda.org")
f = driver.find_element_by_id('phone')
f.send_keys(random.randrange(9999999999999999))
f = driver.find_element_by_id('country')
f.send_keys("Russia")
f = driver.find_element_by_id('city')
f.send_keys("Moscow")

b = driver.find_element_by_link_text('Register & Download')
b.click()

wait = WebDriverWait(driver, 10)
element = wait.until(EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, 'Linux.zip')))
b = driver.find_element_by_partial_link_text('Linux.zip')
href = b.get_attribute('href')

driver.close()

print(href)