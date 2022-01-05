defmodule SlackMessenger.Utils.HTTPHelpers do
  require Logger
  alias SlackMessenger.Utils.EnvVars
  # alias Calendar.DateTime.Format

  @spec set_headers :: [{<<_::64, _::_*8>>, binary}, ...]
  def set_headers() do
    [
      {"Content-Type", "application/json"}
    ]
  end

  def build_json_body(map) when is_map(map) do
    case Jason.encode(map) do
      {:ok, json_body} ->
        json_body

      error ->
        Logger.error("#{__MODULE__}.build_json_body/1 error = #{inspect(error)}")
        :invalid_body
    end
  end

  def build_url(method) when is_binary(method) do
    url = EnvVars.slack_base_url() <> method
    Logger.debug("#{__MODULE__}.build_url/1 url = #{inspect(url)}")
    url
  end

  @spec decode_json_body(binary | {:error, any} | {:ok, any}) :: any
  def decode_json_body(body) when is_binary(body), do: Jason.decode(body) |> decode_json_body()
  def decode_json_body({:ok, json_map}), do: json_map
  def decode_json_body({:error, error}), do: IO.inspect(error, label: "decode_json_body/1 error")
end
