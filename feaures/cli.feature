@announce
Feature: Command Line Interface
  In order to make blogging easier
  As a primarily lazy text editor junkie
  I want a nice CLI to do the heavy lifting

  Scenario: generate a new blog
    When I run "blargh new blarghing.com"
    Then the following files should exist:
      | blarghing.com/config.ru                     |
      | blarghing.com/pages/about-this-blog.textile |
      | blarghing.com/posts/1-first.textile         |

  Scenario: generate a new post
    Given this scenario is pending

  Scenario: generate a new post with a custom layout
    Given this scenario is pending

  Scenario: generate a new layout
    Given this scenario is pending

  Scenario: generate a new page
    Given this scenario is pending
