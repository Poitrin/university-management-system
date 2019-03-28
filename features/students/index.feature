Feature: Students index / search page

  Background:
    Given the following items of type Person
      | id | first_name | surname   | login    | administrator |
      | 1  | Sylas      | Fould     | fould    | 1             |
    And the following items of type Student
      | id | first_name | surname   | login    |
      | 2  | Bridie     | Laverack  |          |
      | 3  | Betsey     | Linge     |          |
      | 4  | Lanni      | Halgarth  |          |
      | 5  | Marty      | Brafield  | brafield |
      | 6  | Talya      | Rouzet    |          |
      | 7  | Kass       | Showt     |          |
      | 8  | Crissy     | Pietsma   |          |
      | 9  | Randall    | McKiernan |          |
      | 10 | Marie      | Heindle   |          |

  Scenario: An administrator can see all student profile links
    Given the administrator with id 1 is logged in
    When the administrator opens the students page
    Then the administrator should see 9 students
    And the administrator should see 9 student profile links

  Scenario: A student can only see the link to his own profile
    Given the student with id 5 is logged in
    When the student opens the students page
    Then the student should see 9 students
    But the student should see 1 student profile link

  Scenario: An administrator can open all student profiles
    Given the administrator with id 1 is logged in
    When the administrator opens the student with id 7
    Then the administrator should see the profile page of student with id 7

  Scenario: A student can only open his own profile
    Given the student with id 5 is logged in
    When the student opens the student with id 5
    Then the student should see the profile page of student with id 5

  Scenario: A student can not open another student profile
    Given the student with id 5 is logged in
    When the student opens the student with id 7
    Then the student should be redirected to the students page
    And the student should see the error message "You can’t access this content or execute this action."