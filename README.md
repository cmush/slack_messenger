# SlackMessenger

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Open [Slack's API Website](https://api.slack.com/), [create an app](https://api.slack.com/apps?new_app=1), and get an oauth2 bearer token.
  * A sample configuration of the app is provided (`.env.sample`). Use the sample to create your own `.env` file. Provide the require values then source the file (in your terminal). 
  * On Slack, Ensure the app's bot is added to the channels of your choice. (You can't send messages to a slack channel your app /bot is not a member of).
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`  

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.  

  * Once the index page is loaded, click on `List Member Channels`, The index page will show a list of channels your app / bot is a member of. Click open to access the messages page.
  * You may now send a new message or retrieve the channel's existing pages. You may also delete messages.


To see the latest version of the app running on Giglalixir, open: https://slack-messenger.gigalixirapp.com/.
(Please note that you must be a member of my private Slack organisation and channel to which you are sending messages in order to see them)

Further, you may access the github actions page to see the ci/cd as dictated by `.github/workflows/github-actions.yml`. 

Given more time / If this app was to go to production, Please note that:
  * the CI/CD pipelines would be more elaborate and split into environments such as dev, staging, prod.
  * coveralls would be configured for test coverage checks.
  * a linter for the elixir code to check quality and formatting
  * user management to restric access as required.
  * restrictions on who can push to protected branches
  * ... any other requirements the team agrees on.
