from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import requests
import time
from collections import Counter
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

options = Options()
options.add_argument("--headless")  # Run headless, if desired
service = Service(ChromeDriverManager().install()) 

# Initialize ChromeDriver
search_engines = {
    'Google': 'https://www.google.com',
    'Yahoo': 'https://search.yahoo.com',
    'Bing': 'https://www.bing.com',
    'Brave': 'https://search.brave.com',
    'DuckDuckGo': 'https://www.duckduckgo.com'
}

# Lists to store extracted texts
googlelst, binglst, yahoolst, bravelst, duckducklst = [], [], [], [], []
commonlst, uniquelst = [], []

def get_search_results(engine_name, search_url, search_query):
    driver = webdriver.Chrome(service=service, options=options)
    driver.get(search_url)
    
    try:
        # DuckDuckGo-specific scraping logic
        if engine_name == 'DuckDuckGo':
            search_box = driver.find_element(By.NAME, 'q')
            search_box.send_keys(search_query)
            search_box.send_keys(Keys.RETURN)
            time.sleep(3)
            soup = BeautifulSoup(driver.page_source, 'html.parser')
            results = soup.find_all('a', {'data-testid': 'result-title-a'})
            urls = {result['href'] for result in results[:5]}
            return urls

        # Brave-specific scraping logic
        elif engine_name == 'Brave':
            search_box = driver.find_element(By.NAME, 'q')
            search_box.send_keys(search_query)
            search_box.send_keys(Keys.RETURN)
            time.sleep(2)
            soup = BeautifulSoup(driver.page_source, 'html.parser')
            snippets = soup.find_all('div', class_='snippet svelte-umc06')
            urls = {snippet.find('a')['href'] for snippet in snippets if snippet.find('a')}
            return urls

        # Other search engines (Google, Yahoo, Bing)
        else:
            search_box = WebDriverWait(driver, 20).until(
                EC.presence_of_element_located((By.NAME, 'q' if engine_name != 'Yahoo' else 'p'))
            )
            search_box.send_keys(search_query)
            search_box.send_keys(Keys.RETURN)
            time.sleep(2)
            soup = BeautifulSoup(driver.page_source, 'html.parser')

            urls = set()
            if engine_name == 'Google':
                results = soup.find_all('div', class_='g')
                urls = {result.find('a')['href'] for result in results[:5] if result.find('a')}
            elif engine_name == 'Yahoo':
                results = soup.find_all('h3', class_='title')
                urls = {result.find('a')['href'] for result in results[:5] if result.find('a')}
            elif engine_name == 'Bing':
                results = soup.find_all('li', class_='b_algo')
                urls = {result.find('a')['href'] for result in results[:5] if result.find('a')}

            return urls

    except Exception as e:
        print(f"Error scraping {engine_name}: {e}")
        return set()

    finally:
        driver.quit()

# Function to extract text from a URL
def extract_text(url):
    try:
        response = requests.get(url, timeout=5)
        soup = BeautifulSoup(response.text, 'html.parser')
        paragraphs = soup.find_all('p')
        text = ' '.join(paragraph.text for paragraph in paragraphs)
        return text[:1000]  # Limit to first 1000 characters
    except Exception as e:
        print(f"Error extracting text from {url}: {e}")
        return ""

# Main function
def main():
    search_query = "AI trends latest by 28/Oct"
    all_results = {}

    # Get URLs from each search engine
    for engine_name, search_url in search_engines.items():
        print(f"Searching on {engine_name}...")
        urls = get_search_results(engine_name, search_url, search_query)
        all_results[engine_name] = urls
        print(f"Top URLs from {engine_name}:")

        # Loop through all scraped URLs for this search engine
        for url in urls:
            print(url)
            # Extract text for each URL
            extracted_text = extract_text(url)
            print("Extracted text:", extracted_text[:200], "...")  # Show first 200 characters for brevity
            print("-" * 50)
            
            # Append the text to the corresponding list
            if engine_name == 'Google':
                googlelst.append(extracted_text)
            elif engine_name == 'Bing':
                binglst.append(extracted_text)
            elif engine_name == 'Yahoo':
                yahoolst.append(extracted_text)
            elif engine_name == 'Brave':
                bravelst.append(extracted_text)
            elif engine_name == 'DuckDuckGo':
                duckducklst.append(extracted_text)

    # Identify common and unique links
    all_urls = [url for urls in all_results.values() for url in urls]
    url_counts = Counter(all_urls)
    common_links = [url for url, count in url_counts.items() if count > 1]
    unique_links = [url for url, count in url_counts.items() if count == 1]

    # Extract text for common and unique links
    for link in common_links:
        extracted_text = extract_text(link)
        commonlst.append(extracted_text)

    for link in unique_links:
        extracted_text = extract_text(link)
        uniquelst.append(extracted_text)

    print("\nData stored in respective lists for each search engine and unique/common links:")
    print("Google list:", googlelst[:2])  # Displaying first 2 for brevity
    print("Bing list:", binglst[:2])
    print("Yahoo list:", yahoolst[:2])
    print("Brave list:", bravelst[:2])
    print("DuckDuckGo list:", duckducklst[:2])
    print("Common links list:", commonlst[:2])
    print("Unique links list:", uniquelst[:2])

if __name__ == "__main__":
    main()
