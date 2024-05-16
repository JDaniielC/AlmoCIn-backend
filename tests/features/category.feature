Feature: Manipulate Categories

  As a user with permission to manipulate Categories
  I want to be able to create, update and delete Categories
  So that I can manage the Categories in the system

  A Category is a way to group similar items together

  Background: User with permission to manipulate Categories
    Given the user has logged with username "admin" and password "admin"
    And the user has logged as "admin" with permission to manipulate Categories
    And the following Categories exist:
      | Name        |
      | Promotion   |
      | Drinks      |
      | Vegetarian  |
      | Desserts    |
      | Appetizers  |

  Scenario: Create a new Category
    When the user do a request POST to "/categories" with the following data:
      """
      {
        "Name": "Main Course"
      }
      """
    Then the response status should be 201
    And the response body should be:
      """
      {
        "message": "Categoria 'Main Course' criada com sucesso"
      }
      """
    And the categories list should be:
      | Name        |
      | Promotion   |
      | Drinks      |
      | Vegetarian  |
      | Desserts    |
      | Appetizers  |
      | Main Course |

  Scenario: Update an existing Category
    When the user do a request PUT to "/categories/Drinks" with the following data:
      """
      {
        "Name": "Main Course"
      }
      """
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Categoria 'Drinks' atualizada para 'Main Course' com sucesso"
      }
      """
    And the categories list should be:
      | Name        |
      | Promotion   |
      | Main Course |
      | Vegetarian  |
      | Desserts    |
      | Appetizers  |

  Scenario: Delete an existing Category
    When the user do a request DELETE to "/categories/Promotion"
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Categoria 'Promotion' deletada com sucesso"
      }
      """
    And the categories list should be:
      | Name        |
      | Drinks      |
      | Vegetarian  |
      | Desserts    |
      | Appetizers  |

  Scenario: Delete a Category with items
    Given the following Items exist:
      | Name        | Category    |
      | Water       | Drinks      |
      | Soda        | Drinks      |
      | Potato      | Vegetarian  |
    When the user deletes the Category "Drinks"
    Then the response status should be 400
    And the response body should be:
      """
      {
        "message": "Categoria 'Drinks' não pode ser deletada pois possui itens associados"
      }
      """
    And the categories list should be the same as before

  Scenario: Create a Category with the same name
    When the user do a request POST to "/categories" with the following data:
      """
      {
        "Name": "Drinks"
      }
      """
    Then the response status should be 400
    And the response body should be:
      """
      {
        "message": "Categoria 'Drinks' já existe"
      }
      """
    And the categories list should be the same as before

  Scenario: Update a Category with the same name
    When the user do a request PUT to "/categories/Drinks" with the following data:
      """
      {
        "Name": "Vegetarian"
      }
      """
    Then the response status should be 400
    And the response body should be:
      """
      {
        "message": "Categoria 'Vegetarian' já existe"
      }
      """
    And the categories list should be the same as before

  Scenario: Delete a non-existing Category
    When the user do a request DELETE to "/categories/Non-existing"
    Then the response status should be 400
    And the response body should be:
      """
      {
        "message": "Categoria 'Non-existing' não existe"
      }
      """
    And the categories list should be the same as before

  Scenario: List Categories
    When the user do a request GET to "/categories"
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Categorias listadas com sucesso",
        "categories": [
          {
            "Name": "Promotion"
          },
          {
            "Name": "Drinks"
          },
          {
            "Name": "Vegetarian"
          },
          {
            "Name": "Desserts"
          },
          {
            "Name": "Appetizers"
          }
        ]
      }
      """

  Scenario: List Categories with no Categories
    When the user do a request DELETE to "/categories"
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Categorias listadas com sucesso",
        "categories": []
      }
      """

  Scenario: List items of a Category
    Given the following Items exist:
      | Name        | Category    |
      | Water       | Drinks      |
      | Soda        | Drinks      |
      | Potato      | Vegetarian  |
    When the user do a request GET to "/categories/Drinks"
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Itens da Categoria 'Drinks' listados com sucesso",
        "items": [
          {
            "Name": "Water",
            "Category": "Drinks"
          },
          {
            "Name": "Soda",
            "Category": "Drinks"
          }
        ]
      }
      """

  Scenario: List items of a non-existing Category
    When the user do a request GET to "/categories/Non-existing"
    Then the response status should be 400
    And the response body should be:
      """
      {
        "message": "Categoria 'Non-existing' não existe"
      }
      """

  Scenario: List items of a Category with no items
    When the user do a request GET to "/categories/Desserts"
    Then the response status should be 200
    And the response body should be:
      """
      {
        "message": "Itens da Categoria 'Desserts' listados com sucesso",
        "items": []
      }
      """