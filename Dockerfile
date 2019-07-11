FROM ubuntu:18.04

MAINTAINER Alexander Fillbrunn <alexander.fillbrunn@uni.kn>

ARG KNIME_VERSION=3.5.3
ARG DEBIAN_FRONTEND=noninteractive
ARG BLAST_VERSION=2.7.1

ENV DOWNLOAD_URL https://download.knime.org/analytics-platform/linux/knime_${KNIME_VERSION}.linux.gtk.x86_64.tar.gz

ENV INSTALLATION_DIR /usr/local/

ENV KNIME_DIR $INSTALLATION_DIR/knime_${KNIME_VERSION}
ENV HOME_DIR /home/knime

# Install Java and WebKit
RUN apt-get update \
 && apt-get install -y software-properties-common curl \
 \
 && apt-get update \
 && apt-get install -y libgtk2.0-0 libxtst6 \
 && apt-get install -y libwebkitgtk-3.0-0 \
 && apt-get install -y python python-dev python-pip\
 && apt-get install -y r-base r-recommended \
 # Download KNIME
 && curl -L "$DOWNLOAD_URL" | tar vxz -C $INSTALLATION_DIR \
 && apt-get --purge autoremove -y software-properties-common curl \
 && apt-get clean

ENV PATH="/usr/local/knime_${KNIME_VERSION}/:${PATH}"
COPY plugins/ /usr/local/knime_${KNIME_VERSION}/plugins/


RUN apt-get install curl
RUN cd /usr/local; curl --fail --silent --show-error --location --remote-name ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN cd /usr/local; tar zxf ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz; rm ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN cd /usr/local/bin; ln -s /usr/local/ncbi-blast-${BLAST_VERSION}+/bin/* .

# installing 
RUN apt-get install libxml2-utils


##RUN gcc --version

# Install pandas and protobuf so KNIME can communicate with Python
##RUN pip install pandas && pip install protobuf

# Install Rserver so KNIME can communicate with R
##RUN R -e 'install.packages(c("Rserve"), repos="http://cran.rstudio.com/")'

## Set a default user. Available via runtime flag `--user knime`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
#RUN adduser --disabled-password --quiet --gecos '' knime \
#  && chown -R root:knime $KNIME_DIR \
#  && chmod -R 775 $KNIME_DIR \
#  && mkdir -p $HOME_DIR \
#	&& chown knime:knime $HOME_DIR \
#	&& addgroup knime staff

# Switch user and run KNIME
#USER knime
#ENTRYPOINT $KNIME_DIR/knime

# docker run -e DISPLAY=192.168.99.1:0 -d --name knime -v /Users/Alexander/knime-workspace:/home/knime/workspace -t knime
