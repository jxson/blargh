# ============================================================================
# = Given
# ============================================================================
Given /^this scenario is pending$/ do
  pending
end

Given /^I have created a blog named "([^"]*)"$/ do |name|
  steps %Q{
    When I run "blargh new #{ name }"
  }
end

# ============================================================================
# = Then
# ============================================================================
Then /^I should see the default layout$/ do
  within('header') do
    page.should have_css('#logo')

    within('nav') do
      page.should have_css('a', :text => 'Home')
      page.should have_css('a', :text => 'About')
    end
  end

  page.should have_css('.content')

  within('footer') do
    within('nav') do
      page.should have_css('a', :text => 'Home')
      page.should have_css('a', :text => 'About')
    end

    within('#nerd-olympics') do
      page.should have_css('a', :text => 'html5')
      page.should have_css('a', :text => 'css')
      page.should have_css('a', :text => 'Blargh!')
    end
  end
end
