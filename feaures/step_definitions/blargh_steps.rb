Given /^this scenario is pending$/ do
  pending
end

Given /^I have created a blog named "([^"]*)"$/ do |name|
  steps %Q{
    When I run "blargh new #{ name }"
  }
end