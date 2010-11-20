Feature: Command Line Interface
  In order to make blogging easier
  As a primarily lazy text editor junkie
  I want a nice CLI to do the heavy lifting

  Scenario: viewing the help
    Given this scenario is pending

  Scenario: generate a new blog
    When I run "blargh new theplank.com"
    Then the following files should exist:
      | config.ru         |
      | config/blargh.yml |
      | posts/1-first.textile |
      | public |

  Scenario: generate a new post
    Given this scenario is pending

  Scenario: generate a new page
    Given this scenario is pending

  Scenario: generate a new layout
    Given this scenario is pending
