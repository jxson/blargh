Then /^I should see the post(?:|s):$/ do |table|
  table.hashes.each do |hash|
    post = Blargh::Post.where(:slug => hash['slug']).first

    within("article##{ post.css_id }") do

    end
  end
  # title = table.hashes['title']
  # content = table.hashes['content']



  pending
end
