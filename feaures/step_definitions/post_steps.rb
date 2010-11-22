Given /^I have created a blog named "([^"]*)"$/ do |name|
  steps %Q{
    When I run "blargh new #{ name }"
    And I cd to "#{ name }"
  }
end
