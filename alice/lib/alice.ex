
defmodule Alice do

  def hello do
    url = "http://www.gutenberg.org/files/11/11-0.txt"
    book = get_book(url)
    book_tf = term_frequency(book)
    for {chapter, i} <- Enum.with_index(String.split(book, "chapter")) do
      IO.puts("Chapter #{i}:")
      tfidf = get_tfidf(book_tf, chapter)
      for {word, freq} <- tfidf do
        IO.puts("#{word}: #{freq}")
      end

      IO.puts("Chapter #{i} has #{String.length(chapter)}\n")
    end
  end

  def get_book (url) do
    {_ok, resp} = HTTPoison.get(url)

    book = resp.body
    book = String.downcase(book)
    for s <- ["\r", "\n", ".", ",", "!"] do
      book = String.replace(book, s, " ")
    end
    book
  end

  def get_chapter(chapter_number, book) do
    String.split(book, "chapter")
    |> Enum.at(chapter_number - 1)
  end

  def _sort_values(a, b) do
    IO.puts("#{a} >? #{b}")
    true
  end

  @spec get_tfidf(map, string) :: map
  def get_tfidf(book_tf, chapter) do
    tfidf = []


    tfidf = for {word, freq} <- term_frequency(chapter) do
      tfidf = List.insert_at(tfidf, -1, %{:word => word, :value => freq/book_tf[word]})
    end
    IO.puts("have #{tfidf |> length} terms")


    tfidf = Enum.sort_by(tfidf, fn (x) -> x[:value] end)

    Enum.each(tfidf, fn x ->
      word = &x[:word]
      value = &x[:value]
      IO.puts("word #{word}: value #{value}")
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


