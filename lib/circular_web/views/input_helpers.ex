defmodule CircularWeb.InputHelpers do
  @moduledoc ~S"""
  Helpers related to producing custom tailwind UI conformand HTML input form groups.

  Using the helpers in this module form inouts are layouted in HTML like this:

  <div class="mt-6"><label class="block text-sm font-medium leading-5 text-gray-700" for="user_email">Email</label>
    <div class="mt-1 rounded-md shadow-sm"><input
            class="form-input block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:border-red-300 focus:ring-red-300 sm:text-sm sm:leading-5"
            id="user_email" name="user[email]" type="email" value=""></div>
    <p class="mt-1 text-xs text-red-600" phx-feedback-for="user_email">can't be blank</p>
  </div>

  Erroneous fields are automatically marked red and the error description is displayed
  """

  use Phoenix.HTML

  @doc """
    Generates and input form field with accompanying label (and maybe) error description wrapped in
    tailwind-ui formatted div tags

    The form should either be a `Phoenix.HTML.Form` emitted
    by `form_for` or an atom.

    All given options are forwarded to the underlying input, label an error tag,
    default values are provided for id, name, class and value if
    possible.

    You can override options for all resulting tags using the opts keyword list. In particular you can use...

    - [group_wrapper_opts: ...] to customize the outer div of the form group
    - [label_opts: ...] to customize the input label
    - [input_wrapper_opts: ...] to customize the div that wraps the input element
    - [input_opts: ...] to customize the input element itself

    You may not want to use the type inflected by input_type. You can override this with the **:using** option.
    For example if you want to replace the :datetime_select input that ships with Phoenix by a custom datepicker
    you may pass [using: custom_date_picker].

    Note: For input types that do not ship with Phoenix you *must also implement* a custom defp input() in this module

    ## Examples

        # Assuming form contains a User schema
        input(form, :email)
        #=> <div class="mt-6"><label class="block text-sm font-medium leading-5 text-gray-700" for="user_email">Email</label><div class="mt-1 rounded-md shadow-sm"><input class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-blue-300 focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5" id="user_email" name="user[email]" type="email"></div></div>

        text_input(:user, :email)
        #=> <div class="mt-6"><label class="block text-sm font-medium leading-5 text-gray-700" for="user_email">Email</label><div class="mt-1 rounded-md shadow-sm"><input class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-blue-300 focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5" id="user_email" name="user[email]" type="email"></div></div>

        text_input(:user, :email, [group_wrapper_opts: [class: "group", id: "specific"], label_opts: [class: "label"], imput_wrapper_opts: [class: "input_wrapper"], input_opts: [class: "input"]])
        #=> <div id="specific" class="group"><label class="label" for="user_email">Email</label><div class="input_wrapper"><input class="input" id="user_email" name="user[email]" type="email"></div></div>

  """
  @spec input(atom | Phoenix.HTML.Form.t(), atom, keyword) :: {:safe, [binary]}
  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    group_wrapper_opts =
      Keyword.get(opts, :group_wrapper_opts, [])
      |> Keyword.put_new(:class, "mt-6")

    label_opts =
      Keyword.get(opts, :label_opts, [])
      |> Keyword.put_new(:class, "block text-sm font-medium leading-5 text-gray-700")

    input_wrapper_opts =
      Keyword.get(opts, :input_wrapper_opts, [])
      |> Keyword.put_new(:class, "mt-1 rounded-md shadow-sm")

    input_opts =
      Keyword.get(opts, :input_opts, [])
      |> Keyword.put_new(:class, calc_input_opts_class_for(form.errors[field]))

    content_tag :div, group_wrapper_opts do
      label = label(form, field, humanize(field), label_opts)

      input =
        content_tag :div, input_wrapper_opts do
          input(type, form, field, input_opts)
        end

      error = CircularWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error]
    end
  end

  defp calc_input_opts_class_for(nil) do
    "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-blue-300 focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5"
  end

  defp calc_input_opts_class_for(_) do
    "form-input block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:border-red-300 focus:ring-red-300 sm:text-sm sm:leading-5"
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
