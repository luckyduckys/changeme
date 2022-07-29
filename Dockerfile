FROM alpine:latest as base

RUN apk update \
    && apk add unixodbc-dev libpq-dev gcc g++ py3-pip python3-dev python3 \
    && python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM alpine:latest
RUN apk update \
    && apk add python3
RUN mkdir /changeme
COPY . /changeme
COPY --from=base /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /changeme
ENTRYPOINT ["./changeme.py"]