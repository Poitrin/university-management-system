Feature: Enterprises show page

  Background:
    Given the following items of type Person
      | id | first_name | surname  | login    | administrator |
      | 1  | Sylas      | Fould    | fould    | 1             |
    And the following items of type Student
      | id | first_name | surname  | login    |
      | 2  | Bridie     | Laverack | laverack |
      | 3  | Betsey     | Linge    | linge    |
      | 5  | Marty      | Brafield | brafield |
    And the following items of type Country
      | id | name_de     | name_fr   | name_en |
      | DE | Deutschland | Allemagne | Germany |
      | FR | Frankreich  | France    | France  |
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
    And the following StudyProgram
      | id        | 1                |
      | degree    | M                |
      | name_de   | Informatik       |
      | name_fr   | Informatique     |
      | name_en   | Computer Science |
    And the following items of type Internship
      | id | student_id | enterprise_id | study_program_id | start_date | end_date   | lang_id |
      | 1  | 2          | 1             | 1                | 2014-02-01 | 2014-06-30 | EN      |
      | 2  | 2          | 1             | 1                | 2016-02-01 | 2016-06-30 | EN      |
      | 3  | 5          | 1             | 1                | 2014-02-01 | 2014-06-30 | EN      |
      | 4  | 5          | 2             | 1                | 2016-02-01 | 2016-06-30 | EN      |

  Scenario Outline: A user can only open the enterprises and see the internships he has access to
    Given the user with id <user_id> is logged in
    And the user has opened the enterprises page
    When the user opens the enterprise with id <enterprise_id>
    Then the user should see the error message "<error>"
    And the user should be redirected to the <page> page
    And the user should see the internships with ids <internship_ids>

    Examples:
      | user_id | enterprise_id | error                                                 | page          | internship_ids |
      | 1       | 1             |                                                       | enterprises/1 | 1,2,3          |
      | 1       | 2             |                                                       | enterprises/2 | 4              |
      | 1       | 3             |                                                       | enterprises/3 |                |

      | 2       | 1             |                                                       | enterprises/1 | 1,2            |
      | 2       | 2             | You can’t access this content or execute this action. | students      |                |
      | 2       | 3             | You can’t access this content or execute this action. | students      |                |

      | 3       | 1             | You can’t access this content or execute this action. | students      |                |
      | 3       | 2             | You can’t access this content or execute this action. | students      |                |
      | 3       | 3             | You can’t access this content or execute this action. | students      |                |

      | 5       | 1             |                                                       | enterprises/1 | 3              |
      | 5       | 2             |                                                       | enterprises/2 | 4              |
      | 5       | 3             | You can’t access this content or execute this action. | students      |                |