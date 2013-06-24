@highline
Feature: Configure accounts
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure Trello and Redmine accounts

  Scenario: Choose accounts menu
    Given I go to the accounts menu
    When I close the program
    Then I should have seen 'manage accounts' on page 2

  Scenario: Add a Redmine account
    Given I go to the accounts menu
    And I type 'add a Redmine account'
    And I type 'My Redmine Account'
    When I close the program
    Then I should have seen '1. My Redmine Account (Redmine)' on page 3

  Scenario: Add a Trello account
    Given I go to the accounts menu
    And I type 'add a Trello account'
    And I type 'My Trello Account'
    When I close the program
    Then I should have seen '2. My Trello Account (Trello)' on page 3

  Scenario: Edit a Redmine account
    Given I already have a Redmine account called 'Redmine Stuff'
    And I go to the accounts menu
    And I type 'Redmine Stuff'
    When I close the program
    Then I should have seen 'edit Redmine account: Redmine Stuff' on page 3

  Scenario Outline: Edit Redmine account configuration
    Given I edit an existing Redmine account
    When I set <Key> to '<Value>'
    And I close the program
    Then I should have seen '<Key>: <Value>' on page 4
    Examples:
      | Key         | Value                      |
      | redmine url | http://redmine.example.com |
      | redmine key | foo123                     |

  Scenario: Edit a Trello account
    Given I already have a Trello account called 'Trello Stuff'
    And I go to the accounts menu
    And I type 'Trello Stuff'
    When I close the program
    Then I should have seen 'edit Trello account: Trello Stuff' on page 3

  Scenario Outline: Edit Trello account configuration
    Given I edit an existing Trello account
    When I set <Key> to '<Value>'
    And I close the program
    Then I should have seen '<Key>: <Value>' on page 4
    Examples:
      | Key           | Value     |
      | trello key    | key123    |
      | trello secret | secret123 |
      | trello token  | token123  |

  @redmine
  Scenario: Test a Redmine connection
    Given I edit an existing Redmine account
    When I type 'test Redmine connection'
    And I close the program
    Then I should have seen 'It works' on page 3

