defmodule DemeterWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @spec header(map()) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex gap-6 items-center justify-between", @class, "mb-5 pt-5"]}>
      <div class="text-center">
        <h1 class="font-semibold leading-8 text-gray-200 text-lg">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="leading-6 mt-2 text-gray-400 text-sm">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <footer class={[@class, "mb-5 min-h-14 pt-5"]}>
      <%= render_slot(@inner_block) %>
    </footer>
    """
  end

  def scroll_top(assigns) do
    ~H"""
    <button
      id="scroll-to-top-button"
      class="
        border
        h-fit
        hover:animate-pulse
        hover:border-none
        hover:ring-2
        hover:ring-cyan-500
        hover:text-cyan-500
        mx-auto
        p-1
        rounded-full
        text-gray-200
        w-fit
      "
      phx-hook="ScrollToTop"
      style="display: none;"
    >
      <.icon name="hero-arrow-up-solid" />
    </button>
    """
  end

  @spec table(map()) :: Phoenix.LiveView.Rendered.t()
  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div
      id="foodtruck-table"
      class="
        h-[55rem]
        no-scrollbar
        overflow-y-scroll
        pb-20
        px-4
        sm:px-0
        table-wrp
        top-0
      "
    >
      <table class="max-w-[60rem] mx-auto sm:w-full">
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="
            divide-transparent
            divide-y
            divide-y-2
            leading-6
            text-gray-200
            text-sm
          "
        >
          <tr
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            class="
              bg-gray-700
              duration-500
              group
              hover:scale-110
              hover:shadow-2xl
              hover:z-40
              text-base
            "
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={[
                "p-5 relative",
                @row_click && "hover:cursor-pointer",
                i == 0 && "text-center",
                i == 0 && @row_item.(row) |> elem(1) |> Map.get(:favorite) && "text-lg"
              ]}
            >
              <div class="">
                <span class="
                  -inset-y-px
                  -left-4
                  -right-4
                  absolute
                  group-hover:bg-gray-600
                  sm:rounded-xl
                " />
                <span class={["relative", i == 0 && "font-semibold text-gray-200"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands
  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(DemeterWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(DemeterWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
