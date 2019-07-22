
defmodule Alice do

  def hello do
    url = "http://www.gutenberg.org/files/11/11-0.txt"
    book = get_book(url)
    doc_freq  = term_frequency(book)
    chapters = book |> String.split("chapter")
    IO.puts(chapters |> length)
    chapters
      |> Enum.with_index()
      |> Enum.map(fn {chapter, i} ->
        words = []
        words = term_frequency(chapter)
          |> Enum.to_list()
          |> Enum.map(fn {word, tf} ->
            frequencies = []
            df = doc_freq[word]
            term = %{:value => tf/df, :word => word}
            frequencies = frequencies ++ term
            end)
          |> Enum.sort_by(fn a -> a[:value] end)
          |> Enum.take(-10)
          |> Enum.map(fn term ->
            words = words ++ term[:word]
          end)

        IO.puts("chapter #{i+1}:\n#{Enum.join(words, ", ")}\n")
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

  def get_chapter(chapter_number, book) do
    String.split(book, "chapter")
    |> Enum.at(chapter_number - 1)
  end

  def _sort_values(a, b) do
    IO.puts("#{a} >? #{b}")
    true
  end

  @spec keywords(map, string) :: map
  def keywords(book_tf, chapter) do
    tfidf = []


    tfidf = for {word, freq} <- term_frequency(chapter) do
      if book_tf[word] > 5 do
        tfidf = List.insert_at(tfidf, -1, %{:word => word, :value => freq/book_tf[word]})
      end
    end
    IO.puts("have #{tfidf |> length} terms")

    tfidf = Enum.sort_by(tfidf, fn (y) ->
      x = 0
      if y != nil and length(y) > 0 do
        x = y |> List.first()
#        IO.puts(x)
        x = x[:value]
      end
      x
    end)

    tfidf = Enum.take(tfidf, -10)
    Enum.each(tfidf, fn y ->
      if y != nil and length(y) > 0 do
  #      IO.puts("#{IEx.Info.info(y)}")
        x = List.first(y)
  #      IO.puts("#{IEx.Info.info(x)}")
        word = x[:word]
        value = x[:value]
        IO.puts("#{word}:\t #{value}")
        else
        IO.puts("empty")
      end
    end)

    tfidf
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
    Map.update(map, word, 1, &(&1 + 1))
  end

end


