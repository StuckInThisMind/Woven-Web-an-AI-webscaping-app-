from flask import Flask, request, jsonify
from flask_cors import CORS
import threading
import logging
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

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*", "allow_headers": ["Content-Type"]}})

# Global dictionary to store search results
search_results = {
    'google': [],
    'bing': [],
    'yahoo': [],
    'brave': [],
    'duckduckgo': [],
    'common': [],
    'unique': []
}

# Lock for thread-safe operations
results_lock = threading.Lock()

# Chrome options with additional error handling
options = Options()
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-gpu")
options.add_argument("--window-size=1920,1080")
options.add_argument("--disable-extensions")
options.add_argument("--proxy-server='direct://'")
options.add_argument("--proxy-bypass-list=*")
options.add_argument("--start-maximized")

try:
    service = Service(ChromeDriverManager().install())
except Exception as e:
    logger.error(f"Failed to initialize ChromeDriver: {e}")
    raise

search_engines = {
    'Google': 'https://www.google.com',
    'Yahoo': 'https://search.yahoo.com',
    'Bing': 'https://www.bing.com',
    'Brave': 'https://search.brave.com',
    'DuckDuckGo': 'https://www.duckduckgo.com'
}

def get_search_results(engine_name, search_url, search_query):
    logger.info(f"Starting search for {engine_name} with query: {search_query}")
    driver = None
    try:
        driver = webdriver.Chrome(service=service, options=options)
        driver.get(search_url)
        logger.info(f"Successfully loaded {search_url}")

        if engine_name == 'DuckDuckGo':
            search_box = driver.find_element(By.NAME, 'q')
            search_box.send_keys(search_query)
            search_box.send_keys(Keys.RETURN)
            time.sleep(3)
            soup = BeautifulSoup(driver.page_source, 'html.parser')
            results = soup.find_all('a', {'data-testid': 'result-title-a'})
            urls = {result['href'] for result in results[:5]}
            logger.info(f"Found {len(urls)} results for DuckDuckGo")
            return urls

        elif engine_name == 'Brave':
            search_box = driver.find_element(By.NAME, 'q')
            search_box.send_keys(search_query)
            search_box.send_keys(Keys.RETURN)
            time.sleep(2)
            soup = BeautifulSoup(driver.page_source, 'html.parser')
            snippets = soup.find_all('div', class_='snippet svelte-umc06')
            urls = {snippet.find('a')['href'] for snippet in snippets if snippet.find('a')}
            logger.info(f"Found {len(urls)} results for Brave")
            return urls

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

            logger.info(f"Found {len(urls)} results for {engine_name}")
            return urls

    except Exception as e:
        logger.error(f"Error in {engine_name} search: {str(e)}")
        return set()
    finally:
        if driver:
            try:
                driver.quit()
            except Exception as e:
                logger.error(f"Error closing driver: {str(e)}")

def extract_text(url):
    try:
        response = requests.get(url, timeout=5)
        soup = BeautifulSoup(response.text, 'html.parser')
        paragraphs = soup.find_all('p')
        text = ' '.join(paragraph.text for paragraph in paragraphs)
        return text[:1000]
    except Exception as e:
        logger.error(f"Error extracting text from {url}: {str(e)}")
        return ""

def perform_search(search_query):
    logger.info(f"Starting search process for query: {search_query}")
    all_results = {}
    
    with results_lock:
        for key in search_results:
            search_results[key] = []
    
    try:
        for engine_name, search_url in search_engines.items():
            logger.info(f"Processing {engine_name}")
            urls = get_search_results(engine_name, search_url, search_query)
            all_results[engine_name] = urls

            for url in urls:
                extracted_text = extract_text(url)
                with results_lock:
                    if engine_name == 'Google':
                        search_results['google'].append(extracted_text)
                    elif engine_name == 'Bing':
                        search_results['bing'].append(extracted_text)
                    elif engine_name == 'Yahoo':
                        search_results['yahoo'].append(extracted_text)
                    elif engine_name == 'Brave':
                        search_results['brave'].append(extracted_text)
                    elif engine_name == 'DuckDuckGo':
                        search_results['duckduckgo'].append(extracted_text)

        all_urls = [url for urls in all_results.values() for url in urls]
        url_counts = Counter(all_urls)
        common_links = [url for url, count in url_counts.items() if count > 1]
        unique_links = [url for url, count in url_counts.items() if count == 1]

        with results_lock:
            for link in common_links:
                extracted_text = extract_text(link)
                search_results['common'].append(extracted_text)

            for link in unique_links:
                extracted_text = extract_text(link)
                search_results['unique'].append(extracted_text)
        
        logger.info("Search completed successfully")
        return True
    except Exception as e:
        logger.error(f"Error in perform_search: {str(e)}")
        return False

@app.route('/search', methods=['POST'])
def search():
    try:
        data = request.get_json()
        if not data or 'query' not in data:
            logger.error("No query provided in request")
            return jsonify({'error': 'No query provided'}), 400

        search_query = data['query']
        logger.info(f"Received search request for query: {search_query}")
        
        # Start search in a separate thread
        thread = threading.Thread(target=perform_search, args=(search_query,))
        thread.start()
        
        return jsonify({'message': 'Search initiated', 'status': 'processing'})
    except Exception as e:
        logger.error(f"Error in search endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/results/<engine>', methods=['GET'])
def get_results(engine):
    try:
        if engine not in search_results:
            return jsonify({'error': 'Invalid engine specified'}), 400

        with results_lock:
            return jsonify({
                'engine': engine,
                'results': search_results[engine]
            })
    except Exception as e:
        logger.error(f"Error in get_results endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/status', methods=['GET'])
def get_status():
    try:
        with results_lock:
            has_results = any(len(results) > 0 for results in search_results.values())
            status_info = {
                'status': 'complete' if has_results else 'processing',
                'available_engines': [engine for engine, results in search_results.items() if results],
                'result_counts': {engine: len(results) for engine, results in search_results.items()}
            }
            logger.info(f"Status check: {status_info}")
            return jsonify(status_info)
    except Exception as e:
        logger.error(f"Error in status endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

# if __name__ == '__main__':
#     logger.info("Server starting on http://localhost:5000")
#     app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)


if __name__ == '__main__':
    print("Server starting...")
    # Only bind to localhost - this is more secure and prevents multiple bindings
    app.run(host='127.0.0.1', port=5000, debug=True, threaded=True)