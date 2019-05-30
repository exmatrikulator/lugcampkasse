#!/bin/bash
set -e


if [ -z "$@" ]; then

    if [ -n "$(grep DEBUG=True) /app/config.cfg" ]; then
      sed -i "s/DEBUG=True/DEBUG=False/" /app/config.cfg
      secret=$(pwgen -1)
      sed -i "s/SECRET_KEY='development-key'/SECRET_KEY='$secret'/" /app/config.cfg
      secret=$(pwgen -1)
      sed -i "s/CASHIER_PASSWORD='changemetosomethingsecret'/CASHIER_PASSWORD='$secret'/" /app/config.cfg
      echo "CASHIER_PASSWORD: $secret"
      sed -i "s/REDIS_HOST = \"localhost\"/REDIS_HOST = \"redis\"/" /app/config.cfg

      python manage.py import_csv -i user.csv
      python manage.py import_csv -i products.csv

    fi

    chown www-data:www-data db
    chown www-data:www-data db/lugcampkasse.sqlite

    #python manage.py runserver
    nginx && uwsgi --http-websockets --ini /app/app.ini
fi

exec "$@"
