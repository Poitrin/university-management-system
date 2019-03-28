Feature: Internships create page

  Background:
    Given the following items of type Person
      | id | first_name | surname  | login    | administrator |
      | 1  | Sylas      | Fould    | fould    | 1             |
    And the following items of type Student
      | id | first_name | surname  | login    |
      | 2  | Bridie     | Laverack | laverack |
      | 5  | Marty      | Brafield | brafield |
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
      | 4  | 5          | 3             | 1                | 2016-02-01 | 2016-06-30 | EN      |
    And the administrator with id 1 is logged in
    And the administrator has opened the internships page
    And the administrator has clicked on Add Internship

  Scenario Outline: The administrator creates a new internship (Happy paths)
    When the administrator searches and selects the following data
      | enterprise_name | <enterprise_name> |
      | student_name    | <student_name>    |
    And the administrator enters the following data
      | internship_project_description                        | <project_description>             |
      | internship_working_days_per_week                      | <working_days_per_week>           |
      | internship_working_hours_per_week                     | <working_hours_per_week>          |
      | internship_internship_origin                          | <internship_origin>               |
      | internship_payment_per_month_localized                | <payment_per_month_localized>     |
      | internship_department                                 | <department>                      |
      | internship_notes                                      | <notes>                           |
      | internship_university_supervisor_attributes_first_name | <university_supervisor_first_name> |
      | internship_university_supervisor_attributes_surname   | <university_supervisor_surname>   |
      | internship_enterprise_supervisor_attributes_first_name | <enterprise_supervisor_first_name> |
      | internship_enterprise_supervisor_attributes_surname   | <enterprise_supervisor_surname>   |
      | internship_address_attributes_line1                  | <address_line1>                  |
      | internship_address_attributes_postal_code              | <address_postal_code>              |
      | internship_address_attributes_city                    | <address_city>                    |
    And the administrator checks the following checkboxes
      | internship_project_confidential | <project_confidential> |
    And the administrator selects the following options
      | internship_programme_id                  | <programme>           |
      | internship_start_date_1i                 | <start_date_year>     |
      | internship_start_date_2i                 | <start_date_month>    |
      | internship_start_date_3i                 | <start_date_day>      |
      | internship_end_date_1i                   | <end_date_year>       |
      | internship_end_date_2i                   | <end_date_month>      |
      | internship_end_date_3i                   | <end_date_day>        |
      | internship_programme_id                  | <degree>: <programme> |
      | internship_project_description           | <project_description> |
      | internship_address_attributes_country_id | <address_country>     |
    And the administrator chooses the following options
      | internship_lang_id | <lang> |
    And the administrator clicks on Create Internship
    Then the administrator should see the success message "<success_message>"
    And the administrator should see the following information
      | name               | <name>                |
      | profile            | <profile>             |
      | website            | <website>             |
      | line1             | <line1>              |
      | postal_code         | <postal_code>          |
      | city               | <city>                |
      | country            | <country>             |
      | director_full_name | <first_name> <surname> |

    Examples:
      | enterprise_name | student_name | degree | programme | start_date_year | start_date_month | start_date_day | end_date_year | end_date_month | end_date_day | project_description | project_confidential | working_days_per_week | working_hours_per_week | internship_origin | payment_per_month_localized | lang | department | notes | university_supervisor_first_name | university_supervisor_surname | enterprise_supervisor_first_name | enterprise_supervisor_surname | address_line1 | address_postal_code | address_city | address_country |

