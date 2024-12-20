## instalacion de Docker

vemos en la pagina de docker el link de descarga para sistema operativo ios descargamos el archivo ejecutable de docker, luego desde la carpeta descarga lo arrastramos a aplicaciones para instalar docker

luego en la terminal escribimos el siguiente comando para inicializar docker

```sh
sudo service docker start
```

Luego creamos una carpeta en el escritorio para empezar a crear la app dentro de esta carpeta crearemos los siguientes archivos

## configuracion de dockerfile

```sh
FROM ruby:3.0.4
```
```sh
WORKDIR /yourappname
```
```sh
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client imagemagick libvips
```

```sh
COPY Gemfile /yourappname/Gemfile
COPY Gemfile.lock /yourappname/Gemfile.lock
```
```sh
RUN bundle install
```

```sh
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
```

EXPOSE 3000
```sh
CMD ["rails", "server", "-b", "0.0.0.0"]
```

crear archivo gemfile con la siguiente configuracion

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

```rb
Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4" # Rails version
```

creamos un archivo llamado docker-compose.yml

```rb
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
```

 creamos archivo llamado entrypoint.sh

```sh
#!/bin/bash set -e
```
Remove a potentially pre-existing server.pid for Rails.

rm -f /docker_rails/tmp/pids/server.pid

Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
      
Luego creamos un archivo vacio llamado gemfile.lock    

 ahora la siguiente linea de comando construira la aplicacion

```sh
 $ docker compose run --no-deps web rails new . --force --database=postgresql
```

 luego en la carpeta config, en el archivo database.yml desde la linea 17 

```rb
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
```
   

esto es para que se conecte la base de datos con el host que se esta asignando


configuracion de permisos para guardar los cambios de conexion de base de datos

```sh
sudo chown -R clau:clau
```

luego escribimos 
```sh
docker compose up   
```

este comando levanta el servidor para abrir la app de rails en el navegador


## Tailwind instalacion

en el archivo Gemfile agregar la gema de tailwinds

```rb
gem "tailwindcss-rails", "~> 2.0"
```

en la terminal escribimos 

```sh
docker compose build 
```
para que docker carge la imagen con la gema tailwinds

luego para cargar la imagen nuevamente 

```sh
docker compose run web rails tailwindcss:install
```

## creacion de un controlador

```sh
docker compose run web rails g controller pages index landing_page
```

configuramos la ruta

```rb
root 'pages#index'
get 'pages/landing_page'
```

## instalacion fontawesome


docker compose run web ./bin/importmap pin @fortawesome/fontawesome-free @fortawesome/fontawesome-svg-core @fortawesome/free-brands-svg-icons @fortawesome/free-regular-svg-icons @fortawesome/free-solid-svg-icons

con esto se instalaron algunas librerias de fontawesome

luego pegamos esto en el aplication.js

```js
import {far} from "@fortawesome/free-regular-svg-icons"
import {fas} from "@fortawesome/free-solid-svg-icons"
import {fab} from "@fortawesome/free-brands-svg-icons"
import {library} from "@fortawesome/fontawesome-svg-core"
import "@fortawesome/fontawesome-free"
library.add(far, fas, fab)
```

levantamos la imagen

```sh
docker compose build
```

y luego

```sh
docker compose up
```

en otro tab de terminal escribimos

```sh
docker compose run web rails assets:precompile
```

en el archivo index copiamos el codigo del icono

<i class="fa-solid fa-house-user"></i>

el landing page en la pagina principal, mientras que el index sera 
la vista que se vea cuando se inicia sesion, index y landing page son metodos

luego en la carpeta views creamos la carpeta shared y dentro de la carpeta creamos un archivo llamado 

```rb
_main_navbar.html.erb y otro llamado
_footer.html.erb
```

luego renderizaremos nuestro archivo para que se visualize en la vista
en la carpeta layouts en el aplication.html.erb llamamos al archivo
<%= render "shared/main_navbar" %>

le asignamos una clase al navbar luego en la terminal escribimos
la siguiente linea para que se recarguen los estilos

```sh
 docker compose run web rails assets:precompile
```

 luego cerramos ambas terminales y subimos denuevo el servidor con docker compose up


cada vez que agreguemos una nueva clase hay que ejecutar
docker compose run web rails assets:precompile y bajar y subir servidor

para evitarnos esto buscamos el cdn de tailwind y lo pegamos en el aplication.html.erb

<script src="https://cdn.tailwindcss.com"></script>

en el archivo tailwind.config.js pegamos los estilos personalizados de cada elemento

