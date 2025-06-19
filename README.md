```

## 🛠️ Prerequisites

- Python 3.9+
- Docker and Docker Compose
- Jenkins (for CI/CD)
- Allure CLI (for report generation)

## 📦 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd automation-test-prototype
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Install Allure CLI

```bash
# On macOS
brew install allure

# On Ubuntu/Debian
sudo apt-get install allure

# Or download from https://github.com/allure-framework/allure2/releases
```

### 4. Build Docker Image

```bash
docker build -t automation-test-prototype-image .
```

## 🚀 Usage

### Running Tests Locally

#### Basic Robot Framework Execution

```bash
# Run all web tests
robot tests/web/

# Run specific test suite
robot tests/web/login_test.robot

# Run with custom variables
robot --variable BROWSER:firefox --variable WEB_APP_URL:http://localhost:8080 tests/web/
```

#### Using Docker (Recommended)

```bash
# Make script executable
chmod +x run_tests_docker.sh

# Update environment variables in the script
# Then run:
./run_tests_docker.sh
```

### Environment Configuration

Update `config.py` or set environment variables:

```bash
export WEB_APP_URL="http://your-app-url"
export API_BASE_URL="http://your-api-url/api"
export DB_HOST="your-db-host"
export DB_PORT="3306"
export DB_USER="your-db-user"
export DB_PASSWORD="your-db-password"
export DB_NAME="your-db-name"
```

### Viewing Test Reports

#### Allure Reports

```bash
# Generate and open Allure report
allure generate results/YYYY-MM-DD_HHMMSS/allure-results -o allure-report --clean
allure open allure-report
```

## 🔧 Jenkins CI/CD Setup

### 1. Create Jenkins Pipeline Job

1. Create a new Pipeline job in Jenkins
2. Configure SCM to point to your repository
3. Set Pipeline script from SCM
4. Configure build triggers (e.g., webhook, polling)

### 2. Required Jenkins Plugins

- Docker Pipeline
- Allure Plugin
- HTML Publisher Plugin

### 3. Environment Variables in Jenkins

Configure the following environment variables in Jenkins:

- `WEB_APP_URL`
- `API_BASE_URL`
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`

## 🏗️ Architecture

### Test Framework Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Test Suites   │    │  Page Objects   │    │ Python Utils    │
│                 │    │                 │    │                 │
│ • Web Tests     │────│ • Login Page    │────│ • DB Utils      │
│ • API Tests     │    │ • Home Page     │    │ • API Utils     │
│ • DB Tests      │    │ • Common KWs    │    │ • Custom KWs    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Robot Framework │
                    │    Executor     │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Selenium Grid   │    │ Allure Reports  │    │   Grafana       │
│                 │    │                 │    │                 │
│ • Chrome Node   │    │ • Test Results  │    │ • Metrics View  │
│ • Firefox Node  │    │ • Screenshots   │    │ • Trends        │
│ • Hub           │    │ • Logs          │    │ • Analytics     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### CI/CD Pipeline Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Code      │    │   Build     │    │    Test     │    │   Report    │
│   Commit    │───▶│   Docker    │───▶│  Execution  │───▶│ Generation  │
│             │    │   Image     │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                               │
                                    ┌─────────────┐
                                    │  Selenium   │
                                    │    Grid     │
                                    │   Startup   │
                                    └─────────────┘
```

## 🧪 Test Development Guidelines

### Writing Test Cases

1. **Follow Robot Framework Style Guide**
   - Use clear, descriptive test names
   - Implement proper spacing and indentation
   - Add meaningful documentation

2. **Page Object Model**
   - Create separate resource files for each page
   - Define locators as variables
   - Implement reusable keywords

3. **Test Data Management**
   - Use external data files when appropriate
   - Implement data-driven testing for multiple scenarios
   - Keep test data separate from test logic

### Best Practices

- **Maintainability**: Use Page Object Model and keyword-driven approach
- **Reliability**: Implement proper waits and error handling
- **Scalability**: Design tests for parallel execution
- **Reporting**: Add appropriate tags and documentation for better reporting

## 🔍 Troubleshooting

### Common Issues

#### Docker Issues

```bash
# Check if Docker is running
docker --version
docker-compose --version

# Rebuild image if needed
docker build --no-cache -t automation-test-prototype-image .
```

#### Selenium Grid Issues

```bash
# Check Selenium Grid status
curl http://localhost:4444/wd/hub/status

# Restart Selenium Grid
docker-compose down
docker-compose up -d
```

#### Test Execution Issues

```bash
# Check Python dependencies
pip list | grep robot

# Verify environment variables
echo $WEB_APP_URL
echo $API_BASE_URL
```

### Debugging Tests

1. **Enable Debug Logging**
   ```bash
   robot --loglevel DEBUG tests/
   ```

2. **Take Screenshots on Failure**
   - Screenshots are automatically captured in web tests
   - Check `results/` folder for failure screenshots

3. **Use Browser Developer Tools**
   - Inspect elements for correct locators
   - Check network requests for API tests

## 📈 Performance Considerations

### Test Execution Optimization

- **Parallel Execution**: Use `pabot` for parallel test execution
- **Browser Management**: Reuse browser sessions when possible
- **Resource Cleanup**: Properly close browsers and database connections
- **Test Data**: Use lightweight test data sets

### Infrastructure Scaling

- **Selenium Grid**: Add more nodes for increased parallel capacity
- **Jenkins Agents**: Use multiple agents for distributed builds
- **Resource Monitoring**: Monitor CPU, memory, and network usage

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Robot Framework style guide
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Robot Framework community for excellent documentation
- Selenium project for web automation capabilities
- Allure Framework for beautiful test reporting
- Docker for containerization support

## 📞 Support

For questions and support:

- Create an issue in the repository
- Check the [Robot Framework documentation](https://robotframework.org/robotframework/)
- Review [Selenium documentation](https://selenium-python.readthedocs.io/)
- Consult [Allure documentation](https://docs.qameta.io/allure/)

---

**Happy Testing! 🚀**

