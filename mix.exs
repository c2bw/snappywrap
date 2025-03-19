defmodule Snappywrap.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/c2bw/snappywrap"

  def project do
    [
      app: :snappywrap,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      description: "Pure Elixir implementation to wrap binary data in uncompressed Snappy format"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:snappyrex, "~> 0.1.0", only: :test, runtime: false},
      {:ex_doc, "~> 0.37.3", only: :dev, runtime: false},
      {:varint, "~> 1.5"},
      {:excrc32c, "~> 0.1"}
    ]
  end

  defp package do
    [
      name: "snappywrap",
      source_url: @url,
      files: ["lib", "mix.exs", "mix.lock", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => @url}
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "Snappywrap",
      canonical: "http://hexdocs.pm/snappywrap",
      source_url: @url,
      extras: ["README.md", "LICENSE"]
    ]
  end
end
