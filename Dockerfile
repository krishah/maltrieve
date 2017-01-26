#
# This Dockerfile represents a Docker image that encapsulates the Maltrieve tool
# created by Kyle Maxwell (@krmaxwell) for retrieving malware samples.
#
# This Dockerfile is based heavily on the one from Kyle's Maltrieve repository at
# https://github.com/krmaxwell/maltrieve/blob/master/docker/Dockerfile, which is
# maintained by Michael Boman.
#
# To run this image after installing Docker, use a command like this, replacing
# "~/archive" with the path to your working directory on the underlying host.
# This is where the downloaded malware samples will be deposited.
#
# sudo docker run --rm -it -v ~/archive:/archive remnux/maltrieve 
#
# This will launch Maltrieve without any parameters, directing the tool to retrieve
# malware samples and save them to the ~/archive directory.
#
# If you wish to specify command-line parameters to Maltrieve, then launch it like this:
#
# sudo docker run --rm -it -v ~/archive:/archive remnux/maltrieve bash
#
# This will launch the bash shell in the container, at which point you can run the command
# "maltrieve", specifying optional command-line parameters if you wish.
#
# Before running the container, create ~/archive on your host and make it world-accessible
# ("chmod a+xwr").
#

FROM ubuntu:14.04
MAINTAINER Lenny Zeltser (@lennyzeltser, www.zeltser.com)

USER root
RUN apt-get update && apt-get install -y \
  gcc \
  git \
  libpython2.7-stdlib \
  python2.7 \
  python2.7-dev \
  python-pip \
  python-setuptools \
  libffi-dev \
  libssl-dev && \
  rm -rf /var/lib/apt/lists/* && \
  pip install --upgrade pip

RUN groupadd -r nonroot && \
  useradd -r -g nonroot -d /home/nonroot -s /sbin/nologin -c "Nonroot User" nonroot && \
  mkdir /home/nonroot && \
  mkdir /home/nonroot/archive && \
  ln -s /home/nonroot/maltrieve/archive /archive

WORKDIR /home/nonroot/
RUN git clone https://github.com/krmaxwell/maltrieve.git && \
  cd maltrieve && \
  git checkout dev && \
pip install  aspy.yaml==0.2.1 && \
pip install beautifulsoup4==4.3.2 && \
pip install cached-property==1.2.0 && \
pip install cffi==0.9.2 && \
pip install chardet==2.0.1 && \
pip install colorama==0.2.5 && \
pip install cov-core==1.15.0 && \
pip install coverage==3.7.1 && \
pip install coveralls==0.5 && \
pip install cryptography==0.9 && \
pip install docopt==0.6.2 && \
pip install enum34==1.0.4 && \
pip install feedparser==5.2.0.post1 && \
pip install gevent==1.0.1 && \
pip install greenlet==0.4.6 && \
pip install grequests==0.2.0 && \
pip install html5lib==0.999 && \
pip install idna==1.1 && \
pip install ipaddress==1.0.7 && \
pip install jsonschema==2.4.0 && \
pip install LinkChecker==9.3 && \
pip install Markdown==2.6.2 && \
pip install ndg-httpsclient==0.4.0 && \
pip install nodeenv==0.13.2 && \
pip install ordereddict==1.1 && \
pip install pre-commit==0.4.4 && \ 
pip install py==1.4.27 && \
pip install pyasn1==0.1.7 && \
pip install pycparser==2.13 && \
pip install pyOpenSSL==0.15.1 && \
pip install pytest==2.7.0 && \
pip install pytest-cov==1.8.1 && \
pip install python-magic==0.4.6 && \
pip install PyYAML==3.11 && \
pip install requests==2.7.0 && \
pip install setuptools==3.3 && \
pip install simplejson==3.6.5 && \
pip install six==1.5.2 && \
pip install urllib3==1.7.1 && \
pip install virtualenv==12.1.1 && \
pip install wheel==0.24.0 && \
pip install -e . && \
pip install requests[security] &&\
echo "crits = http://crits:8005" >> /home/nonroot/maltrieve/maltrieve.cfg && \
echo "crits_user = maltrieve" >> /home/nonroot/maltrieve/maltrieve.cfg && \
echo "crits_key = 29210d2d0e685e6c835e6619ab9fd7ea54660d90" >> /home/nonroot/maltrieve/maltrieve.cfg && \
echo "crits_source = maltrieve" >> /home/nonroot/maltrieve/maltrieve.cfg && \
#echo "viper = http://viper:8012" >> /home/nonroot/maltrieve/maltrieve.cfg && \
#echo "cuckoo = http://cuckoo:8003" >> /home/nonroot/maltrieve/maltrieve.cfg && \
chown -R nonroot:nonroot /home/nonroot

USER nonroot
WORKDIR /home/nonroot/maltrieve
CMD ["maltrieve"]
