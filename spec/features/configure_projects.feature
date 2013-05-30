@highline
Feature: Configure projects
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure RoundTrip projects

  Scenario: List projects
    Given I have started the configurator
    And I already have 3 projects
    Then I should see the list of projects

  Scenario: Add a project - and cancel
    Given I have started the configurator
    And I have chosen 'add a project'
    When I type enter
    Then I should see the list of projects

  Scenario: Add a project - with a name
    Given I have started the configurator
    And I have chosen 'add a project'
    When I type 'foobar'
    Then 'foobar' should be in the list

