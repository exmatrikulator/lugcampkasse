FROM ubuntu

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 80

RUN apt update && apt install -y bash nginx uwsgi uwsgi-plugin-python python-pip git pwgen gcc g++ python-dev libevent1-dev\
	&& pip install --upgrade pip

# app dir
WORKDIR /app
RUN chmod 777 -R /run/
COPY . /app
COPY nginx.conf /etc/nginx/nginx.conf

RUN pip install -r /app/requirements.txt

VOLUME /app/db

# exectute start up script
ENTRYPOINT ["/app/entrypoint.sh"]
