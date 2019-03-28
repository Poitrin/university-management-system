Feature: Log in to / log out of the application

  Background:
    Given the following items of type Address
      | id | line1   | city    | postal_code | country_id |
      | 1  | Example | Example | 12345       | DE         |
      | 3  | Example | Example | 12345       | DE         |
    And the following items of type Person
      | id | login        | password | administrator | first_name | surname | private_email     | business_email    |
      | 1  | admin        | init     | 1             | Ad         | Min     | admin@example.com |                   |
      | 2  | withoutemail | init     | 0             | Stu        | Dent    |                   |                   |
      | 3  |              | init     | 0             | Per        | Son     |                   | without@login.com |

  Scenario Outline: The administrator logs in with his credentials
    When the user is on the homepage
    And the user logs in with <login> and <password>
    Then the field should display the error message
      | session_user_name | <login_message>    |
      | session_password  | <password_message> |
    And the user should be redirected to the <page> page

    Examples:
      | login             | password        | login_message  | password_message | page     |
      |                   |                 | can't be blank | can't be blank   | login    |
      | admin             |                 |                | can't be blank   | login    |
      | invaliduser       |                 | is invalid     | can't be blank   | login    |
      | invaliduser       | invalidpassword | is invalid     |                  | login    |
      | admin             | invalidpassword |                | is invalid       | login    |
      | admin@example.com | invalidpassword |                | is invalid       | login    |
      | admin             | init            |                |                  | students |
      | withoutemail      | init            |                |                  | students |
      | without@login.com | init            |                |                  | students |

  Scenario Outline: Only students can open their profile page
    Given the user is on the homepage
    When the user logs in with <login> and <password>
    Then the user name should only be a link to <link> for students

    Examples:
      | login        | password | link        |
      | admin        | init     |             |
      | withoutemail | init     | /students/2 |

  Scenario: The administrator logs out
    Given the user is on the homepage
    And the user logs in with admin and init
    When the user clicks on Logout
    Then the user should be redirected to the homepage
    And the user should see the success message "You have been logged out."