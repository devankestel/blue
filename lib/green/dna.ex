defmodule Green.Dna do

  def read(strand) do
    strand
      |> String.codepoints()
      |> Enum.chunk_every(3)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(
        fn codon ->
          translate(codon)
        end
      )
  end

  def write_strand(svg_string) do
    chunk = svg_string
      |>find_next_chunk()

    strand = chunk
      |> encode()

    svg_string = svg_string
      |> String.replace_leading(chunk, "")

    write_strand(svg_string, strand)
  end

  def write_strand(svg_string, strand) do
    if svg_string == "" do
      strand
    else
      IO.inspect(svg_string)
      chunk = svg_string
        |>find_next_chunk()
      strand = strand<>encode(chunk)
      IO.inspect(strand)
      svg_string = svg_string
      |> String.slice(
        String.length(chunk)..-1
      )
      |> String.trim_leading()
      write_strand(svg_string, strand)
    end
  end

  def find_next_chunk(svg_string) do
    cond do
      svg_string |> String.starts_with?("<svg") -> "<svg"
      svg_string |> String.starts_with?("</svg>") -> "</svg>"
      svg_string |> String.starts_with?("0") -> "0"
      svg_string |> String.starts_with?("1") -> "1"
      svg_string |> String.starts_with?("width") -> "width"
      svg_string |> String.starts_with?("height") -> "height"
      svg_string |> String.starts_with?(">") -> ">"
      svg_string |> String.starts_with?("=") -> "="
      true -> ""
    end
  end

  def encode(svg_chunk) do
    case svg_chunk do
      "<svg" -> "AAA"
      "</svg>" -> "AAB"
      "0" -> "AAC"
      "1" -> "AAD"
      "width" -> "AAE"
      "height" -> "AAF"
      ">" -> "AAG"
      "=" -> "AAH"
      _ -> ""
    end
  end

  def translate(codon) do
    case codon do
      "AAA" -> "<svg"
      "AAB" -> "</svg>"
      "AAC" -> "0"
      "AAD" -> "1"
      "AAE" -> "width"
      "AAF" -> "height"
      "AAG" -> ">"
      "AAH" -> "="
      _ -> ""
    end
  end
end
