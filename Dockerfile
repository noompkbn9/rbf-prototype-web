FROM python:3.9-slim-buster

WORKDIR /app

# Install system dependencies for browsers
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    libglib2.0-0 \
    libnss3 \
    libxcomposite1 \
    libxrandr2 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libxkbcommon0 \
    libxshmfence6 \
    libxss1 \
    libxtst6 \
    fonts-liberation \
    xxd \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Install Firefox
RUN wget -q -O - https://packages.mozilla.org/apt/repo-signing-key.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://packages.mozilla.org/apt stable main" >> /etc/apt/sources.list.d/mozilla.list
RUN apt-get update && apt-get install -y firefox

# Install Chrome Driver
ARG CHROME_DRIVER_VERSION="125.0.6422.141"
RUN wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_DRIVER_VERSION}/linux64/chromedriver-linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver.zip /usr/local/bin/chromedriver-linux64 && \
    chmod +x /usr/local/bin/chromedriver

# Install Gecko Driver (Firefox Driver)
ARG GECKO_DRIVER_VERSION="0.34.0"
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/v${GECKO_DRIVER_VERSION}/geckodriver-v${GECKO_DRIVER_VERSION}-linux64.tar.gz" -O /tmp/geckodriver.tar.gz && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin/ && \
    rm -rf /tmp/geckodriver.tar.gz && \
    chmod +x /usr/local/bin/geckodriver

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["robot", "--version"]


