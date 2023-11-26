FROM python:3.9-alpine3.13
LABEL maintainer="Omid Esmailbeig"

# Fix python printing
ENV PYTHONUNBUFFERED 1

COPY ./requirements/base.txt /tmp/
COPY ./requirements/dev.txt /tmp/
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Installing all python dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    if [ $DEV = "true" ]; then \
        /py/bin/pip install -r /tmp/dev.txt; \
    else \
        /py/bin/pip install -r /tmp/base.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
