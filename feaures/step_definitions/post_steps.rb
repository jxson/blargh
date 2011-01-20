Then /^I should see the post(?:|s):$/ do |table|
  table.hashes.each do |hash|
    post = Blargh::Post.where(:slug => hash['slug']).first

    within("article##{ post.css_id }") do
      page.should have_content(post.title)
      page.source.should match(post.content)
    end
  end
end
