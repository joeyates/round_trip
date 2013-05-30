Feature: Configure projects
  In order to synchronise a Trello board and a Redmine project
  As a RoundTrip administrator
  I want to configure RoundTrip projects

  Scenario: List projects
    Given I have started the configurator
    And I already have some projects
    Then I should see the list of projects

  Scenario: Add a project
    Given I have started the configurator
    And I have chosen 'Add project'
    When I call the project 'foobar'
    And I exit the project
    Then 'foobar' should be in the list

