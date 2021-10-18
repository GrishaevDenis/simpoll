<h1>Коробочная версия Simpoll</h1>

1) Распакуйте полученный дистрибутив simpoll и разместите в папке, например /opt/simpoll

2)  Замените в следующей команде <strong>YOUR-DOMAIN-NAME</strong> на доменное имя, которое будет использоваться для сервиса (домен должен указывать на сервер, на котором производится запуск сервиса). Запустите команду в консоле.

<pre>
docker run  -d -p 80:80 -p 443:443 \
     -v /opt/simpoll:/var/www/html \
     -v simpoll_mysql:/var/lib/mysql \
     --restart unless-stopped  \
     -e DB_NAME='simpoll' \
     -e DB_USER='simpoll' \
     -e DB_PASSWORD='simpoll' \
     -e HOSTNAME='<strong>YOUR-DOMAIN-NAME</strong>' \
     --name simpoll lisfer/simpoll:latest 
</pre>

3) Через несколько минут сервис будет запущен. Вы можете открыть в браузере https://YOUR-DOMAIN-NAME и завершить настройку сервиса в Мастере установки.
На шаге настройки подключения к базе данных укажите название базы данных, имя пользоваться и пароль из переменных, указанных при запуске контейнера. Если Вы ничего не меняли, то во все три параметра внесите simpoll.


<h3>Docker Compose example</h3>

<pre>
version: '3.8'

services:

  simpoll:
    image: lisfer/simpoll
    container_name: simpoll
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
    volumes:
      - /opt/simpoll:/var/www/html
      - simpoll_mysql:/var/lib/mysql
    environment:
      DB_NAME: simpoll
      DB_USER: simpoll
      DB_PASSWORD: simpoll
      HOSTNAME: <strong>YOUR-DOMAIN-NAME</strong>

volumes:
    simpoll_mysql:  {}

</pre>
