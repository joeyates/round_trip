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
    Then I should have seen '1. My Redmine Account' on page 3

  Scenario: Add a Trello account
    Given I go to the accounts menu
    And I type 'add a Trello account'
    And I type 'My Trello Account'
    When I close the program
    Then I should have seen '1. My Trello Account' on page 3

