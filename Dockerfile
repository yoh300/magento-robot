FROM yoh300/magento:latest

MAINTAINER "Watchara Chiamchit" <watchara.chiamchit@stream.co.th>

LABEL name="Docker image for the Robot Framework http://robotframework.org/"
LABEL usage="docker run -e ROBOT_TESTS=/path/to/tests/ --rm -v $(pwd)/path/to/tests/:/path/to/tests/ -ti robot-docker"

ENV TIMEZONE Asia/Bangkok

# Install Python Pip and the Robot framework
RUN apt-get update && \
    apt-get install -y python-pip xvfb unzip udev libgconf2-4 chromium-browser firefox=28.0+build2-0ubuntu2 xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
RUN pip install --upgrade pip && \
    pip install robotframework robotframework-selenium2library selenium==2.53.6 robotframework-xvfb
RUN pip install openpyxl Pillow pydrive
RUN git clone http://watcharac:passw0rd@code.stream.co.th/ecommerce/robot2docs.git /robot2docs
RUN python --version
RUN wget -N https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/share/ && \
    rm chromedriver_linux64.zip && \
    chmod +x /usr/local/share/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
RUN a2enmod headers
RUN apt-get install -y xfonts-thai xfonts-thai-etl xfonts-thai-manop xfonts-thai-nectec xfonts-thai-poonlap xfonts-thai-vor
CMD ["run.sh"]
