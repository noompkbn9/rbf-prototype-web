pipeline {
    agent { dockerfile { dir './' } }

    environment {
        WEB_APP_URL = "http://your-web-app-host:port" // Replace with your actual web app URL
        API_BASE_URL = "http://your-api-host:port/api" // Replace with your actual API base URL
        DB_HOST = "your-db-host" // Replace with your actual DB host
        DB_PORT = "your-db-port" // Replace with your actual DB port
        DB_USER = "your-db-user"
        DB_PASSWORD = "your-db-password"
        DB_NAME = "your-db-name"
        SELENIUM_GRID_URL = "http://selenium-hub:4444/wd/hub"
        ALLURE_RESULTS_DIR = "allure-results"
        // Grafana Cloud InfluxDB Configuration
        INFLUXDB_URL = "http://your-influxdb-url:8086" // e.g., https://us-east-2-1.aws.cloud2.influxdb.com
        INFLUXDB_TOKEN = "your-influxdb-token"
        INFLUXDB_ORG = "your-influxdb-org"
        INFLUXDB_BUCKET = "robotframework_metrics"
    }

    stages {
        stage("Build Docker Image") {
            steps {
                script {
                    sh "docker build -t automation-test-prototype-image ."
                }
            }
        }

        stage("Start Selenium Grid") {
            steps {
                script {
                    sh "docker-compose up -d"
                    sh """/usr/bin/python3 -c "
import requests
import time

url = 'http://localhost:4444/wd/hub/status'
for _ in range(30):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200 and response.json()['value']['ready']:
            print('Selenium Grid is ready!')
            break
    except requests.exceptions.ConnectionError:
        pass
    print('Waiting for Selenium Grid...')
    time.sleep(2)
else:
    print('Selenium Grid did not become ready in time.')
    exit(1)
"""
                }
            }
        }

        stage("Run Tests - Chrome") {
            steps {
                script {
                    sh """docker run --rm \
                        -e WEB_APP_URL=${WEB_APP_URL} \
                        -e API_BASE_URL=${API_BASE_URL} \
                        -e DB_HOST=${DB_HOST} \
                        -e DB_PORT=${DB_PORT} \
                        -e DB_USER=${DB_USER} \
                        -e DB_PASSWORD=${DB_PASSWORD} \
                        -e DB_NAME=${DB_NAME} \
                        -e SELENIUM_GRID_URL=${SELENIUM_GRID_URL} \
                        -e ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR} \
                        -e BROWSER=\"chrome\" \
                        -v "$(pwd)":/app \
                        automation-test-prototype-image \
                        robot --output chrome_output.xml --variable BROWSER:chrome --variable REMOTE_URL:${SELENIUM_GRID_URL} --listener allure_robotframework:${ALLURE_RESULTS_DIR} tests/web"""
                }
            }
        }

        stage("Run Tests - Firefox") {
            steps {
                script {
                    sh """docker run --rm \
                        -e WEB_APP_URL=${WEB_APP_URL} \
                        -e API_BASE_URL=${API_BASE_URL} \
                        -e DB_HOST=${DB_HOST} \
                        -e DB_PORT=${DB_PORT} \
                        -e DB_USER=${DB_USER} \
                        -e DB_PASSWORD=${DB_PASSWORD} \
                        -e DB_NAME=${DB_NAME} \
                        -e SELENIUM_GRID_URL=${SELENIUM_GRID_URL} \
                        -e ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR} \
                        -e BROWSER=\"firefox\" \
                        -v "$(pwd)":/app \
                        automation-test-prototype-image \
                        robot --output firefox_output.xml --variable BROWSER:firefox --variable REMOTE_URL:${SELENIUM_GRID_URL} --listener allure_robotframework:${ALLURE_RESULTS_DIR} tests/web"""
                }
            }
        }

        stage("Merge Test Results and Publish Metrics") {
            steps {
                script {
                    sh "rebot --merge chrome_output.xml firefox_output.xml --output output.xml"
                    sh "python3 utils/influxdb_publisher.py output.xml"
                }
            }
        }

        stage("Generate Allure Report") {
            steps {
                script {
                    sh "allure generate ${ALLURE_RESULTS_DIR} --clean -o allure-report"
                }
            }
        }

        stage("Cleanup") {
            steps {
                script {
                    sh "docker-compose down"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**/*', fingerprint: true
            publishHTML (target: [
                allowMissing: false,
                alwaysPublishFromReportDir: false,
                keepAll: true,
                reportDir: 'allure-report',
                reportFiles: 'index.html',
                reportName: 'Allure Report'
            ])
        }
    }
}

// To trigger this pipeline, configure SCM polling or webhooks in your Jenkins job settings.
// For example, to trigger on every push to the 'main' branch, set up a 'GitHub hook trigger for GITScm polling' or 'Poll SCM' with a schedule.


