FROM python:3.10.5-alpine

RUN apk add --update --no-cache python3 clang musl-dev python3-dev gcc make
ENV CC=clang

RUN python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools



RUN adduser -S -D -h /home/gltile -s /usr/bin/nologin -u 1001 gltile
USER gltile
WORKDIR /home/gltile

ADD requirements.txt

RUN python3 -m venv venv \
    && . venv/bin/activate.sh \
    && pip install -r requirements.txt

USER root
RUN apk del --purge clang musl-dev python3-dev gcc make

USER gltile
ADD api.py api.py

# I can assure you that this is necessary
ADD "https://pbs.twimg.com/media/FUi0IlXVUAAj8Bo?format=png" /home/gltile/catgirl.png

ENTRYPOINT ["python3", "-B", "api.py"]