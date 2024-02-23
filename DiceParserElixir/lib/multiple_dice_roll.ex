defmodule App.DicesRoller do
  @dice_roll_regex "([1-9][0-9]*)?(d|e)[1-9][0-9]*(k\-?[0-9]+)?s?"
  @multiple_dice_roll_regex ~r/#{@dice_roll_regex}([\+\-]#{@dice_roll_regex})*/i

  @operators_regex ~r"(?<!k)[+-]"

  def roll_chunked_cmd(chunk) do
    [operator, cmd] = chunk

    result = App.SingleDicesRoller.roll(cmd)

    %{
      :dices => result.dices,
      :sum =>
        result.sum *
          case operator do
            "-" -> -1
            "+" -> 1
          end
    }
  end

  defp roll_valid(cmd) do
    # Doesn't have a verification, unlike roll\1

    result =
      cmd
      |> String.replace(" ", "")
      |> String.downcase()
      |> String.split(@operators_regex, include_captures: true)
      # The first dices are always added
      |> (&["+" | &1]).()
      |> Enum.chunk_every(2)
      |> Enum.map(&roll_chunked_cmd/1)

    %{
      :sum => result |> Enum.map(& &1.sum) |> Enum.sum(),
      :dices => result |> Enum.map(& &1.dices) |> Enum.concat()
    }
  end

  def roll(cmd) do
    case String.match?(cmd, @multiple_dice_roll_regex) do
      true -> {:ok, roll_valid(cmd)}
      false -> {:fail, "Invalid command, got \"#{String.trim_trailing(cmd, "\n")}\""}
    end
  end
end
