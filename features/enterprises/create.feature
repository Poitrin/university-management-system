Feature: Enterprises create page

  Background:
    Given the following items of type Person
      | id | first_name | surname  | login    | administrator |
      | 1  | Sylas      | Fould    | fould    | true          |
      | 2  | Bridie     | Laverack | laverack |               |
    And the following items of type Country
      | id | name_de     | name_fr   | name_en |
      | DE | Deutschland | Allemagne | Germany |
      | FR | Frankreich  | France    | France  |
    And the following items of type Address
      | id | line1     | city      | postal_code | country_id |
      | 1  | Example   | Example   | 12345       | DE         |
      | 3  | Example 3 | Example 3 | 23456       | FR         |
    And the following items of type Enterprise
      | id | name       | address_id |
      | 1  | Example    | 1          |
      | 3  | Hello Inc. | 3          |
    And the administrator with id 1 is logged in
    And the administrator has opened the enterprises page
    And the administrator has clicked on Add Enterprise

  Scenario Outline: The administrator creates a new enterprise (Happy paths)
    When the administrator enters the following data
      | enterprise_name                            | <name>        |
      | enterprise_profile                         | <profile>     |
      | enterprise_website                         | <website>     |
      | enterprise_address_attributes_line1        | <line1>       |
      | enterprise_address_attributes_postal_code  | <postal_code> |
      | enterprise_address_attributes_city         | <city>        |
      | enterprise_director_attributes_first_name  | <first_name>  |
      | enterprise_director_attributes_surname     | <surname>     |
    And the administrator selects the following options
      | enterprise_address_attributes_country_id | <country> |
    And the administrator clicks on Create Enterprise
    Then the administrator should see the success message "<success_message>"
    And the administrator should see the following information
      | name               | <name>                 |
      | profile            | <profile>              |
      | website            | <website>              |
      | line1              | <line1>                |
      | postal_code        | <postal_code>          |
      | city               | <city>                 |
      | country            | <country>              |
      | director_full_name | <first_name> <surname> |

    Examples:
      | name    | profile    | website     | line1       | postal_code | city    | country | first_name | surname | success_message                     |
      # Without director
      | Company | My profile | example.com | Main Street | 12345       | Example | Germany |            |         | Your modifications have been saved. |
      # With director
      | Company | My profile | example.com | Main Street | 12345       | Example | Germany | John       | Meyers  | Your modifications have been saved. |


  Scenario Outline: The administrator creates a new enterprise (Sad paths)
    When the administrator enters the following data
      | enterprise_name                           | <name>        |
      | enterprise_profile                        | <profile>     |
      | enterprise_website                        | <website>     |
      | enterprise_address_attributes_line1       | <line1>       |
      | enterprise_address_attributes_postal_code | <postal_code> |
      | enterprise_address_attributes_city        | <city>        |
      | enterprise_director_attributes_first_name | <first_name>  |
      | enterprise_director_attributes_surname    | <surname>     |
    And the administrator selects the following options
      | enterprise_address_attributes_country_id | <country> |
    And the administrator clicks on Create Enterprise
    Then the field should display the error message
      | enterprise_name                | <name_message>       |
      | enterprise_address_line1       | <line1_message>      |
      | enterprise_address_country_id  | <country_message>    |
      | enterprise_director_first_name | <first_name_message> |

    Examples:
      | name    | profile    | website     | line1      | postal_code | city    | country | first_name | surname | name_message   | line1_message  | country_message | first_name_message |
      # Blank required fields
      |         | My profile | example.com |             | 12345      | Example |         |            |         | can't be blank | can't be blank | can't be blank  |                    |
      # Blank required fields for director
      | Company | My profile | example.com | Main Street | 12345      | Example | Germany |            | Meyers  |                |                |                 | can't be blank     |

