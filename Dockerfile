FROM yoh300/magento:latest

MAINTAINER "Watchara Chiamchit" <watchara.chiamchit@stream.co.th>

LABEL name="Docker image for the Robot Framework http://robotframework.org/"
LABEL usage="docker run -e ROBOT_TESTS=/path/to/tests/ --rm -v $(pwd)/path/to/tests/:/path/to/tests/ -ti robot-docker"

ENV TIMEZONE Asia/Bangkok

# Install Python Pip and the Robot framework
RUN apt-get update && \
    apt-get install -y python-pip xvfb unzip udev libgconf2-4 chromium-browser firefox=28.0+build2-0ubuntu2 xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    pip install --upgrade pip && \
    pip install robotframework robotframework-selenium2library selenium==2.53.6 robotframework-xvfb && \
    python --version
RUN wget -N https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/share/ && \
    rm chromedriver_linux64.zip && \
    chmod +x /usr/local/share/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
RUN a2enmod headers
CMD ["run.sh"]
