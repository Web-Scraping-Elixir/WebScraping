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
Unfortunately, due to the fact the elixir has it's own interactive shell, it's not to automate the execution of the project using Makefile.
So, with that in mind, to run the project, make sure you did the installation steps and then run the following commands:
```elixir  
iex -S mix  
Webscraping.main  
```
After that, the program will ask you to enter a topic and then it will print the news of the three websites related to the topic you entered.
```
Digite sua palavra de busca: insertYourTopicHere
```

## Elixir Great Features:
- **Functional Programming:** Elixir is a functional programming language, which means that it focuses on the evaluation of expressions rather than execution of commands. In other words, it is a declarative language, which means that it focuses on what to solve rather than how to solve it.
- **Imutability:** Elixir is immutable, which means that once a variable is assigned a value, it cannot be changed. This is a great feature because it makes the code more predictable and easier to debug.
- **High-order functions:** Elixir supports high-order functions, which means that functions can be passed as arguments to other functions and functions can return other functions as results. Examples: `Enum.map/2`, `Task.async`, `Task.await`.
- **Pure functions:** Elixir functions are pure, which means that they do not have side effects. This is a great feature because it makes the code more predictable and easier to debug. Examples: `IO.puts`, `get_g1/1`, `get_cnn_brasil/1` e `get_bloom/1`.
- **Concurrency:** Elixir supports concurrency, which means that it can run multiple processes at the same time. This is a great feature because it makes the code more efficient and easier to debug.
- **Object-Oriented Programming:** Elixir supports object-oriented programming, which means that it can use objects to represent data and methods to manipulate that data. This is a great feature because it makes the code more reusable and easier to debug.
- **Easy Syntax:** Elixir has a very easy syntax, which means that it is easy to learn and use. This is a great feature because it makes the code more readable and easier to debug. For example, private methods are defined using the `defp` keyword, which makes it easy to identify them.


## Functions:
- `IO.puts` - IO.puts(text) - Prints the given text to the console.
- `ÌO.gets` - IO.gets() - Reads a line from the console.
- `Enum.map/2` - Enum.map(collection, fun) - Returns a new list with fun applied to each entry in the collection.
- `Task.async` - Task.async(fun) - Starts a new task that will invoke fun and return its result as a Task struct immediately.
- `Task.await` - Task.await(task) - Awaits the result of a task and returns it.
- `HTTPoison.get` - HTTPoison.get(url) - Performs a GET request to the given url.
- `Floki.find` - Floki.find(html, selector) - Returns the first element in the html that matches the given selector.
- `Floki.text` - Floki.text(html) - Returns the text content of the given html.
- `Floki.attribute` - Floki.attribute(html, attribute) - Returns the value of the given attribute in the html.
- `Crawly.fetch` - Crawly.fetch(url) - Fetch ther request for a specified URL.

## External Libraries:
- [Crawly](https://github.com/elixir-crawly/crawly) - Crawly is an application framework for crawling web pages and extracting structured data which can be used for a wide range of useful applications, like data mining, information processing or historical archival.
- [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html) - HTTPoison is an HTTP client for Elixir, which supports the HTTP protocol for requests and responses.
- [Floki](https://github.com/philss/floki) - Floki is a simple HTML parser that enables search for nodes using CSS selectors.

## Alternatives:
- [Floki Alternatives](https://elixir.libhunt.com/floki-alternatives):  
	**[Meeseeks](https://github.com/mischov/meeseeks)** - Meeseeks is a library for scraping and parsing web pages which is an alternative to Floki.
- [HTTPoison Alternatives](https://elixir.libhunt.com/httpoison-alternatives):  
