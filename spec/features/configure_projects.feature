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
    Given I already have a Redmine account called 'Redmine Stuff'
    And I edit an existing project
    When I type 'redmine account'
    And I type 'Redmine Stuff'
    And I close the program
    Then I should have seen 'redmine account: Redmine Stuff' on page 5

  @trello @redmine
  Scenario Outline: Edit a project
    Given I edit a project with accounts set
    When I set <Key> to '<Choice>'
    And I close the program
    Then I should have seen '<Key>: <Result>' on page 5
    Examples:
      | Key             | Choice     | Result   |
      | trello board    | My board   | abc12345 |
      | redmine project | My project | 12345    |

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'q'
    And I close the program
    Then I should have seen 'Exit without saving' on page 4

  Scenario: Edit a project - save
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'save'
    And I close the program
    Then I should have seen '1. Trololololo' on page 5

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'q'
    And I type 'y'
    And I close the program
    Then I should have seen text matching '1. Project \d+' on page 5

  Scenario: Set Trello list regexes
    Given I edit a project with a Trello board set
    When I type 'trello list matchers'
    And I close the program
    Then I should have seen 'Edit Trello list matchers' on page 5

