FROM python:3
WORKDIR /usr/src/app
RUN pip3 install flask redis
COPY flaskmicroservice.py .
ENV REDIS_HOST=redis
ENV BIND_PORT=8080
ENV REDIS_PORT=6379
CMD [ "python3", "./flaskmicroservice.py" ]
