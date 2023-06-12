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
end

Webscraping.main()
