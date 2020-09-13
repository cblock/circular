defmodule CircularWeb.InputHelpersTest do
  use CircularWeb.ConnCase, async: true
  alias CircularWeb.InputHelpers

  defp generate_form do
    Phoenix.HTML.Form.form_for(:foo, "/foo")
  end

  defp generate_erroneous_form do
    generate_form()
    |> Map.put(:errors, foo: {"cannot be blank", [validation: :required]})
  end

  test "renders a form field without errors" do
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, []))
    assert response =~ "Foo</label"
    assert response =~ "id=\"foo_foo\""
    assert response =~ "name=\"foo[foo]\""
  end

  test "renders an erroneous form field" do
    response =
      Phoenix.HTML.safe_to_string(InputHelpers.input(generate_erroneous_form(), :foo, []))

    assert response =~ "Foo</label"
    assert response =~ "id=\"foo_foo\""
    assert response =~ "name=\"foo[foo]\""
    assert response =~ "cannot be blank"
  end

  test "renders a form field with custom label opts" do
    opts = [label_opts: [name: "custom_name", id: "custom_id"]]
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, opts))

    assert response =~
             "<label class=\"block text-sm font-medium leading-5 text-gray-700\" for=\"foo_foo\" id=\"custom_id\" name=\"custom_name\">Foo</label>"
  end

  test "renders a form field with custom group wrapper opts" do
    opts = [group_wrapper_opts: [name: "custom_name", id: "custom_id"]]
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, opts))
    assert response =~ "<div class=\"mt-6\" id=\"custom_id\" name=\"custom_name\"><label"
  end

  test "renders a form field with custom input wrapper opts" do
    opts = [input_wrapper_opts: [name: "custom_name", id: "custom_id"]]
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, opts))

    assert response =~
             "<div class=\"mt-1 rounded-md shadow-sm\" id=\"custom_id\" name=\"custom_name\"><input"
  end

  test "renders a form field with custom input opts" do
    opts = [input_opts: [name: "custom_name", id: "custom_id"]]
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, opts))

    assert response =~
             "<input class=\"appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5\" id=\"custom_id\" name=\"custom_name\" type=\"text\">"
  end

  test "renders a form field using custom input type" do
    response =
      Phoenix.HTML.safe_to_string(
        InputHelpers.input(generate_form(), :foo, using: :password_input)
      )

    assert response =~
             "<input class=\"appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5\" id=\"foo_foo\" name=\"foo[foo]\" type=\"password\">"
  end
end
