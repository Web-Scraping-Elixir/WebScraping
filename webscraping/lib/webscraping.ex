defmodule Webscraping do
   def main do
      IO.puts("Digite sua palavra de busca: ")
      busca = IO.gets("") |> String.trim()

      task_g1 = Task.async(fn -> get_g1(busca) end)
      task_cnn_brasil = Task.async(fn -> get_cnn_brasil(busca) end)
      task_bloom = Task.async(fn -> get_bloom(busca) end)

      # HTMLGenerator.generate_html()

      Task.await(task_g1)
      Task.await(task_cnn_brasil)
      Task.await(task_bloom)
   end

   def get_g1(busca) do
      IO.puts("Iniciando busca G1")
      case HTTPoison.get("https://g1.globo.com/busca/?q=#{busca}") do
         {:ok, %HTTPoison.Response{body: body}} ->
         {:ok, doc} = :html_parser.parse(body)

         content =
            :html_parser.select(doc, "li.widget--info") |> Enum.map(fn item ->
            title =
                  :html_parser.select(item, "div.widget--info__text-container div.widget--info__title") |> List.first() |> :html_parser.text()

            href =
                  :html_parser.select(item, "div.widget--info__text-container a") |> List.first() |> :html_parser.attribute("href")

            time =
                  :html_parser.select(item, "div.widget--info__text-container div.widget--info__meta") |> List.first() |> :html_parser.text()

            description =
                  :html_parser.select(item, "div.widget--info__text-container p.widget--info__description") |> List.first() |> :html_parser.text()

            {title, href, time, description}
            end)

         Enum.each(content, fn {title, href, time, description} ->
            IO.puts("Title: #{title}")
            IO.puts("Inicio: #{description}")
            IO.puts("Link: https:#{href}")
            IO.puts("Tempo da publicacao: #{time}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
         end)
      end
   end

   def get_cnn_brasil(busca) do
      IO.puts("Iniciando busca CNN Brasil")

      case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do
         {:ok, %HTTPoison.Response{body: body}} ->
         {:ok, doc} = :html_parser.parse(body)

         content =
            :html_parser.select(doc, "li.home__list__item") |> Enum.map(fn item ->
            title =
                  :html_parser.select(item, "h3.news-item-header__title.market__new__title") |> List.first() |> :html_parser.text()

            href =
                  :html_parser.select(item, "a.home__list__tag") |> List.first() |> :html_parser.attribute("href")

            date =
                  :html_parser.select(item, "span.home__title__date") |> List.first() |> :html_parser.text()

            {title, href, date}
            end)

         Enum.each(content, fn {title, href, date} ->
            IO.puts("Title: #{title}")
            IO.puts("Link: #{href}")
            IO.puts("Post info: #{date}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
         end)
      end
   end

   def get_bloom(busca) do
      IO.puts("Iniciando busca Bloom")

      case HTTPoison.get("https://www.bloomberg.com/search?query=#{busca}") do
         {:ok, %HTTPoison.Response{body: body}} ->
            {:ok, doc} = :html_parser.parse(body)

            content =
            :html_parser.select(doc, "div.storyItem__aaf871c1c5") |> Enum.map(fn item ->
               title =
                  :html_parser.select(item, "a.headline__3a97424275") |> List.first() |> :html_parser.text()

               autor =
                  :html_parser.select(item, "div.authors__29e96e9287") |> List.first() |> :html_parser.text()

               href =
                  :html_parser.select(item, "a.headline__3a97424275") |> List.first() |> :html_parser.attribute("href")

               date =
                  :html_parser.select(item, "div.publishedAt__dc9dff8db4") |> List.first() |> :html_parser.text()

               article =
                  :html_parser.select(item, "a.summary__a759320e4a") |> List.first() |> :html_parser.text()

               {title, autor, href, date, article}
            end)

            Enum.each(content, fn {title, autor, href, date, article} ->
            IO.puts("Title: #{title}")
            IO.puts("Autor: #{autor}")
            IO.puts("Link: #{href}")
            IO.puts("Post info: #{date}")
            IO.puts("Article: #{article}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
            end)
      end
   end

end

Webscraping.main()
