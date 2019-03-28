Feature: Enterprises index and search

  Background:
    Given the following items of type Person
      | id | first_name | surname  | login    | administrator |
      | 1  | Sylas      | Fould    | fould    | 1             |
    And the following items of type Student
      | id | first_name | surname  | login    |
      | 2  | Bridie     | Laverack | laverack |
      | 3  | Betsey     | Linge    | linge    |
      | 4  | Lanni      | Halgarth | halgarth |
      | 5  | Marty      | Brafield | brafield |
    And the following items of type Country
      | id | name_de     | name_fr   | name_en |
      | DE | Deutschland | Allemagne | Germany |
      | FR | Frankreich  | France    | France  |
      | ES | Spanien     | Espagne   | Spain   |
    And the following items of type Address
      | id | line1     | city      | postal_code | country_id |
      | 1  | Example   | Example   | 12345       | DE         |
      | 2  | Example 2 | Example 2 | 23456       | DE         |
      | 3  | Example 3 | Example 3 | 23456       | FR         |
      | 4  | Example 4 | Example 4 | 3456        | FR         |
    And the following items of type Enterprise
      | id | name         | address_id |
      | 1  | Example      | 1          |
      | 2  | Hello Corp.  | 2          |
      | 3  | Hello Inc.   | 3          |
      | 4  | Tech Company | 4          |
    And the following StudyProgram
      | id        | 1                |
      | degree    | M                |
      | name_de   | Informatik       |
      | name_fr   | Informatique     |
      | name_en   | Computer Science |
    And the following items of type Internship
      | id | student_id | enterprise_id | study_program_id | start_date | end_date   | lang_id |
      | 1  | 2          | 1             | 1                | 2014-02-01 | 2014-06-30 | EN      |
      | 2  | 5          | 1             | 1                | 2014-02-01 | 2014-06-30 | EN      |
      | 3  | 5          | 2             | 1                | 2016-02-01 | 2016-06-30 | EN      |

  Scenario: An administrator can see all enterprises
    Given the administrator with id 1 is logged in
    When the administrator opens the enterprises page
    Then the administrator should see 4 enterprises

  Scenario Outline: A student can only see the enterprises of his internships
    Given the student with id <student_id> is logged in
    When the student opens the enterprises page
    Then the student should see <enterprises_count> enterprises

    Examples:
      | student_id | enterprises_count |
      | 2          | 1                 |
      | 3          | 0                 |
      | 5          | 2                 |

  Scenario Outline: The administrator searches for enterprises
    Given the administrator with id 1 is logged in
    And the administrator has opened the enterprises page
    When the administrator searches for enterprises with name <name> and country <country>
    And the administrator clicks on Search
    Then the administrator should see the enterprises with ids <ids>

    Examples:
      | name  | country | ids |
      | Hello |         | 2,3 |
      | hElLo |         | 2,3 |
      | Ciao  |         |     |
      |       | Germany | 1,2 |
      |       | France  | 3,4 |
      |       | Spain   |     |
      | Hello | France  | 3   |