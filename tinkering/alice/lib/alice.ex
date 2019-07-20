
defmodule Alice do

  def get_book (url) do
    {_ok, resp} = HTTPoison.get(url)
    book = resp.body
    book = String.downcase(book)
    book = String.replace(book, "\r", " ")
    book = String.replace(book, "\n", " ")
    book = String.replace(book, "      ", " ")
    book = String.replace(book, "     ", " ")
    book = String.replace(book, "    ", " ")
    book = String.replace(book, "   ", " ")
    book = String.replace(book, "  ", " ")
    book
  end

  def get_chapter(chapter_number, book) do
    String.split(book, "chapter")
    |> Enum.at(chapter_number - 1)
  end

  def hello do
    url = "http://www.gutenberg.org/files/11/11-0.txt"
    book = get_book(url)
    book_tf = term_frequency(book)
    num_chapters = String.split(book, "chapter") |> length

    for i <- 1..num_chapters do
      IO.puts("Chapter #{i}:")
      chapter = get_chapter(i, book)
      tfidf = get_tfidf(book_tf, chapter)
      for {word, freq} <- tfidf do
        IO.puts("#{word}: #{freq}")
      end

      keywords = get_keywords(tfidf)
      IO.puts("Chapter #{i} has #{String.length(chapter)}\n")
    end
  end

  def get_keywords(tfidf) do
    terms = Map.to_list(tfidf)
    IO.puts("#{terms}")
  end

  @spec get_tfidf(map, string) :: map
  def get_tfidf(book_tf, chapter) do
    tfidf = Map.new()
    for {word, freq} <- term_frequency(chapter) do
      if book_tf[word] > 3 and String.length(word) > 1 do
        tfidf = Map.put(tfidf, word, freq/book_tf[word])
        IO.puts("setting #{word}: #{tfidf[word]}")
      end
      tfidf
    end

    for {word, freq} <- Map.to_list(tfidf) do
      IO.puts("#{word}: #{freq}")
    end

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


