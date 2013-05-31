@highline
Feature: Configure projects
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure RoundTrip projects

  Scenario: List projects
    Given I already have 3 projects
    When I close the program
    Then I should have seen the list of projects on page 1

  Scenario: Add a project - with a name
    Given I type 'add a project'
    When I type 'foobar'
    And I close the program
    Then I should have seen '1. foobar' on page 2

  Scenario Outline: Edit a project
    Given I edit an existing project
    When I set <Key> to '<Value>'
    And I close the program
    Then I should have seen '<Key>: <Value>' on page 3
    Examples:
    | Key                 | Value                       |
    | name                | new_name                    |
    | trello key          | 123stella                   |
    | trello token        | secret                      |
    | trello board_id     | ae87d4567                   |
    | redmine url         | https://example.com/redmine |
    | redmine project_id  | 12345                       |

  Scenario: Edit a project - save
    Given I edit an existing project
    When I set trello key to 'trololololo'
    And I type 'save'
    And I re-open the same project
    And I close the program
    Then I should have seen 'trello key: trololololo' on page 6

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set trello key to 'trololololo'
    And I type 'q'
    And I re-open the same project
    And I close the program
    Then I should have seen 'trello key: (unset)' on page 6

