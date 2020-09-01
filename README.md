# HealtApp API

master: [![pipeline status](https://gitlab.com/fiuba-memo2/tp2/elmuro-api/badges/master/pipeline.svg)](https://gitlab.com/fiuba-memo2/tp2/elmuro-api/commits/master)

staging: [![pipeline status](https://gitlab.com/fiuba-memo2/tp2/elmuro-api/badges/staging/pipeline.svg)](https://gitlab.com/fiuba-memo2/tp2/elmuro-api/commits/staging)

### Ambientes

- Producción Api: [link](https://elmuro-api-prod.herokuapp.com/)
- Staging Api: [Link](https://elmuro-api-staging-env.herokuapp.com/)
- Producción Bot: [link](https://elmuro-bot.herokuapp.com/)
- Staging Bot: [Link](https://elmuro-bot-staging.herokuapp.com/)
- Bot stating: [STGHealthElmuro](https://t.me/STGHealthElmuroBot)
- Bot producción: [healthElmuro](https://t.me/healthElmuroBot)

### Convenciones

#### Estrategia de branching

Cuando se comienza a trabajar en una feature, se debe salir desde la branch _staging_, siempre estando _up to date_ con _origin_
```
 ---- staging ----
   \
    --- my-feature ---
```
Luego, cuándo se haya terminado de trabajar en la feature, se armará un Merge Request desde la branch creada hacia _staging_. Cuándo este MR sea aprobado por algún otro miembro del equipo, entonces podremos mergear nuestro branch a _staging_ y el código será desplegado al ambiente de pre-producción.
```
 ---- staging ---------------
   \                    /
    --- my-feature -----
```
 #### Default Actions
 
 En caso de que un miembro tenga una consulta que debe comentar con algun otro miembro del equipo pero este no contesta dentro de 2 horas, se procedera con la interpretación del autor de la consulta.

También, en caso de que un miembro lea la consulta pero no puede responder porque esta ocupado, deme notificar que luego procedera a responder la duda del compañero.

#### Code Review
Una vez finalizado un feature, debe crearse un merge request a la rama de staging y notificar a los demás miembros para que alguno de estos revise el código y apruebe el merge en caso de estar correcto, o notificar de los cambios necesarios para la aprobación del mismo.

### Guía de ejecución para la API

#### PostgreSQL setup

Seguir los siguientes pasos para inicializar la base de datos de PostgreSQL:

1. Installar PostgreSQL si es necesario.En Ubuntu se puede ejecutar el siguiente comando:
`sudo apt-get install -y postgresql-9.5 postgresql-contrib postgresql-server-dev-9.5`
2. Crear los ambientes development y test databases ejecutando:
`sudo -u postgres psql --dbname=postgres -f ./create_dev_and_test_dbs.sql`

#### Padrino application setup

1. Run **_bundle install --without staging production_**, para instalar todas la dependecias de la aplicación
2. Run **_bundle exec rake_**, para ejecutar todos los test y asegurarse que todo este instalado correctamente
3. Run **_RACK_ENV=development bundle exec rake db:migrate db:seed_**, para setear la base de datos development
4. Run **_bundle exec padrino start -h 0.0.0.0_**, para ejecutar la aplicación

