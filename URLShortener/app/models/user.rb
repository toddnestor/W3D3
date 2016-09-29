class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :submitted_urls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :ShortenedUrl

  has_many :visits,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Visit

  has_many :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :url

  has_many :votes,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Vote

  has_many :voted_urls,
    through: :votes,
    source: :url
end
