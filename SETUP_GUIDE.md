# Step-by-Step Setup Guide for Automation Test Prototype

This guide provides detailed, step-by-step instructions to set up and run the automation test prototype project. Each section covers a specific module, ensuring you can get the project up and running smoothly.

## 1. Project Setup and Dependencies

### 1.1 Clone the Repository

First, clone the project repository to your local machine:

```bash
git clone <repository-url> # Replace with your actual repository URL
cd automation-test-prototype
```

### 1.2 Install Python Dependencies

Ensure you have Python 3.9+ installed. Then, install the required Python libraries:

```bash
pip install -r requirements.txt
```

### 1.3 Install Allure CLI

Allure Commandline Interface is required to generate and view Allure reports. Choose the installation method appropriate for your operating system:

**On macOS (using Homebrew):**

```bash
brew install allure
```

**On Ubuntu/Debian:**

```bash
sudo apt-get update
sudo apt-get install allure
```

**Manual Download (for other OS or if above fails):**

Download the latest Allure CLI from the [Allure GitHub Releases page](https://github.com/allure-framework/allure2/releases). Extract the archive and add the `bin` directory to your system's PATH.

### 1.4 Install Docker and Docker Compose

Docker and Docker Compose are essential for running tests in containerized environments and managing the Selenium Grid. Follow the official Docker documentation for installation:

- [Install Docker Engine](https://docs.docker.com/engine/install/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

## 2. Environment Configuration

Before running tests, you need to configure environment variables for your web application, API, and database. These can be set directly in your shell or managed via `config.py`.

### 2.1 Update `config.py` (Recommended for local development)

Open `config.py` in the project root and update the placeholder values with your actual application and database details:

```python
# config.py

import os

# Web Application URL
WEB_APP_URL = os.getenv("WEB_APP_URL", "http://localhost:8080")

# API Base URL
API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:5000/api")

# Database Configuration
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_NAME = os.getenv("DB_NAME", "test_db")

# InfluxDB Configuration for Grafana Cloud
INFLUXDB_URL = os.getenv("INFLUXDB_URL", "http://localhost:8086") # Replace with your Grafana Cloud InfluxDB URL
INFLUXDB_TOKEN = os.getenv("INFLUXDB_TOKEN", "your-influxdb-token") # Replace with your Grafana Cloud InfluxDB Token
INFLUXDB_ORG = os.getenv("INFLUXDB_ORG", "your-influxdb-org") # Replace with your Grafana Cloud Organization
INFLUXDB_BUCKET = os.getenv("INFLUXDB_BUCKET", "robotframework_metrics") # Replace with your InfluxDB Bucket
```

### 2.2 Set Environment Variables (Recommended for CI/CD)

For CI/CD environments like Jenkins, it's best practice to set these as global environment variables or within the pipeline configuration. Example for shell:

```bash
export WEB_APP_URL="http://your-app-url"
export API_BASE_URL="http://your-api-url/api"
export DB_HOST="your-db-host"
export DB_PORT="3306"
export DB_USER="your-db-user"
export DB_PASSWORD="your-db-password"
export DB_NAME="your-db-name"

# For Grafana Cloud InfluxDB
export INFLUXDB_URL="https://us-east-2-1.aws.cloud2.influxdb.com" # Example URL
export INFLUXDB_TOKEN="your-grafana-cloud-influxdb-token"
export INFLUXDB_ORG="your-grafana-cloud-org"
export INFLUXDB_BUCKET="robotframework_metrics"
```

## 3. Running Tests

Tests can be run locally using Robot Framework directly or, preferably, via Docker for cross-browser testing.

### 3.1 Build Docker Image

Navigate to the project root and build the Docker image for the test environment:

```bash
docker build -t automation-test-prototype-image .
```

### 3.2 Run Tests via Docker (Recommended)

The `run_tests_docker.sh` script automates the process of starting Selenium Grid, running tests on Chrome and Firefox, generating Allure reports, and publishing metrics to InfluxDB.

1. Make the script executable:

   ```bash
   chmod +x run_tests_docker.sh
   ```

2. Run the script:

   ```bash
   ./run_tests_docker.sh
   ```

   This script will:
   - Create a timestamped results directory.
   - Start Selenium Grid using `docker-compose`.
   - Run web tests on Chrome and Firefox containers.
   - Merge test results.
   - Stop Selenium Grid.
   - Generate Allure reports in the timestamped results directory.
   - Publish test metrics (pass/fail status, duration) to your configured InfluxDB.

### 3.3 Running Tests Locally (Without Docker for browsers)

If you prefer to run tests directly on your local machine (without Dockerized browsers), ensure you have the necessary browser drivers (e.g., ChromeDriver, GeckoDriver) installed and configured in your system PATH.

```bash
# Example: Run all web tests with Chrome
robot --variable BROWSER:chrome tests/web/

# Example: Run a specific test suite
robot tests/web/login_test.robot
```

## 4. Viewing Test Reports

### 4.1 Allure Reports

After tests complete, Allure reports are generated in a timestamped folder within the `results/` directory (e.g., `results/YYYY-MM-DD_HHMMSS/allure-report`).

To view the Allure report, navigate to the generated report directory and open `index.html` in your browser, or use the Allure CLI:

```bash
# Example: Navigate to a specific report directory
cd results/2025-06-19_123456/allure-report # Replace with your timestamped folder

# Open index.html in your browser
# (e.g., open index.html on macOS, start index.html on Windows)

# Or use Allure CLI to serve the report (recommended for local viewing)
allure serve results/2025-06-19_123456/allure-results # Replace with your timestamped allure-results folder
```

## 5. Jenkins CI/CD Setup

This project includes a `Jenkinsfile` to define a CI/CD pipeline. Follow these steps to set it up in Jenkins:

### 5.1 Prerequisites in Jenkins

Ensure the following Jenkins plugins are installed:

- **Docker Pipeline**: For interacting with Docker from Jenkins pipelines.
- **Allure Plugin**: For publishing Allure reports in Jenkins.
- **HTML Publisher Plugin**: For publishing HTML reports (like Allure).

### 5.2 Create a Jenkins Pipeline Job

1. Log in to your Jenkins instance.
2. Click **New Item** on the Jenkins dashboard.
3. Enter an item name (e.g., `automation-test-pipeline`) and select **Pipeline**. Click **OK**.
4. In the job configuration page:
   - Under **General**, provide a description.
   - Under **Build Triggers**, configure how you want to trigger the pipeline (e.g., `Poll SCM` for periodic checks, `GitHub hook trigger for GITScm polling` for webhook integration).
   - Under **Pipeline**, select `Pipeline script from SCM`.
   - **SCM**: Select `Git`.
   - **Repository URL**: Enter your project's Git repository URL.
   - **Credentials**: Add appropriate credentials if your repository is private.
   - **Branches to build**: Specify the branch (e.g., `main`).
   - **Script Path**: Enter `Jenkinsfile` (this is the default).
5. Click **Save**.

### 5.3 Configure Environment Variables in Jenkins

For the Jenkins pipeline to run correctly, you need to configure the environment variables for your application, database, and Grafana Cloud InfluxDB. These should be set as **Global properties** under **Manage Jenkins** > **Configure System** > **Global properties** > **Environment variables**, or directly within your pipeline script (though global is often preferred for sensitive data).

Example variables to set:

- `WEB_APP_URL`
- `API_BASE_URL`
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `INFLUXDB_URL`
- `INFLUXDB_TOKEN`
- `INFLUXDB_ORG`
- `INFLUXDB_BUCKET`

**Note on `INFLUXDB_TOKEN`**: For security, consider using Jenkins Credentials Binding to inject this sensitive token into your pipeline securely.

## 6. Grafana Cloud Setup for Test Metrics

This section details how to configure Grafana Cloud to receive and visualize your test automation metrics.

### 6.1 Sign Up for Grafana Cloud

If you don't already have a Grafana Cloud account, sign up for a free tier or a suitable plan at [Grafana Cloud](https://grafana.com/products/cloud/).

### 6.2 Create an InfluxDB Data Source

Once logged in to your Grafana Cloud account:

1. Navigate to **Connections** > **Data sources**.
2. Click **Add new data source**.
3. Search for and select **InfluxDB**.
4. Configure the InfluxDB data source with the following details:
   - **Query Language**: Flux
   - **URL**: This will be provided by Grafana Cloud (e.g., `https://us-east-2-1.aws.cloud2.influxdb.com`). You can find this in your InfluxDB details under **Connections** > **InfluxDB**.
   - **Token**: Generate an API token with `read` and `write` permissions for your bucket. Go to **Security** > **API Keys** in Grafana Cloud, click **Add API Key**, give it a name, and select the appropriate permissions.
   - **Organization**: Your Grafana Cloud organization name (e.g., `your-org-name`).
   - **Bucket**: The name of your InfluxDB bucket (e.g., `robotframework_metrics`).
   - **Min time interval**: `1s` (or as appropriate for your data granularity).
5. Click **Save & test** to ensure the connection is successful.

### 6.3 Create a Grafana Dashboard

Now that your InfluxDB data source is configured, you can create a dashboard to visualize your test metrics:

1. Navigate to **Dashboards** > **New dashboard**.
2. Click **Add new panel**.
3. In the **Query** tab, select your InfluxDB data source.
4. Write Flux queries to retrieve your test data. Here are some example queries (as provided in `docs/grafana_setup.md`):

   - **Total Test Runs Over Time**
   - **Test Status (Passed/Failed) Over Time**
   - **Average Test Duration by Test Name**
   - **Pass Rate Percentage**

   Refer to `docs/grafana_setup.md` for the exact Flux query examples.

5. Customize your panels (e.g., visualization type, title, legend, units).
6. Save your dashboard.

This completes the step-by-step setup for the automation test prototype project. You can now run your tests, view Allure reports, and monitor your test metrics in Grafana Cloud.

