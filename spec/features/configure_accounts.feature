@highline
Feature: Configure accounts
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure Trello and Redmine accounts

  Scenario: Choose accounts menu
    When I go to the accounts menu
    Then I should see 'manage accounts'

  Scenario: Add a Redmine account
    Given I go to the accounts menu
    And I type 'add a Redmine account'
    When I type 'My Redmine Account'
    Then I should see '1. My Redmine Account (Redmine)'

  Scenario: Add a Trello account
    Given I go to the accounts menu
    When I type 'add a Trello account'
    And I type 'My Trello Account'
    Then I should see '2. My Trello Account (Trello)'

  Scenario: List Redmine accounts
    Given I already have a Redmine account called 'Redmine Stuff'
    And I go to the accounts menu
    Then I should see '1. Redmine Stuff'

  Scenario: Edit a Redmine account
    Given I already have a Redmine account called 'Redmine Stuff'
    And I go to the accounts menu
    When I type 'Redmine Stuff'
    Then I should see 'edit Redmine account: Redmine Stuff'

  Scenario Outline: Edit Redmine account configuration
    Given I edit an existing Redmine account
    When I set <Key> to '<Value>'
    Then I should see '<Key>: <Value>'
    Examples:
      | Key         | Value                      |
      | redmine url | http://redmine.example.com |
      | redmine key | foo123                     |

  Scenario: Edit a Trello account
    Given I already have a Trello account called 'Trello Stuff'
    And I go to the accounts menu
    When I type 'Trello Stuff'
    Then I should see 'edit Trello account: Trello Stuff'

  Scenario Outline: Edit Trello account configuration
    Given I edit an existing Trello account
    When I set <Key> to '<Value>'
    Then I should see '<Key>: <Value>'
    Examples:
      | Key           | Value     |
      | trello key    | key123    |
      | trello secret | secret123 |
      | trello token  | token123  |

  Scenario: Test a Redmine connection
    Given I edit an existing Redmine account
    When I type 'test Redmine connection'
    Then I should see 'It works'

  Scenario: Test a Trello connection
    Given I edit an existing Trello account
    When I type 'test Trello connection'
    Then I should see 'It works'

