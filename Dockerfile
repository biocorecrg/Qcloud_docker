FROM ubuntu:18.04

MAINTAINER LUCA COZZUTO <LUCA.COZZUTO@CRG.EU>

# Latest is 3.5.3
ARG KNIME_VERSION=3.5.3
ARG BLAST_VERSION=2.7.1

ENV DOWNLOAD_URL https://download.knime.org/analytics-platform/linux/knime_${KNIME_VERSION}.linux.gtk.x86_64.tar.gz
ENV INSTALLATION_DIR /usr/local/
ENV KNIME_DIR $INSTALLATION_DIR/knime_${KNIME_VERSION}
ENV HOME_DIR /home/knime

# Install everything
# HACK: Install tzdata at the beginning to not trigger an interactive dialog later on
RUN apt-get update \
    && apt-get install -y software-properties-common curl \
    && apt-get install -y tzdata \
    && apt-add-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
    && apt-get install -y oracle-java8-set-default libgtk2.0-0 libxtst6 \
    && apt-get install -y libwebkitgtk-3.0-0 \
    && apt-get install -y python python-dev python-pip \
    && apt-get install -y curl \
    && apt-get install -y r-base r-recommended

 # Download KNIME
RUN curl -L "$DOWNLOAD_URL" | tar vxz -C $INSTALLATION_DIR \
    && mv $INSTALLATION_DIR/knime_* $INSTALLATION_DIR/knime

RUN cd /usr/local; curl --fail --silent --show-error --location --remote-name ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN cd /usr/local; tar zxf ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz; rm ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN cd /usr/local/bin; ln -s /usr/local/ncbi-blast-${BLAST_VERSION}+/bin/* .

# installing 
RUN apt-get install libxml2-utils

# Clean up
RUN apt-get --purge autoremove -y software-properties-common \
    && apt-get clean

