defmodule Webscraping do
   def main do
      IO.puts("Digite sua palavra de busca: ") # Pergunta ao usuário para digitar um termo de pesquisa.
      busca = IO.gets("") |> String.trim() # Lê a entrada do usuário e remove espaços em branco.

      # Executa as funções de scraping de forma assíncrona.
      task_g1 = Task.async(fn -> get_g1(busca) end)
      task_cnn_brasil = Task.async(fn -> get_cnn_brasil(busca) end)
      task_bloom = Task.async(fn -> get_bloom(busca) end)

      # Aguarda as tarefas serem concluídas.
      g1_news = Task.await(task_g1)
      cnn_brasil_news = Task.await(task_cnn_brasil)
      bloom_news = Task.await(task_bloom)

      news_results = g1_news ++ cnn_brasil_news ++ bloom_news # Concatena os resultados de todas as fontes de notícias.

      # HTMLGenerator.generate_html()
      HTMLGenerator.main(news_results)
   end

   def get_g1(busca) do
      IO.puts("Iniciando busca no G1") # Imprime uma mensagem indicando o início da busca G1.
      case HTTPoison.get("https://g1.globo.com/busca/?q=#{busca}") do # Envia uma solicitação HTTP GET para a URL de pesquisa do G1.
         {:ok, %HTTPoison.Response{body: body}} -> # Se a solicitação for bem-sucedida e receber uma resposta com body.
         {:ok, doc} = :html_parser.parse(body) # Analisa o corpo HTML usando uma biblioteca de análise HTML.

         content =
            :html_parser.select(doc, "li.widget--info") |> Enum.map(fn item -> # Extrai informações relevantes de cada item da lista.
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

         Enum.each(content, fn {title, href, time, description} -> # Itera sobre o conteúdo extraído e imprime os resultados.
            IO.puts("Título:: #{title}")
            IO.puts("Inicio: #{description}")
            IO.puts("Link: https:#{href}")
            IO.puts("Tempo da publicacao: #{time}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
         end)
      end
   end

   def get_cnn_brasil(busca) do
      IO.puts("Iniciando busca no CNN Brasil") # Imprime uma mensagem indicando o início da busca CNN Brasil.

      case HTTPoison.get("https://www.cnnbrasil.com.br/?s=#{busca}&orderby=date&order=desc") do # Envia uma solicitação HTTP GET para a URL de pesquisa da CNN Brasil.
         {:ok, %HTTPoison.Response{body: body}} -> # Se a solicitação for bem-sucedida e receber uma resposta com body
         {:ok, doc} = :html_parser.parse(body) # Analisa o corpo HTML usando uma biblioteca de análise HTML.

         content =
            :html_parser.select(doc, "li.home__list__item") |> Enum.map(fn item -> # Extrai informações relevantes de cada item da lista.
               title =
               :html_parser.select(item, "h3.news-item-header__title.market__new__title") |> List.first() |> :html_parser.text()

               href =
               :html_parser.select(item, "a.home__list__tag") |> List.first() |> :html_parser.attribute("href")

               date =
               :html_parser.select(item, "span.home__title__date") |> List.first() |> :html_parser.text()

               {title, href, date}
            end)

         Enum.each(content, fn {title, href, date} -> # Itera sobre o conteúdo extraído e imprime os resultados.
            IO.puts("Título:: #{title}")
            IO.puts("Link: #{href}")
            IO.puts("Informações do Post: #{date}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
         end)
      end
   end

   def get_bloom(busca) do
      IO.puts("Iniciando busca no Bloom") # Imprime uma mensagem indicando o início da busca Bloom.

      case HTTPoison.get("https://www.bloomberg.com/search?query=#{busca}") do # Envia uma solicitação HTTP GET para a URL de pesquisa da Bloomberg.
         {:ok, %HTTPoison.Response{body: body}} -> # Se a solicitação for bem-sucedida e receber uma resposta com body.
         {:ok, doc} = :html_parser.parse(body) # Analisa o corpo HTML usando uma biblioteca de análise HTML.

         content =
            :html_parser.select(doc, "div.storyItem__aaf871c1c5") |> Enum.map(fn item -> # Extrai informações relevantes de cada div.
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

         Enum.each(content, fn {title, autor, href, date, article} -> # Itera sobre o conteúdo extraído e imprime os resultados.
            IO.puts("Título:: #{title}")
            IO.puts("Autor: #{autor}")
            IO.puts("Link: #{href}")
            IO.puts("Informações do Post: #{date}")
            IO.puts("Artigo: #{article}")
            IO.puts("")
            IO.puts("------------------------------------------------------------------------------------------------------------------------")
         end)
      end
   end
end

Webscraping.main() # Chama a função main para iniciar o programa do módulo Webscraping.
