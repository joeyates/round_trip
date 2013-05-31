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
    Given I have chosen to edit a project
    When I set <Key> to '<Value>'
    And I close the program
    Then I should have seen '<Key>: <Value>' on page 3
    Examples:
    | Key          | Value                       |
    | trello key   | 123stella                   |
    | trello token | secret                      |
    | redmine url  | https://example.com/redmine |

