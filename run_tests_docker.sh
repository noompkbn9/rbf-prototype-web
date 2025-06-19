#!/bin/bash

# Get current timestamp for results folder
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
RESULTS_DIR="./results/${TIMESTAMP}"
mkdir -p ${RESULTS_DIR}

# Set environment variables for Dockerized execution
export WEB_APP_URL="http://your-web-app-host:port" # Replace with your actual web app URL
export API_BASE_URL="http://your-api-host:port/api" # Replace with your actual API base URL
export DB_HOST="your-db-host" # Replace with your actual DB host
export DB_PORT="your-db-port" # Replace with your actual DB port
export DB_USER="your-db-user"
export DB_PASSWORD="your-db-password"
export DB_NAME="your-db-name"
export SELENIUM_GRID_URL="http://selenium-hub:4444/wd/hub"
export ALLURE_RESULTS_DIR="${RESULTS_DIR}/allure-results"

# InfluxDB Configuration (ensure these are set in your CI/CD environment or locally)
export INFLUXDB_URL="http://your-influxdb-url:8086" # e.g., http://localhost:8086 or your Grafana Cloud InfluxDB URL
export INFLUXDB_TOKEN="your-influxdb-token"
export INFLUXDB_ORG="your-influxdb-org"
export INFLUXDB_BUCKET="robotframework_metrics"

# Start Selenium Grid
docker-compose up -d

# Wait for Selenium Grid to be ready
echo "Waiting for Selenium Grid to be ready..."
/usr/bin/python3 -c "
import requests
import time

url = 'http://localhost:4444/wd/hub/status'
for _ in range(30):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200 and response.json()["value"]["ready"]:
            print("Selenium Grid is ready!")
            break
    except requests.exceptions.ConnectionError:
        pass
    print("Waiting for Selenium Grid...")
    time.sleep(2)
else:
    print("Selenium Grid did not become ready in time.")
    exit(1)
"

# Define output XML path for Robot Framework
OUTPUT_XML_PATH="${RESULTS_DIR}/output.xml"

# Run tests with Chrome and Firefox, combining output to a single XML
echo "Running tests on Chrome and Firefox..."
docker run --rm \
    -e WEB_APP_URL=${WEB_APP_URL} \
    -e API_BASE_URL=${API_BASE_URL} \
    -e DB_HOST=${DB_HOST} \
    -e DB_PORT=${DB_PORT} \
    -e DB_USER=${DB_USER} \
    -e DB_PASSWORD=${DB_PASSWORD} \
    -e SELENIUM_GRID_URL=${SELENIUM_GRID_URL} \
    -e ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR} \
    -e BROWSER="chrome" \
    -v "$(pwd)":/app \
    automation-test-prototype-image \
    robot --output ${RESULTS_DIR}/chrome_output.xml --variable BROWSER:chrome --variable REMOTE_URL:${SELENIUM_GRID_URL} --listener allure_robotframework:${ALLURE_RESULTS_DIR} tests/web

docker run --rm \
    -e WEB_APP_URL=${WEB_APP_URL} \
    -e API_BASE_URL=${API_BASE_URL} \
    -e DB_HOST=${DB_HOST} \
    -e DB_PORT=${DB_PORT} \
    -e DB_USER=${DB_USER} \
    -e DB_PASSWORD=${DB_PASSWORD} \
    -e SELENIUM_GRID_URL=${SELENIUM_GRID_URL} \
    -e ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR} \
    -e BROWSER="firefox" \
    -v "$(pwd)":/app \
    automation-test-prototype-image \
    robot --output ${RESULTS_DIR}/firefox_output.xml --variable BROWSER:firefox --variable REMOTE_URL:${SELENIUM_GRID_URL} --listener allure_robotframework:${ALLURE_RESULTS_DIR} tests/web

# Merge Robot Framework output XMLs
rebot --merge ${RESULTS_DIR}/chrome_output.xml ${RESULTS_DIR}/firefox_output.xml --output ${OUTPUT_XML_PATH}

# Stop Selenium Grid
docker-compose down

# Generate Allure Report
echo "Generating Allure Report..."
allure generate ${ALLURE_RESULTS_DIR} -o ${RESULTS_DIR}/allure-report --clean

# Publish metrics to InfluxDB
echo "Publishing test metrics to InfluxDB..."
python3 utils/influxdb_publisher.py ${OUTPUT_XML_PATH}



