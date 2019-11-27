Feature: Api pokemon graphql

Background:

  * url "https://graphql-pokemon.now.sh/graphql"
  * def pokemon_contract = read('pokemon-contract.json')
  * def pokemon_full_data_contract = read('pokemon-full-data-contract.json')
  * def PokemonFaker = Java.type('pokeapi.java.PokemonFaker')


  @pokemon @pokemon_internal_query_pikachu @pokemon_tdc
  Scenario: Validar o pokemon Pikachu - Query interna
    Given text query =
    """
    {
      pokemon(name: "Pikachu") {
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
    """
    And request { query: '#(query)' }
    When method post
    * print response
    Then status 200
    And match $.data.pokemon.name == "Pikachu"

    # O karate possibilita a escrita de assercoes mais completas em uma linha, como:

    #validar o contrato de partes especificas do request, mesmo que sejam listas.
    * def special_contract = { "name": "#string", "type": "#string", "damage": "#number" }
    * def discharge = { "name": "Discharge", "type": "Electric", "damage": 35 }
    And match each $.data.pokemon.attacks.special == special_contract
    #ou
    And match $.data.pokemon.attacks.special == '#[] special_contract'

    #validar que um determinado conteudo existe em alguma lista do payload, sem precisar iterar.
    And match $.data.pokemon.attacks.special contains discharge

    #validar o conteudo de alguma posicao especifica de listas.
    * def payload_special_discharge = get[0] $..special[0]
    And match payload_special_discharge == discharge

    #Referenciar valores de variaveis durante a assercao, para facilitar.
    And match $.data.pokemon contains { name: "Pikachu", number: "025", attacks: { special: '#(^discharge)' }}

    #Ignorar valores ou atributos quando necessário.
    And match $.data.pokemon contains { name: "Pikachu", number: "#ignore" }

  @pokemon @pokemon_external_query_pikachu
  Scenario: Validar o pokemon Pikachu - Query externa
    Given def query = read('classpath:pokeapi/queries/pikachu-pokemon-and-attacks.graphql')
    And request { query: '#(query)' }
    When method post
    Then status 200
    And match $.data.pokemon.name == "Pikachu"

  @pokemon @pokemon_external_query_charmander
  Scenario: Validar o pokemon Charmander - Query externa
    Given def query = read('classpath:pokeapi/queries/charmander-pokemon-only-name.graphql')
    And request { query: '#(query)' }
    When method post
    Then status 200
    And match $.data.pokemon.name == "Charmander"

  @pokemon @pokemon_external_query_charmander_by_id
  Scenario: Validar o pokemon Charmander - Query externa passando id
    Given def query = read('classpath:pokeapi/queries/pokemon-only-name-by-id.graphql')
    And def variables = { id: 'UG9rZW1vbjowMDQ=' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match $.data.pokemon.name == "Charmander"

  @pokemon @pokemon_outline
  Scenario Outline: Validar pokemon <pokemon_nome>
    Given def query = read('classpath:pokeapi/queries/pokemon-and-attacks-by-name.graphql')
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

  @pokemon @pokemon_contract
  Scenario: Validar o contrato do retorno do pokemon Pikachu
    Given def query = read('classpath:pokeapi/queries/pokemon-and-attacks-by-name.graphql')
    And def variables = { name: 'Pikachu' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match response == pokemon_contract
    * print response
    * print pokemon_contract

  @pokemon @pokemon_contract_full_data
  Scenario: Validar o contrato do retorno do pokemon Pikachu
    Given def query = read('classpath:pokeapi/queries/pokemon-full-data.graphql')
    And def variables = { name: 'Pikachu' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match response == pokemon_full_data_contract
    * print response
    * print pokemon_contract

  @pokemon @pokemon_javafaker
  Scenario: Validar pokemon com retorno aleatório
    * def pokemonName = PokemonFaker.name()
    Given def query = read('classpath:pokeapi/queries/pokemon-and-attacks-by-name.graphql')
    And def variables = { name: '#(pokemonName)' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match $.data.pokemon.name == pokemonName