defmodule CircularWeb.InputHelpersTest do
  use CircularWeb.ConnCase, async: true
  alias CircularWeb.InputHelpers

  defp generate_form do
    Phoenix.HTML.Form.form_for(:foo, "/foo")
  end

  defp generate_erroneous_form do
    generate_form()
    |> Map.put(:errors, [foo: {"cannot be blank", [validation: :required]}])
  end

  test "renders a form field without errors " do
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_form(), :foo, []))
    assert response =~ "Foo</label"
    assert response =~ "id=\"foo_foo\""
    assert response =~ "name=\"foo[foo]\""
  end

  test "renders an erroneous form field " do
    response = Phoenix.HTML.safe_to_string(InputHelpers.input(generate_erroneous_form(), :foo, []))
    assert response =~ "Foo</label"
    assert response =~ "id=\"foo_foo\""
    assert response =~ "name=\"foo[foo]\""
    assert response =~ "cannot be blank"
  end

end
