
{:ok, resp} = HTTPoison.get!("http://www.gutenberg.org/files/11/11-0.txt")
IO.puts(resp.body)