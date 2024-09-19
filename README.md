#Readme

instalacion de Docker

vemos en la pagina de docker el link de descarga para sistema operativo ios
 descargamos el archivo ejecutable de docker, luego desde la carpeta descarga
 lo arrastramos a aplicaciones para instalar docker

 luego en la terminal escribimos el siguiente comando para inicializar docker

 sudo service docker start

 Luego creamos una carpeta en el escritorio para empezar a crear la app
  dentro de esta carpeta crearemos los siguientes archivos

  # dockerfile con esta configuracion

  FROM ruby:3.0.4

WORKDIR /yourappname

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client imagemagick libvips

COPY Gemfile /yourappname/Gemfile
COPY Gemfile.lock /yourappname/Gemfile.lock

RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

crear archivo gemfile con la siguiente configuracion

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4" # Rails version

creamos un archivo llamado docker-compose.yml

#version: "3.9"
services:
  db:
    image: postgres:latest
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_USERNAME: postgres
      POSTGRES_PASSWORD: password

  redis:
    image: 'redis:latest'
    ports:
      - '6379:6379'

  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/docker_rails
    ports:
      - "3000:3000"
    depends_on:
      - db
      - redis
    environment:
      - REDIS_URL=redis://redis:6379/


     # creamos archivo llamado entrypoint.sh

      #!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /docker_rails/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
      

 # Luego creamos un archivo vacio llamado gemfile.lock    


 ahora la siguiente linea de comando construira la aplicacion

 $ docker compose run --no-deps web rails new . --force --database=postgresql

 luego en la carpeta config, en el archivo database.yml desde la linea 17 

 default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: password
  pool: 5

development:
  <<: *default
  database: myapp_development


test:
  <<: *default
  database: myapp_test

   

   esto es para que se conecte la base de datos con el host que se esta
   asignando


configuracion de permisos para guardar los cambios de conexion de base de datos

    sudo chown -R clau:clau

    luego escribimos 

    docker compose up   este comando levanta el servidor para abrir la app de rails en el navegador


# Tailwind instalacion

en el archivo Gemfile agregar la gema de tailwinds

gem "tailwindcss-rails", "~> 2.0"

en la terminal escribimos 

docker compose build 
para que docker carge la imagen con la gema tailwinds

luego para cargar la imagen nuevamente 

docker compose run web rails tailwindcss:install


# creacion de un controlador

docker compose run web rails g controller pages index landing_page

configuramos la ruta

  root 'pages#index'
  get 'pages/landing_page'