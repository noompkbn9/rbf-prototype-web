
import os

# Web Application URL
WEB_APP_URL = os.getenv('WEB_APP_URL', 'http://localhost:8080')

# Database Connection Details
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '3306')
DB_USER = os.getenv('DB_USER', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
DB_NAME = os.getenv('DB_NAME', 'test_db')

# API Base URL
API_BASE_URL = os.getenv('API_BASE_URL', 'http://localhost:5000/api')

# Browser for local execution (e.g., chrome, firefox)
BROWSER = os.getenv('BROWSER', 'chrome')

# Selenium Grid URL (for Dockerized execution)
SELENIUM_GRID_URL = os.getenv('SELENIUM_GRID_URL', 'http://localhost:4444/wd/hub')

# Allure Report Output Directory
ALLURE_RESULTS_DIR = os.getenv('ALLURE_RESULTS_DIR', 'results')


