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

  Scenario: view a post with a custom layout
    Given I have created a blog named "fancyschmants.com"
    And I generated a post with:
      | title                    | layout |
      | This way to awesome town | two_snakes |
    And I rackup "fancyschmants.com"
    And I follow "This way to awesome town"
    Then I should see the "THE BEST LAYOUT EVER!"
    Then I should see the post:
      | slug                      | content                     |
      | this-way-to-awesome-town  | All layout and no substance |

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