```rb
colors: {
"mainColor": "#2c3639",
"white": "#ffffff",
"signIn": "#9ff1e5",
"signUp": "#ecffc8",
"fontColor": "#0c5d75",
"footerGray": "#f5f5f5",
"editIcon": "#047487",
"removeIcon": "#920404",
"evaluationStrong": "#126f05",
"evaluationLight": "#ddffd9",
"chapterStrong": "#05636f",
"surveyStrong": "#686f05",
}
```

ejecutamos:

docker compose run web rails assets:precompile
docker compose build
y levantamos servidor nuevamente

hasta este commit se configuraron los colores y estilos de los botones tipo de letra
de los botones signin y signup

configuracion footer

configuracion de landing page iconos de redes sociales

## instalacion de devise

en el archivo Gemfile agregamos 

```rb
gem "devise"
```

ejecutamos el comando 

```sh
docker compose build
```

levantamos el contenedor

```sh
docker compose up
```

abrimos un nuevo bash y escribimos lo siguiente

```sh
docker compose run web bash
```

aqui estamos dentro del contenedor con una bash abierta

instalar devise con el siguiente comando

```sh
rails g devise:install
```

luego en el archivo development que esta dentro de config y en production 
pegamos la siguiente linea de codigo

```rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

ahora crearemos la tabla de usuario

```sh
rails g devise User
```

en la terminal escribimos esto, lo cual nos pedira nuestra clave de acceso

```sh
sudo chown -R $USER:$clau . 
```

construimos la imagen de nuevo con docker compose build

levantamos el contenedor

luego para migrar la bd abrimos otro bash y escribimos 

```sh
docker compose run web bash 
```

para abrir un bash dentro del contenedor
y migramos la bd con 

```sh
rails db:migrate
```

ahora generaremos las vistas de devise

```rb
rails g devise:views
```

en el parcial de nabvar cambiamos las rutas

```rb
<%= button_to "sign in", new_user_session_path, class: "py-1 px-4 text-sm text-black font-semibold" %>

<%= button_to "sign up", new_user_registration_path,  class: "py-1 px-4 text-sm text-black font-semibold" %>
```

en el modelo user copiamos esto en la seccion devise

```rb
:confirmable, :trackable
```
construimos la imagen nuevamente y levantamos docker 

si un usuario esta autenticado se mostrara una vista de lo contrario
sera otra vista que se mostrara

```rb
  authenticated(:user) do
    root "pages#index", as: :authenticaded_root
  end  

  unauthenticated(:user) do
    root "pages#landing_page"
  end  
```

## configurando envio de correo con sendgrid

luego vamos a la pagina de dotend

instamos la gema de dotenv en el gemfile

```rb
gem 'dotenv'
```

reconstruimos el contenedor

creamos un archivo .env y guardamos la llave api que se almacena en esa variable env

a continuacion creamos una nueva bash

```sh
 docker compose run web bash  
```
ejecutamos bundle

copiamos el archivo de configuracion en config/envoroment/development

``` rb
   config.action_mailer.raise_delivery_errors = true
   config.action_mailer.perform_deliveries = true
   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.smtp_settings = {
    :user_name => 'apikey'
    :password => Rails.application.credentials.sendgrid_secret_key,
    :domain => 'localhost: 3000', :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
```
borramos las lineas de action mailers que estan en este archivo

luego en el archivo ubicado en initializers/devise.rb 
pegamos el correo electronico con cual configuramos sendgrid

construimos la imagen nuevamente y levantamos el servidor


## Segundo navbar

creamos un parcial llamado _right_navbar

# Generando el modelo

entramos a la bash dentro de docker y ejecutamos

rails g model Section name description type body:text user:references

luego migramos

rails db:migrate

generamos un scaffold solo con un controlador 

rails g scaffold_controller Evaluation name description types body_text user:references

se crearon los 2 controladores para evaluations y chapters

reconstruimos la imagen

falto referenciar al modelo de section

en el controlador de evaluation en el index cambiamos 

 def index
    @evaluations = Section.all
  end

ahora al pulsar create evaluation nos va a llevar a la vista de evaluation
en el index de pages en la seccion de evaluation cambiamos la ruta a evaluations_path

<div class="bg-evaluationStrong p-3 text-white text-sm font-semibold rounded-lg">
      <%= button_to evaluations_path, method: :get id: "create_evaluation_index" do %>
        create evaluation
      <% end %>

ahora realizaremos lo mismo con el boton de chapter

construccion parcial de evaluations

en la carpta de evaluations construimos un parcial _welcome.html.erb y en el archivo index lo renderizamos

ahora creamos el parcial del modal

ahora dentro del modal crearemos el formulario con turbo_frame

se renderiza en el new el formulario que hay en evaluations












