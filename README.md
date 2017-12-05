# Ideas

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## Gigalixir

Using Gigalixir we can deploy using releases which is nice. It doesn't say
exactly what they're using but it appears to be a combination of Docker and
Kubernetes. The platform is written with Elixir/Erlang in mind, and as a result
many things that might not work elsewhere are available such as Remote Console,
Clustering, Observer as well as the usual database/tls/scaling/logging etc.

Deployment is relatively straight forward:

Create a .buildpacks file:

```
https://github.com/gigalixir/gigalixir-buildpack-clean-cache.git
https://github.com/HashNuke/heroku-buildpack-elixir
https://github.com/gjaldon/heroku-buildpack-phoenix-static
https://github.com/gigalixir/gigalixir-buildpack-distillery.git
```

Update `config/prod.exs` to include something like:

```
+config :ideas, IdeasWeb.Endpoint,
+  server: true,
+  secret_key_base: "${SECRET_KEY_BASE}"
```

and

```
+config :ideas, Ideas.Repo,
+  adapter: Ecto.Adapters.Postgres,
+  url: "${DATABASE_URL}",
+  ssl: true,
+  database: "",
+  pool_size: 1
```

Note: Pool size must be 1 when using the FREE tier.

To enable building releases, add `distillery` to the list of dependencies
in your `mix.exs`:

```
{:distillery, "~> 1.0.0"}
```

Now you're ready to follow the excellent getting started guide:

https://gigalixir.readthedocs.io/en/latest/main.html#getting-started-guide
