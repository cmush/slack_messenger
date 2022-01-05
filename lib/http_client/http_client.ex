defmodule SlackMessenger.HttpClient do
  alias Finch.Response
  require Logger
  import SlackMessenger.Utils.HTTPHelpers
  # alias Multipart.Part

  @doc """
  - defines the child spec for the Finch connection pool
  - allows us to start up our Finch connection pool from
  """
  @spec child_spec(any) ::
          {Finch, [{:name, SlackMessenger.HttpClient} | {:pools, map}, ...]}
  def child_spec(args) do
    Logger.info(
      "HttpClient.child_spec/1 Starting the slack_api_wrapper http client with a pool of #{inspect(args.pool_size)} connections"
    )

    Logger.debug("HttpClient.child_spec/1 args = #{inspect(args)}")

    {Finch,
     name: __MODULE__,
     pools: %{
       args.base_url => [size: args.pool_size]
     }}
  end

  @spec get(binary()) ::
          {:error,
           %{
             :__exception__ => any,
             :__struct__ => Mint.HTTPError | Mint.TransportError,
             :reason => any,
             optional(:module) => any
           }}
          | {:ok, Finch.Response.t()}
  def get(api_method) when is_binary(api_method) do
    :get
    |> Finch.build(
      build_url(api_method),
      set_headers()
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("get/1")
  end

  def post_application_json(api_method, body, headers \\ [{"Content-Type", "application/json"}])
      when is_binary(api_method) and is_list(headers) and is_map(body) do
    :post
    |> Finch.build(
      build_url(api_method),
      set_headers(headers),
      build_json_body(body)
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("post/2")
  end

  def post_application_x_www_form_urlencoded(
        api_method,
        body,
        headers \\ [{"Content-Type", "application/x-www-form-urlencoded"}]
      )
      when is_binary(api_method) and is_list(headers) and is_map(body) do
    :post
    |> Finch.build(
      build_url(api_method),
      set_headers(headers),
      build_url_encoded_body(body)
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("post/2")
  end

  defp parse_http_client_response(response, http_client_method)
       when is_binary(http_client_method) do
    # parse finch response
    response
    |> case do
      {:error, %Mint.TransportError{} = error} ->
        Logger.error(
          "#{__MODULE__}.#{http_client_method} failed request, transport error #{inspect(error)}"
        )

      {:ok, %Response{headers: headers, body: body, status: status}} ->
        decoded_json_body = body |> decode_json_body()

        Logger.debug(
          "#{__MODULE__}.#{http_client_method}'s response headers = #{inspect(headers)}"
        )

        Logger.debug(
          "#{__MODULE__}.#{http_client_method}'s decoded json response body = #{inspect(decoded_json_body)}"
        )

        Logger.debug(
          "#{__MODULE__}.#{http_client_method}'s http response status code = #{inspect(status)}"
        )

        %SlackMessenger.Response{headers: headers, body: decoded_json_body, status: status}

      response ->
        Logger.warning(
          "#{__MODULE__}.#{http_client_method} error decoding response = #{inspect(response)}"
        )

        response
    end
  end
end
