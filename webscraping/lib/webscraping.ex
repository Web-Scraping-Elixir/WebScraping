defmodule Webscraping do

  def main do
    IO.puts("Digite sua palavra de busca: ")
    busca = IO.gets("") |> String.trim()

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

    case HTTPoison.get("https://g1.globo.com/busca/?q=#{busca}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("li.widget--info")
          |> Enum.map(fn item ->
            title =
              item
              |> Floki.find("div.widget--info__text-container")
              |> Floki.find("div.widget--info__title")
              |> Floki.text()

            href =
              item
              |> Floki.find("div.widget--info__text-container")
              |> Floki.find("a")
              |> Floki.attribute("href")

            time =
              item
              |> Floki.find("div.widget--info__text-container")
              |> Floki.find("div.widget--info__meta")
              |> Floki.text()

            description =
              item
              |> Floki.find("div.widget--info__text-container")
              |> Floki.find("p.widget--info__description")
              |> Floki.text()

            {title, href, time, description}
          end)

        Enum.each(content, fn {title, href, time, description} ->
          IO.puts("                         Fonte: G1                            ")
          IO.puts("Title: #{title}")
          IO.puts("Inicio: #{description}")
          IO.puts("Link: https:#{href}")
          IO.puts("Tempo da publicacao: #{time}")
          IO.puts("")
          IO.puts(
            "------------------------------------------------------------------------------------------------------------------------"
          )
        end)
        # content
    end
  end

  def get_cnn_brasil(busca) do
    IO.puts("Iniciando busca CNN Brasil")

    case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("li.home__list__item")
          |> Enum.map(fn item ->
            title =
              item
              |> Floki.find("h3.news-item-header__title.market__new__title")
              |> Floki.text()

            href =
              item
              |> Floki.find("a.home__list__tag")
              |> Floki.attribute("href")

            date =
              item
              |> Floki.find("span.home__title__date")
              |> Floki.text()

            {title, href, date}
          end)

        Enum.each(content, fn {title, href, date} ->
          IO.puts("                         Fonte: CNN Brasil                            ")
          IO.puts("Title: #{title}")
          IO.puts("Link: #{href}")
          IO.puts("Post info: #{date}")
          IO.puts("")
          IO.puts(
            "------------------------------------------------------------------------------------------------------------------------"
          )
        end)
        # content
    end
  end

  def get_bloom(busca) do
    IO.puts("Iniciando busca Bloom")

    case HTTPoison.get("https://www.bloomberg.com/search?query=#{busca}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        content =
          body
          |> Floki.find("div.storyItem__aaf871c1c5")
          |> Enum.map(fn item ->
            title =
              item
              |> Floki.find("a.headline__3a97424275")
              |> Floki.text()

            autor =
              item
              |> Floki.find("div.authors__29e96e9287")
              |> Floki.text()

            href =
              item
              |> Floki.find("a.headline__3a97424275")
              |> Floki.attribute("href")

            date =
              item
              |> Floki.find("div.publishedAt__dc9dff8db4")
              |> Floki.text()

              article =
                item
                |> Floki.find("a.summary__a759320e4a")
                |> Floki.text()


            {title, autor, href, date, article}
          end)

        Enum.each(content, fn {title, autor, href, date, article} ->
          IO.puts("                         Fonte: Bloom                            ")
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
        # content
    end
  end
end


# defmodule HTMLGenerator do
#   def generate_html(content) do
#     template = """
#     <!DOCTYPE html>
#     <html>
#     <head>
#       <title>Resultados da busca</title>
#     </head>
#     <body>
#       <%= render_content(content) %>
#     </body>
#     </html>
#     """

#     html = EEx.eval_string(template, content: content)

#     File.write("pagina.html", html)
#   end

#   def render_content(content) do
#     Enum.map(content, fn {title, href, time, description} ->
#       """
#       <div>
#         <h2>Title: #{title}</h2>
#         <p>Inicio: #{description}</p>
#         <p>Link: #{href}</p>
#         <p>Tempo da publicacao: #{time}</p>
#       </div>
#       """
#     end) |> Enum.join()
#   end
# end

# defmodule Webscraping do
#   def get_g1 do
#     # ... código omitido ...

#     content = Enum.map(content, fn {title, href, time, description} ->
#       {title, "https:#{href}", time, description}
#     end)

#     HTMLGenerator.generate_html(content)
#   end

#   def get_cnn_brasil do
#     # ... código omitido ...

#     content = Enum.map(content, fn {title, href, date} ->
#       {title, href, date, ""}
#     end)

#     HTMLGenerator.generate_html(content)
#   end

#   def get_bloom do
#     # ... código omitido ...

#     content = Enum.map(content, fn {title, autor, href, date, article} ->
#       {title, href, date, ""}
#     end)

#     HTMLGenerator.generate_html(content)
#   end
# end

# # Chame a função correspondente para gerar a página HTML
# Webscraping.get_g1()
# # ou
# Webscraping.get_cnn_brasil()
# # ou
# Webscraping.get_bloom()


# defmodule Webscraping do
#   def main do
#     IO.puts("Digite sua palavra de busca: ")
#     busca = IO.gets("") |> String.trim()

#     task_g1 = Task.async(fn -> get_g1(busca) end)
#     task_cnn_brasil = Task.async(fn -> get_cnn_brasil(busca) end)
#     task_bloom = Task.async(fn -> get_bloom(busca) end)

#     Task.await(task_g1)
#     Task.await(task_cnn_brasil)
#     Task.await(task_bloom)
#   end

#   def get_g1(busca) do
#     IO.puts("Iniciando busca G1")
#     case HTTPoison.get("https://g1.globo.com/busca/?q=#{busca}") do
#       {:ok, %HTTPoison.Response{body: body}} ->
#         content =
#           body
#           |> Floki.find("li.widget--info")
#           |> Enum.map(fn item ->
#             Taskc(.asynfn ->
#               title =
#                 item
#                 |> Floki.find("div.widget--info__text-container")
#                 |> Floki.find("div.widget--info__title")
#                 |> Floki.text()

#                 href =
#                 item
#                 |> Floki.find("div.widget--info__text-container")
#                 |> Floki.find("a")
#                 |> Floki.attribute("href")

#                 time =
#                   item
#                   |> Floki.find("div.widget--info__text-container")
#                   |> Floki.find("div.widget--info__meta")
#                   |> Floki.text()

#               description =
#                 item
#                 |> Floki.find("div.widget--info__text-container")
#                 |> Floki.find("p.widget--info__description")
#                 |> Floki.text()

#                 {title, href, time, description}
#               end)
#           end)
#           |> Enum.map(&Task.await/1)

#         Enum.each(content, fn {title, href, time, description} ->
#           IO.puts("Title: #{title}")
#           IO.puts("Inicio: #{description}")
#           IO.puts("Link: https:#{href}")
#           IO.puts("Tempo da publicacao: #{time}")
#           IO.puts("")
#           IO.puts(
#             "------------------------------------------------------------------------------------------------------------------------"
#             )
#           end)
#         end
#   end

#   def get_cnn_brasil(busca) do
#     IO.puts("Iniciando busca CNN Brasil")

#     case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do
#       {:ok, %HTTPoison.Response{body: body}} ->
#         content =
#           body
#           |> Floki.find("li.home__list__item")
#           |> Enum.map(fn item ->
#             Task.async(fn ->
#               title =
#                 item
#                 |> Floki.find("h3.news-item-header__title.market__new__title")
#                 |> Floki.text()

#               href =
#                 item
#                 |> Floki.find("a.home__list__tag")
#                 |> Floki.attribute("href")

#                 date =
#                   item
#                   |> Floki.find("span.home__title__date")
#                   |> Floki.text()

#                   {title, href, date}
#                 end)
#               end)
#           |> Enum.map(&Task.await/1)

#         Enum.each(content, fn {title, href, date} ->
#           IO.puts("Title: #{title}")
#           IO.puts("Link: #{href}")
#           IO.puts("Post info: #{date}")
#           IO.puts("")
#           IO.puts(
#             "------------------------------------------------------------------------------------------------------------------------"
#             )
#           end)
#         end
#   end

#   def get_bloom(busca) do
#     IO.puts("Iniciando busca Bloom")

#     case HTTPoison.get("https://www.bloomberg.com/search?query=#{busca}") do
#       {:ok, %HTTPoison.Response{body: body}} ->
#         content =
#           body
#           |> Floki.find("div.storyItem__aaf871c1c5")
#           |> Enum.map(fn item ->
#             Task.async(fn ->
#               title =
#                 item
#                 |> Floki.find("a.headline__3a97424275")
#                 |> Floki.text()

#               autor =
#                 item
#                 |> Floki.find("div.authors__29e96e9287")
#                 |> Floki.text()

#               href =
#                 item
#                 |> Floki.find("a.headline__3a97424275")
#                 |> Floki.attribute("href")

#               date =
#                 item
#                 |> Floki.find("div.publishedAt__dc9dff8db4")
#                 |> Floki.text()

#               article =
#                 item
#                 |> Floki.find("a.summary__a759320e4a")
#                 |> Floki.text()

#               {title, autor, href, date, article}
#             end)
#           end)
#           |> Enum.map(&Task.await/1)

#         Enum.each(content, fn {title, autor, href, date, article} ->
#           IO.puts("Title: #{title}")
#           IO.puts("Autor: #{autor}")
#           IO.puts("Link: #{href}")
#           IO.puts("Post info: #{date}")
#           IO.puts("Article: #{article}")
#           IO.puts("")
#           IO.puts(
#             "------------------------------------------------------------------------------------------------------------------------"
#           )
#         end)
#     end
#   end
# end

# Webscraping.main()
