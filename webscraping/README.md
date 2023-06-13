# [Webscraping](https://github.com/Web-Scraping-Elixir)
This project was  develop to learn the functional programming languages and its main features. The project consists of a webscraping that gets the news of three news websites, according to a given topic inserted by the user. The websites used are:
- [G1](https://g1.globo.com/)
- [CNN Brasil](https://www.cnnbrasil.com.br/)
- [Bloom](https://www.bloomberg.com/)  
  
The project was developed using the Elixir language and its main features are:
- [x] Functional programming.
- [x] Parallelism using Tasks.
- [x] HTTP requests.
- [x] HTML parsing.

## Installation
In order to install Elixir on your machine, follow the official documentation [here](https://elixir-lang.org/install.html).
On Unix-based systems with `apt-get` package manager, you can simply run the following command:
```bash
sudo apt-get install elixir -y
```
Also, you need to install de project dependencies located in the `mix.exs` file:
```elixir
mix deps.get
```

## How to run:
To run the project, make sure you did the installation steps and then run the following commands:
```elixir  
iex -S mix  
Webscraping.main  
```

## Functions:
- `ÌO.puts` - IO.puts(text) - Prints the given text to the console.
- `ÌO.gets` - IO.gets() - Reads a line from the console.
- `Enum.map/2` - Enum.map(collection, fun) - Returns a new list with fun applied to each entry in the collection.
- `Task.async` - Task.async(fun) - Starts a new task that will invoke fun and return its result as a Task struct immediately.
- `Task.await` - Task.await(task) - Awaits the result of a task and returns it.
- `HTTPoison.get` - HTTPoison.get(url) - Performs a GET request to the given url.
- `Floki.find` - Floki.find(html, selector) - Returns the first element in the html that matches the given selector.
- `Floki.text` - Floki.text(html) - Returns the text content of the given html.
- `Floki.attribute` - Floki.attribute(html, attribute) - Returns the value of the given attribute in the html.

## Libraries used:
- [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html) - HTTPoison is an HTTP client for Elixir, which supports the HTTP protocol for requests and responses.
- [Floki](https://github.com/philss/floki) - Floki is a simple HTML parser that enables search for nodes using CSS selectors.