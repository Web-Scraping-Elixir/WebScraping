defmodule Webscraping do

  def main do
    IO.puts("Digite sua palavra de busca: ")
    busca = IO.gets("") |> String.trim()

    {search_term, search_term_bloom} = count_words(busca)

    task_g1 = Task.async(fn -> get_g1(search_term) end)
    task_cnn_brasil = Task.async(fn -> get_cnn_brasil(search_term) end)
    task_bloom = Task.async(fn -> get_bloom(search_term_bloom) end)

    Task.await(task_g1)
    Task.await(task_cnn_brasil)
    Task.await(task_bloom)
  end

  def count_words(input) do
    words = input |> String.split(~r/\s+/)
    word_count = words |> length()
    if word_count > 1 do
      replace(input)
    else
      {words, words}
    end
  end

  def replace(input) do
    cnn_g1 = String.replace(input, " ", "+")
    bloom = String.replace(input, " ", "%20")
    {cnn_g1, bloom}
  end

  def recursion_bloom(content) do
    case content do
      [] -> :ok
      [head | tail] ->
        title =
          head
          |> Floki.find("a.headline__3a97424275")
          |> Floki.text()

        autor =
          head
          |> Floki.find("div.authors__29e96e9287")
          |> Floki.text()

        href =
          head
          |> Floki.find("a.headline__3a97424275")
          |> Floki.attribute("href")

        date =
          head
          |> Floki.find("div.publishedAt__dc9dff8db4")
          |> Floki.text()

        article =
          head
          |> Floki.find("a.summary__a759320e4a")
          |> Floki.text()

        IO.puts("                         Fonte: Bloom                           ")
        IO.puts("Title: #{title}")
        IO.puts("Autor: #{autor}")
        IO.puts("Link: #{href}")
        IO.puts("Post info: #{date}")
        IO.puts("Article: #{article}")
        IO.puts("")
        IO.puts(
          "------------------------------------------------------------------------------------------------------------------------"
        )
        recursion_bloom(tail)
    end
  end

  def get_bloom(busca) do
    IO.puts("Iniciando busca no Bloom")
    case HTTPoison.get("https://www.bloomberg.com/search?query=#{busca}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("div.storyItem__aaf871c1c5")
          recursion_bloom(content)
    end
  end

  def recursion_g1(content) do
    case content do
      [] -> :ok
      [head | tail] ->
        title =
          head
          |> Floki.find("div.widget--info__text-container")
          |> Floki.find("div.widget--info__title")
          |> Floki.text()

        href =
          head
          |> Floki.find("div.widget--info__text-container")
          |> Floki.find("a")
          |> Floki.attribute("href")

        time =
          head
          |> Floki.find("div.widget--info__text-container")
          |> Floki.find("div.widget--info__meta")
          |> Floki.text()

        description =
          head
          |> Floki.find("div.widget--info__text-container")
          |> Floki.find("p.widget--info__description")
          |> Floki.text()

        IO.puts("                         Fonte: G1                            ")
        IO.puts("Title: #{title}")
        IO.puts("Inicio: #{description}")
        IO.puts("Link: https:#{href}")
        IO.puts("Tempo da publicacao: #{time}")
        IO.puts("")
        IO.puts(
          "------------------------------------------------------------------------------------------------------------------------"
        )
        recursion_g1(tail)
    end
  end

  def get_g1(busca) do
    IO.puts("Iniciando busca no G1")
    case HTTPoison.get("https://g1.globo.com/busca/?q=#{busca}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("li.widget--info")
          recursion_g1(content)
    end
  end

  def recursion_cnn(content) do
    case content do
      [] -> :ok
      [head | tail] ->
        title = head
        |> Floki.find("h3.news-item-header__title.market__new__title")
        |> Floki.text()

        link = head
        |> Floki.find("a.home__list__tag")
        |> Floki.attribute("href")

        date = head
        |> Floki.find("span.home__title__date")
        |> Floki.text()

        IO.puts("                         Fonte: CNN Brasil                            ")
        IO.puts("Title: #{title}")
        IO.puts("Link: #{link}")
        IO.puts("Post info: #{date}")
        IO.puts("")
        IO.puts(
          "------------------------------------------------------------------------------------------------------------------------"
        )
        recursion_cnn(tail)
    end
  end

  def get_cnn_brasil(busca) do
    IO.puts("Iniciando busca na CNN Brasil")
    case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("li.home__list__item")
          recursion_cnn(content)
    end
  end
end
