FROM elixir:1.16.1

WORKDIR /app
COPY . .
ENV MIX_ENV docker

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client bash

EXPOSE 4000

CMD mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile && \
    mix ecto.migrate && \
    mix phx.server