defmodule HTMLGenerator do
   def main (content) do
      header = generate_html(content)
      news = generate_list_items(content)
      html = header ++ news
      File.write("news.html", html)
   end

   def generate_html(content) do
      "<html>
         <head>
         <title>List of Information</title>
         </head>
         <body>
         <h1>List of Information</h1>
         <ul>
            #{generate_list_items(content)}
         </ul>
         </body>
      </html>"
   end

   defp generate_list_items(content) do
      Enum.map(content, fn {title, start, link, publication_time} ->
         "<li>
         <strong>Título:</strong> #{title}<br>
         <strong>Início:</strong> #{start}<br>
         <strong>Link:</strong> <a href=\"#{link}\">#{link}</a><br>
         <strong>Tempo da publicacao:</strong> #{publication_time}
         </li>"
      end)
      |> Enum.join("\n")
   end
end
