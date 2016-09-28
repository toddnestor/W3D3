# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

emails = [
  'abc@gmail.com',
  'sdf@gmail.com',
  'tree@gmail.com'
]

emails.each do |email|
  User.create!(email: email)
end

urls = [
  {long_url: 'google.com', short_url: 'a'},
  {long_url: 'yahoo.com', short_url: 'b'},
  {long_url: 'bing.com', short_url: 'c'},
  {long_url: 'baidu.com', short_url: 'd'}
]

urls.each do |url|
  ShortenedUrl.create!(long_url: url[:long_url], short_url: url[:short_url], user_id: 1)
end
