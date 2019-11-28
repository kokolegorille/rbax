# Rbax

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Dataloader

{:dataloader, "~> 1.0"}

Example
=======

iex> source = Dataloader.Ecto.new(Rbax.Repo)
iex> loader = Dataloader.new |> Dataloader.add_source(Rbax.Entities, source)
iex> subjects = Rbax.list_subjects
iex> loader = Enum.reduce(subjects, loader, fn subject, acc -> 
    Dataloader.load(acc, Rbax.Entities, :roles, subject) 
  end)
iex> loader |> Dataloader.run