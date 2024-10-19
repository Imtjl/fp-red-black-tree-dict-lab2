defmodule TreeDict.MixProject do
  use Mix.Project

  def project do
    [
      app: :tree_dict,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:propcheck, "~> 1.4.1", only: [:test]},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
