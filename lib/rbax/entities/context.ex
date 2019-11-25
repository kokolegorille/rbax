defmodule Rbax.Entities.Context do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Permission

  schema "contexts" do
    field :name, :string
    field :rule, :string
    field :filter, :string
    has_many(:permissions, Permission)
    timestamps()
  end

  @default_nil_rule_value true
  @allowed_fields ~w(name rule filter)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end

  # Return a function of arity 2 : fn s, o -> #{rule} end :: boolean
  #
  # iex> contexts = Rbax.list_contexts
  # iex> functions = contexts |> Enum.map(fn c -> Rbax.Entities.Context.fun_rule(c) end)
  # [#Function<1.40858771/2 in Rbax.Entities.Context.nil_rule_value/0>,
  #  #Function<13.91303403/2 in :erl_eval.expr/5>,
  #  #Function<13.91303403/2 in :erl_eval.expr/5>]
  # iex> List.first(functions).(1, 3)
  # true
  #
  def fun_rule(%__MODULE__{rule: nil}), do: nil_rule_value()
  def fun_rule(%__MODULE__{rule: rule}) do
    # Try rescue block in case of bad rule

    # string_rule =
    # """
    # fn s, o ->
    #   IO.inspect({s, o})
    #   try do
    #     #{rule}
    #   rescue
    #     _  -> false
    #   end
    # end
    # """

    string_rule = "fn s, o -> try do #{rule} rescue _  -> false end end"

    try do
      {fun, _} = Code.eval_string(string_rule)
      fun
    rescue
      _ -> nil_rule_value(false)
    end
  end

  # default value, in case rule is nil
  defp nil_rule_value(value \\ @default_nil_rule_value), do: fn _, _ -> value end
end
