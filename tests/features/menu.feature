#language: en

Feature: Manipulate menu

  As a user with permission to manipulate menu items
  I want to add, remove and update a new item
  So that i can manipulate menu items

  The information of an item is:
    - Name
    - Price
    - Description
    - Image
    - Category
    - Availability

  Background: User with permission to manipulate the menu
    Given the user has logged with username "admin" and password "admin"
    And the user has logged as "admin" with permission to manipulate Categories

  Scenario: Add a new item to the menu
    Given that there are no items registered
    When the user do a request POST to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": 10.00,
        "description": "Not the fried",
        "image": "None",
        "category": "Promotion",
        "availability": "0 minutes"
      }
      """
    Then the response status code is 201
    And the response body is:
      """
      {
        "message": "Item Potato added to the menu"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |

  Scenario: Update an item from the menu
    Given that there is an item registered with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    And the required information to update is "name"
    When the user do a request PUT to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": 15.00,
      }
      """
    Then the response status code is 200
    And the response body is:
      """
      {
        "message": "Item Potato updated in the menu"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 15.00 | Not the fried   | None  | Promotion | 0 minutes   |

  Scenario: Remove an item from the menu
    Given that there is an item registered with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    When the user do a request DELETE to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato"
      }
      """
    Then the response status code is 200
    And the response body is:
      """
      {
        "message": "Item Potato removed from the menu"
      }
      """
    And the items list is:
      | Name | Price | Description | Image | Category | Availability |

  Scenario: Add an item without name or price to the menu
    Given that there aren't items registered
    When the user do a request POST to the endpoint "/menu" with the information:
      """
      {
        "price": 10.00,
        "description": "Not the fried",
        "image": "None",
        "category": "Promotion",
        "availability": "0 minutes"
      }
      """
    Then the item is not added to the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The name is required"
      }
      """
    When the user do a request POST to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "description": "Not the fried",
        "image": "None",
        "category": "Promotion",
        "availability": "0 minutes"
      }
      """
    Then the item is not added to the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The price is required"
      }
      """
    And the items list is:
      | Name | Price | Description | Image | Category | Availability |

  Scenario: Update an item with invalid information
    Given that there is an item registered with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    When the user do a request PUT to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": "Letter",
      }
      """
    Then the item "Potato" is not updated in the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The price must be a number"
      }
      """
    When the user do a request PUT to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": -10.00,
      }
      """
    Then the item "Potato" is not updated in the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The price must be greater than zero"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
  
  Scenario: Remove an item that does not exist in the menu
    Given that there are no items registered
    When the user do a request DELETE to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato"
      }
      """
    Then the response status code is 404
    And the response body is:
      """
      {
        "message": "Item Potato does not exist in the menu"
      }
      """
    And the items list is:
      | Name | Price | Description | Image | Category | Availability |

  Scenario: Try to send no information to add an item
    Given that there are no items registered
    When the user do a request POST to the endpoint "/menu" with no payload:
    Then the item is not added to the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The name is required, the price is required"
      }
      """

  Scenario: Try to send no information to update an item
    Given that there is an item with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    When the user do a request PUT to the endpoint "/menu" with no payload
    Then the item "Potato" is not updated in the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The name is required"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    
  Scenario: Add an existing item to the menu
    Given that there is an item with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    When the user do a request POST to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": 00.00,
        "description": "Already exist",
        "image": "None",
        "category": "Fries",
        "availability": "0 minutes"
      }
      """
    Then the item is not added to the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "Item Potato already exist in the menu"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |

  Scenario: Add an item with invalid category to the menu
    Given that there are no items registered
    When the user do a request POST to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": 10.00,
        "description": "Not the fried",
        "image": "None",
        "category": "Invalid",
        "availability": "0 minutes"
      }
      """
    Then the item is not added to the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The category is invalid"
      }
      """

  Scenario: Update an item with invalid category
    Given that there is an item with the information:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    When the user do a request PUT to the endpoint "/menu" with the information:
      """
      {
        "name": "Potato",
        "price": 10.00,
        "category": "Invalid"
      }
      """
    Then the item "Potato" is not updated in the menu
    And the response status code is 400
    And the response body is:
      """
      {
        "message": "The category is invalid"
      }
      """
    And the items list is:
      | Name   | Price | Description     | Image | Category | Availability |
      | Potato | 10.00 | Not the fried   | None  | Promotion | 0 minutes   |
    