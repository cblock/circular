defmodule CircularWeb.InputHelpers do
  @moduledoc """
  Conveniences for translating and building form field html.
  """

  use Phoenix.HTML


  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "mt-6"]
    label_opts = [class: "block text-sm font-medium leading-5 text-gray-700"]
    input_wrapper_opts = [class: "mt-1 rounded-md shadow-sm"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = content_tag :div, input_wrapper_opts do
        input(type, form, field, input_opts(form.errors[field]))
      end
      error = CircularWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  defp input_opts(nil) do
    [class: "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5"]
  end
  defp input_opts(_) do
    [class: "form-input block w-full pr-10 border-red-300 text-red-900 placeholder-red-300 focus:border-red-300 focus:shadow-outline-red sm:text-sm sm:leading-5"]
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
