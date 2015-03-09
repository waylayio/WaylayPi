FROM resin/rpi-raspbian:jessie-2015-03-04

# Install Python.
RUN apt-get update && apt-get install -y sudo avahi-daemon curl python python-dev python-pip git libi2c-dev python-serial i2c-tools python-smbus

RUN git clone https://github.com/WiringPi/WiringPi.git && cd WiringPi && ./build && echo "wiringPi Installed"
RUN pip install RPi.GPIO

COPY . /app

CMD ["bash", "/app/start.sh"]
