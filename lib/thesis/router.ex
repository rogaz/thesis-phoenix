defmodule Thesis.Router do
  @moduledoc """
  Creates the routes that Thesis uses to handle requests from its javascript
  editor client as well as static assets.

  Typically, you'll add this to your `web/web.ex` file, under the `router`
  function:

      def router do
        quote do
          use Phoenix.Router
          use Thesis.Router
          # ...
        end
      end

  If you'd prefer, you can remove it from `web/web.ex` and add it to the router
  yourself:

      defmodule MyApp.Router do
        use Thesis.Router
        # ...
  """

  defmacro __using__(_env) do
    quote do
      pipeline :thesis_pipeline do
        plug Plug.Static, at: "/thesis", from: :thesis, gzip: true,
          cache_control_for_etags: "public, max-age=86400",
          headers: [{"access-control-allow-origin", "*"}]

        plug :fetch_session
        plug :fetch_flash
        plug :put_secure_browser_headers
      end

      pipeline :ensure_auth do
        plug Cms.UserManager.Pipeline
        plug Guardian.Plug.EnsureAuthenticated
        plug Cms.UserManager.SetCurrentUser
      end

      scope "/thesis", Thesis do
        pipe_through :thesis_pipeline

        get "/thesis.js", ApiController, :assets
        get "/thesis.css", ApiController, :assets

        get "/backups", ApiController, :backups_for_page
        get "/restore/:backup_id", ApiController, :restore

        get "/files/:slug", ApiController, :show_file
      end

      scope "/thesis", Thesis do
        pipe_through [:thesis_pipeline, :ensure_auth]

        put "/update", ApiController, :update
        delete "/delete", ApiController, :delete

        post "/files/upload", ApiController, :upload_file
        post "/files/import", ApiController, :import_file
      end
    end
  end
end
