defmodule Webscraping do

  def recursion(content) do
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
        recursion(tail)
    end
  end

  def get_cnn_brasil do
    IO.puts("Digite sua palavra de busca: ")
    busca = IO.gets("") |> String.trim()

    case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("li.home__list__item")
          recursion(content)
    end
  end
end
