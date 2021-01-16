FROM moroen/domoticz:latest AS builder

ARG MAKE_FLAGS="-j4"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Oslo

RUN apt update && apt install -y tzdata python3-dev python3-pip git golang

COPY IKEA-Tradfri-plugin /opt/domoticz/plugins/IKEA-Tradfri
COPY tradfricoap /src/tradfricoap
COPY pycoap /src/pycoap 

RUN pip3 install setuptools

WORKDIR /src/pycoap
RUN python3 setup.py install
WORKDIR /src/tradfricoap
RUN python3 setup.py install

FROM ubuntu:latest
COPY --from=builder /opt/domoticz /opt/domoticz
COPY --from=builder /usr/local/lib/python3.8/dist-packages /usr/local/lib/python3.8/dist-packages
COPY --from=builder /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages

RUN apt update && apt install -y libssl1.1 libcurl4 python3 python3-dev

WORKDIR /opt/domoticz
RUN mkdir -p /config
CMD /opt/domoticz/domoticz -dbase /config/domoticz.db -log /config/domoticz.log