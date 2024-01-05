# README

This is my rails boilerplate for project / product that I create.

## How to run??

Start the dependencies with docker compose.

```
docker-compose up -d
```

Generate public and private key for the app.

```
make gen_app_private_key
make gen_app_public_key
```

Create database and do the migrations.

```
rails db:create
rails db:migrate
```

Run the server

```
rails s
```
