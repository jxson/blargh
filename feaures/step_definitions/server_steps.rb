Given /^I rackup "([^"]*)"$/ do |directory|
  Blargh::Server.set(:environment, :test)

  Capybara.app = Rack::Builder.new {
    run Blargh::Server
  }.to_app
end

When /^I visit "([^"]*)"$/ do |path|
  visit(path)
end

Then /^I should see the post:$/ do |table|
  title = table.hashes['title']
  content = table.hashes['content']



  pending
end