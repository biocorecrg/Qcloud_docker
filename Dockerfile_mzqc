FROM python:3.6.9-slim-buster
 
ENV DEBIAN_FRONTEND noninteractive 
 
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \ 
  git \
  vim \
  libcurl4-openssl-dev

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN echo "deb http://http.debian.net/debian buster main" > /etc/apt/sources.list.d/debian-unstable.list

RUN pip install pronto pytest biopython flask click
RUN pip install --force-reinstall git+'https://github.com/HUPO-PSI/mzQC@mzqc-pylib#egg=MZQC-0.0.1&subdirectory=pylib'
