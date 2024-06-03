FROM motoserver/moto:latest

ENV MOTO_PORT=4567
ENV LOCALSTACK_HOST=localhost:${MOTO_PORT}
ENV HOSTS=0.0.0.0

# Install mandoc
RUN  apt-get update && \
     apt-get install -y less mandoc && \
     rm -rf /var/lib/apt/lists/* && \
     \
     # Install awslocal (localstack)
     pip3 --no-cache-dir install --upgrade awscli awscli-local requests && \
     \
     # Create folder for scripts
     mkdir ./init.d &&  \
     \
     # Change aws accountId
     sed -i 's/123456789012/000000000000/g' ./moto/core/models.py && \
      \
      pip3 --no-cache-dir install ".[server]"

ADD ./docker-entrypoint.sh /moto

WORKDIR /moto/

ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 4567
