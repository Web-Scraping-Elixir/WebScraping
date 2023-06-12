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
   
end

Webscraping.main()
