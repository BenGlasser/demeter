# Table of Contents

- [Table of Contents](#table-of-contents)
- [Demeter](#demeter)
  - [Dependencies](#dependencies)
    - [Elixir and Erlang](#elixir-and-erlang)
    - [Docker](#docker)
  - [Building and running things](#building-and-running-things)
    - [The Docker Way...](#the-docker-way)
    - [The Other Way...](#the-other-way)
      - [Postgres](#postgres)
      - [Demeter Service](#demeter-service)
      - [Mix Hydrate Task](#mix-hydrate-task)
  - [Testing](#testing)
  - [Thoughts](#thoughts)

# Demeter
![tests](https://github.com/benglasser/demeter/actions/workflows/test.yml/badge.svg)


Demeter is a simple web app built with [Elixir](https://elixir-lang.org/) and [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) which displays a list of foodtrucks in San Fransisco, their addresses, and the type of food they sell. Users can browse the list, select, and save their favorites.

Favorites can be selected and deselected by clicking on the row containing the foodtruck they want to save. Once selected, favorites can be identified by the blue star in the far left of the row. On page load favorites will be grouped first at the top of the list and then in ascending alphabetical order by name.

The app also provides a mix task to hydrate the database with the most recent open data available by running `mix hydrate` from the root of this project. The hydrator will update all existing foodtrucks while preserving any favorites that have already been saved. Newly discovered foodtrucks will be added to the database, and missing foodtrucks will not be deleted.

![](https://raw.githubusercontent.com/BenGlasser/demeter/c9f56f70e420f34e468f125a18a49ce54e1686f1/assets/Demeter%20Demo.gif)

## Dependencies

This project depends on the following versions of elixir and erlang

- elixir 1.16.1-otp-26
- erlang 26.2.1
- docker

### Elixir and Erlang

If you use `asdf` with the elixir and erlang plugins, there is a `.tool-versions` file in the root of this project which will install the required language dependencies by running

```
asdf install
```

from the project's root directory

### Docker

If you have a recent version of `docker` installed or you have `docker-compose` installed this will make getting up and running very easy.

If you do not have 'docker-compose' or your docker toolchain does not include `compose` you can still run docker manually with the included Dockerfile.

If you don't have docker installed at all, then I humbly offer this piece of wisdom I often hear from my son when we play Fortnite together, "_Git gud, bruh!_" 😜😎

## Building and running things

Clone this repo to get started...

HTTPS:

```
git clone https://github.com/BenGlasser/demeter.git
```

or

SSH:

```
git clone git@github.com:BenGlasser/demeter.git
```

### The Docker Way...

If you have docker installed run this command from the root of this project

```
docker compose up -d
```

then navigate to http://localhost and you're done. Kick back and enjoy life on easy street as you bask in the glory of a comprehensive list of over 400 foodtrucks which can be found roaming the streets of San Fransisco... who's hungry?!

![](https://i.giphy.com/yidUzHnBk32Um9aMMw.webp)

**NOTE:** The local directories have been mapped to the docker containers so this setup works for development which is handy if you like to tinker.

### The Other Way...

If you hate docker for some reason setup will take a little longer, but read on and we'll get there together 🙂

#### Postgres

Fire up postgres on your machine however you choose to do that, and ensure the following requirements are met:

- running on port 5432
- user: postgres
- password: postgres

if this command works `psql -h localhost -U postgres` then you're probably good to go.

#### Demeter Service

Now we need to fire up the the webapp.

Run the following from the root of this project

```
    mix deps.get && \
    mix compile && \
    mix ecto.create && \
    mix ecto.migrate && \
    mix hydrate && \
    mix phx.server
```

Nice YOLO! 😎😎😎

If that completes without errors you're good to go! You should be able to hit http://localhost:4000 in your browser and see a bunch of foodtrucks 🚚

#### Mix Hydrate Task

This project contains a mix task for hydrating the database with fresh foodtruck data. This task can be run with the command `mix hydrate` and can be run any time whether the service is running or not.

## Testing

Currently all the tests are passing. If they don't pass for you, all I can say is "_It works on my machine_" ¯\\\_(ツ)\_/¯

1. you can run all the tests by running `mix test` in the root of this project
2. individual tests can be run by suppliing a file path to the test task, `mix test </path/to/test.exs>` or `mix test </path/to/test.exs>:<line-number>`

## Thoughts

There are several improvements that could be made to this project to improve performance and user experience.

1.  the first improvement on our list would be to live update the foodtruck list upon favorite selection an deselection. Currently, foodtrucks are grouped by favorite so upon first load all favorites are easy to find at the top of the list. As a user scrolls down the list selecting favorites newly selected favorites become dispersed throughout the list because of the fact that clicking on a row triggers an update to the view only for the selected foodtruck but not the list as a whole. This could be achieved server-side by altering the return value so that the entire foodtruck list is refetched and sorted before updating the stream in [`DemeterWeb.FoodtruckLive.Index.handle_event/3`](https://github.com/BenGlasser/demeter/blob/c9f56f70e420f34e468f125a18a49ce54e1686f1/lib/demeter_web/live/foodtruck_live/index.ex#L17). However, this would not be very efficient since we already have all the foodtruck data client-side. A simpler and more efficient approach would be to re-sort the list on the client once the stream is updated.
2.  Another improvement I'd like to make is to the hydration task. Currently this task only updates foodtrucks returned from the Open Data API call. This means that the database will only ever grow in response to hydration while stale foodtrucks are left to cruft up the database. To remedy this it might be useful to diff the results from the API call with the existing foodtruck data and delete any rows which don't have a corresponding value in the response from the Open Data call.
3.  While beyond the scope of this project, the `mix hydrate` task could also be improved by automating the hydration task. Doing this at regular intervals would ensure that the app is always serving fresh data. There are many ways to do this such as:
    1.  fetching the data on every initial page load which would ensure the freshest data everytime the app is visited, but could impact initial load times depending on how many foodtrucks are returned.
    2.  creating a cron job to run the mix task at regular intervals. This would maximize control over the data refresh, but could increase the risk of serving stale data if the refresh interval is to big.
    3.  spawning a new process to periodically refetch the foodtruck data. This would have benifits similar to creating a cron job, but has the potential to impact performance of the running app although that's probably unlikely to be an issue. The biggest benifit of this approach would be the ability to keep all clients updated with the freshest foodtruck data since doing this would allow you to push refreshed data to all open sockets for currently connected users.
4.  The previous concern segues nicely into a problem that exists currently with a lack of data sanitization on the foodtruck data. Right now, the data returned from the Open Data API is slapped into the database without care or concern for SQL injection. It is unlikely, but if someone figured out a way sneak some SQL into the foodtruck data, they would have unfettered access to the database. This is not a huge issue at the moment since the only data in the database is the foodtruck data they would already have access to, but if any sensitive data were to be added to the database it would not be secure. Sooo... right now the only data security I have in here is only to say, "_Please don't hack me bro!_" 😅😓
