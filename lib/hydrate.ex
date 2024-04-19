defmodule Mix.Tasks.Hydrate do
  @moduledoc "The hydrate mix task: `mix help hydrate`"
  use Mix.Task

  @shortdoc "Starts the application and hydrates the database with the most recent foodtruck data."
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")

    Hydrator.hydrate()
  end
end
