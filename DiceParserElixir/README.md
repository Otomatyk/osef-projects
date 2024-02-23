# DiceParserElixir

This is a simple dice roller written in Elixir.

## Docs

### Basic dices roll
  [number_of_dices] d [sides]

  E.g `10d6` = 10 dices of 6 sides

  You can ommit [number_of_dices].
  In this case, only one dice will be rolled

  E.g `d20` = 1 dice of 20 sides

### Add or substract dices rolls
  You can modify the final sum by using + and -, constant numbers are allowed
  There is no limit of addition or subtraction.

  E.g `2d8+10-5+3d6-333d5`

### Keep only dices with the lowest/greatest values
  You can add
  k [number_of_dices_to_keep]
  to keep only the dices with the greatest values

  E.g `50d100k10` = Roll 50 dices with 100 sides, keep the best 10

  Negative values are also allowed, to keep the lowest

  E.g `50d100k10` = Roll 50 dices with 100 sides, keep the wrostest 10

### Sort
  Just add "s" to the end to sort the result

  E.g `50d450s`

### Misc
  Upper-case letters are allowed

  E.g `10D66k-3S`