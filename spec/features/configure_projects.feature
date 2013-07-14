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

  Scenario: Check Redmine project
    Given I edit a project with a badly configured Redmine project set
    When I type 'check redmine project'
    Then I should see 'Please add an Ideas tracker to the Redmine installation'

  Scenario: View Trello list matchers
    Given I edit a project with a Trello board set
    When I type 'trello list matchers'
    Then I should see 'configure lists'

  Scenario Outline: Edit Trello list matchers
    Given I edit Trello list matchers
    When I type '<Area>'
    And I type '<Matcher>'
    Then I should see text matching '<Area>\s+| <Matcher>\s'
    Examples:
      | Area    | Matcher |
      | ideas   | foo     |
      | backlog | bar aaa |
      | done    | baz     |

  Scenario: Save Trello list matchers
    Given I edit Trello list matchers
    When I type 'ideas'
    And I type 'foo'
    And I type 'save'
    Then I should see text matching '1. Project \d+'

  Scenario: Edit Trello list matchers - quit without saving
    Given I edit Trello list matchers
    When I type 'ideas'
    And I type 'foo'
    And I type 'quit'
    Then I should see 'Exit without saving'

