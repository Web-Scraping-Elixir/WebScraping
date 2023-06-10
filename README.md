# Web Scraping em Elixir

## Alunos
- Thiago Gariani Quinto - RA: 2388898
-  Pamella Lissa - RA:
- Breno Farias da Silva - RA: 

## Dependências
As dependências do projeto estão no arquivo `mix.exs`. Para instalar as dependências, execute o comando `mix deps.get`, como no exemplo abaixo:

```bash
$ mix deps.get
```

## Executando o projeto
Uma vez instaladas as dependências, o próximo passo é acessar o console do Elixir, com o comando `iex -S mix`, como no exemplo abaixo:

```bash
$ iex -S mix
```
Após acessar o console, execute o comando `WebScraping.{nome_da_função_definida_no_módulo_do_projeto}`, o arquivo do projeto se encontra [aqui](./webscraping/lib/webscraping.ex), dessa forma, o comando a ser realizado seguindo a configuração atual é:

```bash
$ WebScraping.main
```

Com tal comando, o usuário poderá realizar a busca com as notícias relacionadas à sua palavra de busca.
