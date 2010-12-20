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
