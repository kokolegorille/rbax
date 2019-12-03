defmodule Metrics.Setup do
  def setup, do: Metrics.PlugExporter.setup()
end
