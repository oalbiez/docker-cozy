FROM ubuntu:latest


RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates \
      curl \
      wget \
 && apt-get clean

ENV DOCKERIZE=v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE}/dockerize-linux-amd64-${DOCKERIZE}.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE}.tar.gz \
 && rm dockerize-linux-amd64-${DOCKERIZE}.tar.gz

ENV COZY=2017M2-alpha
RUN curl -o /usr/local/bin/cozy-stack \
         -L https://github.com/cozy/cozy-stack/releases/download/${COZY}/cozy-stack-linux-amd64-${COZY} \
 && chmod +x /usr/local/bin/cozy-stack

COPY cozy.yaml /etc/cozy/cozy.yaml.tmpl

RUN adduser --system --no-create-home --shell /bin/bash --group --gecos "Cozy" cozy \
 && mkdir /var/log/cozy \
 && chown cozy: /var/log/cozy \
 && mkdir /var/lib/cozy \
 && chown -R cozy: /var/lib/cozy \
 && chown -R cozy: /etc/cozy

VOLUME /srv/cozy

ENV COUCHDB http://couchbd:5984/
EXPOSE 8080

CMD ["/usr/local/bin/dockerize", "-template", "/etc/cozy/cozy.yaml.tmpl:/etc/cozy/cozy.yaml", \
    "/usr/local/bin/cozy-stack", "serve"]
