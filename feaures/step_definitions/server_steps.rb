# ============================================================================
# = Given
# ============================================================================
Given /^I rackup "([^"]*)"$/ do |directory|
  # Not actually going to rackup, this is close enough...
  cd(directory)

  Blargh.config.root = current_dir
  Blargh::Server.set(:environment, :test)

  Capybara.app = Blargh::Server
end

# ============================================================================
# = When
# ============================================================================
When /^I visit "([^"]*)"$/ do |path|
  visit(path)
end

# ============================================================================
# = Then
# ============================================================================
Then /^I should see the default layout$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the post:$/ do |table|
  title = table.hashes['title']
  content = table.hashes['content']



  pending
end
