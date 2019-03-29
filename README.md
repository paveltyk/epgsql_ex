# EpgsqlEx - Custom PostgreSQL driver and adapter for Ecto

Ever wonder how does Ecto work with a database? What Postgrex, DBConnection, and EctoSQL are for? "Tear apart and put it back together" - that's how I learn. Follow me along as I build DBConnection compliant PostgreSQL driver, write an adapter for Ecto, and put it all together in a fancy way. The goal of this exercise is to build a naive implementation of Postgrex and Ecto.Adapters.Postgres and to understand how everything is connected under the hood. Let's start right away.

[Continue reading...](https://medium.com/@paveltyk/custom-postgresql-driver-and-adapter-for-ecto-bedf1f9e0d19)

## Usage

```
# config/config.exs
config :demo, Repo,
  username: "postgres",
  password: "postgres",
  database: "epgsql",
  hostname: "localhost"

# lib/repo.ex
defmodule Repo do
  use Ecto.Repo,
    otp_app: :your_app_name,
    adapter: EpgsqlEx.EctoAdapter
end
```
