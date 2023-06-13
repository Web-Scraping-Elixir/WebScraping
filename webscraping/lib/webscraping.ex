defmodule Webscraping do
  use Crawly.Spider

  def clear_output_file do
    File.write("./output/saida.txt", "", [:truncate])
  end

  def main do
    IO.puts("Digite sua palavra de busca: ")
    busca = IO.gets("") |> String.trim()

    clear_output_file()
    {search_term, search_term_bloom} = count_words(busca)


    task_g1 = Task.async(fn -> get_g1(search_term) end)
    task_cnn_brasil = Task.async(fn -> get_cnn_brasil(search_term) end)
    task_bloom = Task.async(fn -> get_bloom(search_term_bloom) end)

    # HTMLGenerator.generate_html()

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


  def get_g1(busca) do
    IO.puts("Iniciando busca G1")

    body =
      Crawly.fetch("https://g1.globo.com/busca/?q=#{busca}")
      |> Map.get(:body)

    Floki.find(body, "li.widget--info")
    |> Enum.map(fn item ->
      title =
        Floki.find(item, "div.widget--info__text-container")
        |> Floki.find("div.widget--info__title")
        |> Floki.text()

      href =
        Floki.find(item, "div.widget--info__text-container")
        |> Floki.find("a")
        |> Floki.attribute("href")

      time =
        Floki.find(item, "div.widget--info__text-container")
        |> Floki.find("div.widget--info__meta")
        |> Floki.text()

      description =
        Floki.find(item, "div.widget--info__text-container")
        |> Floki.find("p.widget--info__description")
        |> Floki.text()

      {title, href, time, description}
    end)
    |> Enum.each(fn {title, href, time, description} ->

      info =
        "Fonte: G1\n" <>
        "Title: #{title}\n" <>
        "Inicio: #{description}\n" <>
        "Link: https:#{href}\n" <>
        "Tempo da publicacao: #{time}\n" <>
        "------------------------------------------------------------------------------------------------------------------------\n\n"

      File.write("./output/saida.txt", info, [:append])

      IO.puts("Title: #{title}")
      IO.puts("Inicio: #{description}")
      IO.puts("Link: https:#{href}")
      IO.puts("Tempo da publicacao: #{time}")
      IO.puts("")
      IO.puts(
        "------------------------------------------------------------------------------------------------------------------------"
      )
    end)
  end

  def get_cnn_brasil(busca) do
    IO.puts("Iniciando busca CNN Brasil")

    body =
      Crawly.fetch("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc")
      |> Map.get(:body)

    Floki.find(body, "li.home__list__item")
    |> Enum.map(fn item ->
      title =
        Floki.find(item, "h3.news-item-header__title.market__new__title")
        |> Floki.text()

      href =
        Floki.find(item, "a.home__list__tag")
        |> Floki.attribute("href")

      date =
        Floki.find(item, "span.home__title__date")
        |> Floki.text()

      {title, href, date}
    end)
    |> Enum.each(fn {title, href, date} ->

      info =
        "Fonte: CNN Brasil\n" <>
        "Title: #{title}\n" <>
        "Link: #{href}\n" <>
        "Post info: #{date}\n" <>
        "------------------------------------------------------------------------------------------------------------------------\n\n"

      File.write("./output/saida.txt", info, [:append])

      IO.puts("Title: #{title}")
      IO.puts("Link: #{href}")
      IO.puts("Post info: #{date}")
      IO.puts("")
      IO.puts(
        "------------------------------------------------------------------------------------------------------------------------"
      )
    end)
  end

  def get_bloom(busca) do
    IO.puts("Iniciando busca Bloom")

    body =
      Crawly.fetch("https://www.bloomberg.com/search?query=#{busca}")
      |> Map.get(:body)

    Floki.find(body, "div.storyItem__aaf871c1c5")
    |> Enum.map(fn item ->
      title =
        Floki.find(item, "a.headline__3a97424275")
        |> Floki.text()

      autor =
        Floki.find(item, "div.authors__29e96e9287")
        |> Floki.text()

      href =
        Floki.find(item, "a.headline__3a97424275")
        |> Floki.attribute("href")

      date =
        Floki.find(item, "div.publishedAt__dc9dff8db4")
        |> Floki.text()

      article =
        Floki.find(item, "a.summary__a759320e4a")
        |> Floki.text()

      {title, autor, href, date, article}
    end)
    |> Enum.each(fn {title, autor, href, date, article} ->

      info =
        "Fonte: Bloom\n" <>
        "Title: #{title}\n" <>
        "Autor: #{autor}\n" <>
        "Link: #{href}\n" <>
        "Post info: #{date}\n" <>
        "Article: #{article}\n\n" <>
        "------------------------------------------------------------------------------------------------------------------------\n\n"

      File.write("./output/saida.txt", info, [:append])


      IO.puts("Title: #{title}")
      IO.puts("Autor: #{autor}")
      IO.puts("Link: #{href}")
      IO.puts("Post info: #{date}")
      IO.puts("Article: #{article}")
      IO.puts("")
      IO.puts(
        "------------------------------------------------------------------------------------------------------------------------"
      )
    end)
  end
end
