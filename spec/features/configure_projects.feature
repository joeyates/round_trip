@highline
Feature: Configure projects
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure RoundTrip projects

  Scenario: Choose projects menu
    Given I go to the projects menu
    When I close the program
    Then I should have seen 'manage projects' on page 2

  Scenario: List projects
    Given I already have 3 projects
    And I go to the projects menu
    When I close the program
    Then I should have seen the list of projects on page 2

  Scenario: Add a project - with a name
    Given I go to the projects menu
    When I type 'add a project'
    And I type 'foobar'
    And I close the program
    Then I should have seen '1. foobar' on page 3

  Scenario: Select a Redmine account
    Given I edit an existing project
    And I already have a Redmine account called 'Redmine Stuff'
    When I type 'redmine account'
    And I type 'Redmine Stuff'
    And I close the program
    Then I should have seen 'redmine account: Redmine Stuff' on page 4

  Scenario Outline: Edit a project
    Given I edit an existing project
    When I set <Key> to '<Value>'
    And I close the program
    Then I should have seen '<Key>: <Value>' on page 4
    Examples:
      | Key                | Value     |
      | trello board id    | ae87d4567 |
      | redmine project id | 12345     |

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set trello board id to 'trololololo'
    And I type 'q'
    And I close the program
    Then I should have seen 'Exit without saving' on page 4

  Scenario: Edit a project - save
    Given I edit an existing project
    When I set trello board id to 'trololololo'
    And I type 'save'
    And I re-open the same project
    And I close the program
    Then I should have seen 'trello board id: trololololo' on page 6

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set trello board id to 'trololololo'
    And I type 'q'
    And I type 'y'
    And I re-open the same project
    And I close the program
    Then I should have seen 'trello board id: (unset)' on page 6

