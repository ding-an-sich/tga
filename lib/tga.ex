defmodule TGA do
  @moduledoc """
  TGA writer
  """

  import Bitwise

  # BGRA order
  @red <<0, 0, 255, 128>>
  @green <<0, 255, 0, 128>>
  @blue <<255, 0, 0, 255>>

  @doc """
  Writes a TGA file.
  """
  def write(name, w, h) do
    file = File.open!(Path.relative_to_cwd(name), [:write])

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
      32,
      0b00101000
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
