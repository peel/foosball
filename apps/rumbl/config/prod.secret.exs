use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :rumbl, Rumbl.Endpoint,
  secret_key_base: "RKVuHV3Pv+dSZ2GkLdlpvGxu5ZkD8YDoRNaN6yfUP+ce8zspN9yeUbZkRGHH8Jsx"
  http: [port: {:system, "PORT"}],
  url: [host: "secure-escarpment-62712.herokuapp.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :rumbl, Rumbl.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
