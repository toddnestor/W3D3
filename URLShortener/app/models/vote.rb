class Vote < ActiveRecord::Base
  validates :user_id, :url_id, presence: true
  validates_uniqueness_of :user_id, scope: :url_id

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

  def self.record_vote!(user, url)
    Vote.create!(user_id: user.id, url_id: url.id)
  end
end
