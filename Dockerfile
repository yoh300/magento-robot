FROM yoh300/magento:latest

MAINTAINER "Watchara Chiamchit" <watchara.chiamchit@stream.co.th>

LABEL name="Docker image for the Robot Framework http://robotframework.org/"
LABEL usage="docker run -e ROBOT_TESTS=/path/to/tests/ --rm -v $(pwd)/path/to/tests/:/path/to/tests/ -ti robot-docker"

ENV TIMEZONE Asia/Bangkok

# Install Python Pip and the Robot framework
RUN apt-get update && \
    apt-get install -y python-pip xvfb unzip udev libgconf2-4 firefox=28.0+build2-0ubuntu2 xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
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
RUN wget https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/11199193/+files/chromium-codecs-ffmpeg_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
RUN wget https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/11199193/+files/chromium-codecs-ffmpeg-extra_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
RUN wget https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/11199193/+files/chromium-browser_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
RUN apt-get install -y libgnome-keyring0 libnspr4 libnss3 libpci3 libspeechd2 libxss1 libxtst6 xd xdg-utils
RUN dpkg -i chromium-codecs-ffmpeg_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
RUN dpkg -i chromium-codecs-ffmpeg-extra_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
RUN dpkg -i chromium-browser_53.0.2785.143-0ubuntu0.14.04.1.1145_amd64.deb
CMD ["run.sh"]
