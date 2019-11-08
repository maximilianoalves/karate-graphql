Feature: Api pokemon graphql

Background:

  * url "https://graphql-pokemon.now.sh/graphql"
  * def pokemon_contract = read('pokemon-contract.json')

  @pokemon @pokemon_scenario
  Scenario: Validar o pokemon Pikachu
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
    Then status 200
    And match $.data.pokemon.name == "Pikachu"

  @pokemon @pokemon_outline
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

  @pokemon @pokemon_contract
  Scenario: Validar o contrato do retorno do pokemon Pikachu
    Given def query = read('by-name.graphql')
    And def variables = { name: 'Pikachu' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match response == pokemon_contract
    * print response
    * print pokemon_contract