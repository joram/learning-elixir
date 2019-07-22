require Stemmer

defmodule Alice do

  def hello do
    url = "http://www.gutenberg.org/files/11/11-0.txt"
    book = get_book(url)
    doc_freq  = term_frequency(book)
    book
      |> String.split("chapter")
      |> Enum.with_index()
      |> Enum.map(fn {chapter, i} ->
        words = []
        words = term_frequency(chapter)
          |> Enum.to_list()
          |> Enum.map(fn {word, tf} ->
            frequencies = []
            df = doc_freq[word]
            term = %{:value => tf/df, :word => word}
            frequencies ++ term
            end)
          |> Enum.sort_by(fn a -> a[:value] end)
          |> Enum.take(-10)
          |> Enum.map(fn term ->
            words ++ term[:word]
          end)

        IO.puts("chapter #{i+1}:\t#{Enum.join(words, ", ")}")
        end)
  end

  def get_book (url) do
    {_ok, resp} = HTTPoison.get(url)
    resp.body
      |> String.downcase()
      |> String.replace("\r", " ")
      |> String.replace("\n", " ")
      |> String.replace("\t", " ")
      |> String.replace(".", " ")
      |> String.replace(",", " ")
      |> String.replace("!", " ")
      |> String.replace("?", " ")
      |> String.replace("'", " ")
      |> String.replace("\"", " ")
      |> String.replace("“", " ")
      |> String.replace("‘", " ")
      |> String.replace("’", " ")
      |> String.replace("-", " ")
      |> String.replace("(", " ")
      |> String.replace(")", " ")
      |> String.replace(";", " ")
  end

  @spec term_frequency(String.t) :: map()
  def term_frequency(sentence) do
    tokens = sentence
    |> String.downcase()
    |> String.replace(~r/@|#|\$|%|&|\^|:|_|!|,/u, " ")
    |> String.split()
    Enum.reduce(tokens, Map.new(), &count_word/2)
  end

  defp count_word(word, map) do
    word = Stemmer.stem(word)
    Map.update(map, word, 1, &(&1 + 1))
  end

end


