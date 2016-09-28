class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  has_many :tags,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tag

  has_many :topics,
    through: :tags,
    source: :topic

  def self.random_code(n=8)
    code = SecureRandom::urlsafe_base64[0..n]
    return self.random_code(n) if ShortenedUrl.find_by(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.created_at > ?", 30.seconds.ago).count
  end

  def visit!(user)
    Visit.record_visit!(user, self)
  end

  def tag(topic_id)
    Tag.tag(self.id, topic_id)
  end
end
