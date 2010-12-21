@announce
Feature: Posts
  In order to provide a vehicle to disseminate random content
  As a content author
  I want to publish posts

  Scenario: view a post
    Given I have created a blog named "theplank.com"
    And I rackup "theplank.com"
    When I visit "/posts/first-post"
    Then I should see the default layout
    Then I should see the post:
      | slug        | content                             |
      | first-post  | You should probably edit this file: |

  Scenario: create a post
    Given this scenario is pending

  Scenario: view all posts
    Given this scenario is pending

  Scenario: paginate through a few posts
    Given this scenario is pending


  Scenario: edit a post
    Given this scenario is pending

  Scenario: delete a post
    Given this scenario is pending

