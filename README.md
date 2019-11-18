# Karate + GraphQL
Projeto de exemplo para implementação de testes para API's GraphQL utilizando o Karate DSL. 

## Ferramentas utilizadas:
- [VSCode](https://code.visualstudio.com/ "VSCode") / [IntelliJ CE](https://www.jetbrains.com/idea/download/ "IntelliJ CE")
- [Karate DSL](https://intuit.github.io/karate "Karate DSL")
- [Pokemon GraphQL API Fake](https://graphql-pokemon.now.sh/graphql "Pokemon GraphQL API Fake")

## Recursos utilizados no projeto
- **KARATE**
	- url
	- def
	- read
	- request
	- method
	- status
	- match
	- response
	- print
	- **text** (mais importante neste contexto)
- **JAVA**
	- Faker
	- JUnit4

## Estrutura de pastas
```
.
├── src
│   └── test
│       └── java
│           ├── pokeapi
│           │   ├── java
│           │   │   ├── BaseRunner.java
│           │   │   └── PokemonFaker.java
│           │   ├── PokeApiTest.java
│           │   ├── Pokemon.feature
│           │   ├── by-name.graphql
│           │   └── pokemon-contract.json
│           ├── karate-config.js
│           └── logback-test.xml
├── README.md
└── pom.xml

```

Considerando este contexto, onde o objetivo é testar uma API GraphQL, os principais arquivos são: Pokemon.feature e by-name.graphql. 

No arquivo Pokemon.feature temos a implementação dos testes, assim como as devidas validações de status, contrato e regras de negócio. Veja um exemplo:

```
  Scenario Outline: Validar pokemon <pokemon_nome>
    Given def query = read('by-name.graphql')
    And def variables = { name: '<pokemon_nome>' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match $.data.pokemon.name == '<pokemon_nome>'
    * print 'response:', response

    Examples:
    |pokemon_nome|
    |Pikachu     |
    |Charmander  |
    |Squirtle    |
    |Charizard   |

```

Como visto no exemplo acima, para permitir o reaproveitamento de código, salvamos as queries em arquivos externos e referenciamos estes durante o teste utilizando os comandos def & read. No exemplo, o arquivo com a query é o by-name.graphql:

```
query PokemonAndAttacks($name: String) {
    pokemon(name: $name) {
        id
        number
        name
        attacks {
            special {
                name
                type
                damage
            }
        }
    }
}
```

Nos demais arquivos temos implementações auxiliares, como: funções comuns para execução e geração de relatórios, geração de nomes de pokemons de forma aleatória, contrato de api utilizado para asserções durante o teste e arquivos de configurações do Karate DSL.

------------




