defmodule App.SingleDicesRoller do
  @valid_number_regex ~r"^\d+$"

  defp lexe(cmd) do
    cmd
    |> String.replace(~r"\s", "")
    |> String.downcase()
    |> String.split(~r"[sdk]", trim: true, include_captures: true)
    |> Enum.map(
      &case String.match?(&1, ~r"-?[0-9]+") do
        true -> Integer.parse(&1) |> elem(0)
        false -> &1
      end
    )
  end

  defp parse(tokens) do
    tokens =
      case Enum.at(tokens, 0) |> is_integer() do
        false -> [1 | tokens]
        true -> tokens
      end

    k_index = Enum.find_index(tokens, &(&1 == "k"))
    keep = k_index && Enum.at(tokens, k_index + 1)

    %{
      :n_dices => Enum.at(tokens, 0),
      :exploding_dices => Enum.at(tokens, 1) == "e",
      :n_sides => Enum.at(tokens, 2),
      :keep => keep,
      :sort => Enum.at(tokens, -1) == "s"
    }
  end

  defp roll_basic_dices(lefting_dices, n_sides) do
    rolled_number = Range.new(1, n_sides) |> Enum.random()

    case lefting_dices == 0 do
      true -> []
      false -> [rolled_number | roll_basic_dices(lefting_dices - 1, n_sides)]
    end
  end

  defp keep_dices(dices, keep) do
    cond do
      keep == nil -> dices
      keep == 0 -> []
      keep > 0 -> Enum.sort(dices) |> Enum.reverse() |> Enum.slice(0..(keep - 1))
      keep < 0 -> Enum.sort(dices) |> Enum.slice(0..(abs(keep) - 1))
    end
  end

  defp sort_if(dices, sort) do
    case sort do
      true -> Enum.sort(dices)
      false -> dices
    end
  end

  defp roll_parsed(specs) do
    result =
      roll_basic_dices(specs.n_dices, specs.n_sides)
      |> keep_dices(specs.keep)
      |> sort_if(specs.sort)

    %{
      :sum => Enum.sum(result),
      :dices => result
    }
  end

  defp roll_cmd(cmd) do
    cmd
    |> String.trim_leading("!")
    |> lexe()
    |> parse()
    |> roll_parsed()
  end

  def roll(cmd) do
    case String.match?(cmd, @valid_number_regex) do
      true ->
        %{
          :sum => Integer.parse(cmd) |> elem(0),
          :dices => []
        }

      false ->
        roll_cmd(cmd)
    end
  end
end
