@highline
Feature: Configure projects
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure RoundTrip projects

  Scenario: Choose projects menu
    When I go to the projects menu
    Then I should see 'manage projects'

  Scenario: List projects
    Given I already have 3 projects
    When I go to the projects menu
    Then I should see the list of projects

  Scenario: Add a project - with a name
    Given I go to the projects menu
    When I type 'add a project'
    And I type 'foobar'
    Then I should see '1. foobar'

  Scenario: Select a Redmine account
    Given I already have a Redmine account called 'Redmine Stuff'
    And I edit an existing project
    When I type 'redmine account'
    And I type 'Redmine Stuff'
    Then I should see 'redmine account: Redmine Stuff'

  Scenario Outline: Edit a project
    Given I edit a project with accounts set
    When I set <Key> to '<Choice>'
    Then I should see '<Key>: <Result>'
    Examples:
      | Key             | Choice     | Result   |
      | trello board    | My board   | abc12345 |
      | redmine project | My project | 12345    |

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'q'
    Then I should see 'Exit without saving'

  Scenario: Edit a project - save
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'save'
    Then I should see '1. Trololololo'

  Scenario: Edit a project - quit without saving
    Given I edit an existing project
    When I set name to 'Trololololo'
    And I type 'q'
    And I type 'y'
    Then I should see text matching '1. Project \d+'

  Scenario: Set Trello list regexes
    Given I edit a project with a Trello board set
    When I type 'trello list matchers'
    Then I should see 'configure list matchers'

