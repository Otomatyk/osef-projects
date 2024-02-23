defmodule App.Main do
  @not_empty_cmd_regex ~r"\S+"
  @commands %{
    :exit => "quit",
    :docs => "docs"
  }

  def interactive_interpreter() do
    IO.puts("""
    --- DiceParserElixir ---

    Commands :
      "#{@commands.exit}" => Exit the interpreter
      "#{@commands.docs}" => Print the documentation
      [any command] => Execute (Roll) the command
    """)

    execute_input()
  end

  defp format_result(result) do
    {state, dice_roll} = result

    case state do
      :ok -> "# #{dice_roll.sum}\n#{Enum.join(dice_roll.dices, ", ")}"
      :fail -> dice_roll
    end
  end

  defp execute_input(cmd \\ "") do
    want_exit = String.starts_with?(cmd, @commands.exit)

    if String.match?(cmd, @not_empty_cmd_regex) and !want_exit do
      App.DicesRoller.roll(cmd)
      |> format_result()
      |> IO.puts()
    end

    if String.starts_with?(cmd, @commands.docs), do: get_docs() |> IO.puts()

    unless want_exit, do: IO.gets("\n>>>") |> execute_input()
  end

  def get_docs() do
    """
    --- DiceParserElixir's Docs ---

    Basic dices roll
      [number_of_dices] d [sides]

      E.g `10d6` = 10 dices of 6 sides

      You can ommit [number_of_dices].
      In this case, only one dice will be rolled

      E.g `d20` = 1 dice of 20 sides

    Add or substract dices rolls
      You can modify the final sum by using + and -, constant numbers are allowed
      There is no limit of addition or subtraction.

      E.g `2d8+10-5+3d6-333d5`

    Keep only dices with the lowest/greatest values
      You can add
      k [number_of_dices_to_keep]
      to keep only the dices with the greatest values

      E.g `50d100k10` = Roll 50 dices with 100 sides, keep the best 10

      Negative values are also allowed, to keep the lowest

      E.g `50d100k10` = Roll 50 dices with 100 sides, keep the wrostest 10

    Sort
      Just add "s" to the end to sort the result

      E.g `50d450s`

    Misc
      Upper-case letters are allowed

      E.g `10D66k-3S`
    """
  end
end

App.Main.interactive_interpreter()
