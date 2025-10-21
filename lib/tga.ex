defmodule TGA do
  @moduledoc """
  TGA writer
  """

  import Bitwise

  # BGR order
  @blue <<255, 0, 0>>
  @green <<0, 255, 0>>
  @red <<0, 0, 255>>

  @doc """
  Writes a TGA file.
  """
  def write(name, w, h) do
    file = File.open!(Path.relative_to_cwd(name), [:append])

    header = <<
      0,
      0,
      2,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      w &&& 255,
      (w >>> 8) &&& 255,
      h &&& 255,
      (h >>> 8) &&& 255,
      24,
      0b00100000
    >>

    IO.binwrite(file, header)

    Enum.each(1..h, fn h ->
      Enum.each(1..w, fn _ ->
        color = cond do
          h < 66 -> @red
          h < 132 -> @green
          true -> @blue
        end

        IO.binwrite(file, color)
      end)
    end)
  end
end
