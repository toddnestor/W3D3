class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, length: {minimum: 4, maximum: 2083}
  validate :more_than_five_urls_in_a_minute

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

  def long_url=(url)
    unless url.match(/^((http(s)?:)?\/\/).*/)
      url = "http://" + url
    end

    write_attribute(:long_url, url)
  end

  def self.random_code(n=8)
    code = SecureRandom::urlsafe_base64[0..n]
    return self.random_code(n) if ShortenedUrl.find_by(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end

  def more_than_five_urls_in_a_minute
    if ShortenedUrl.where("shortened_urls.created_at > ?", 1.minute.ago).where(user_id: self.user_id).count >= 5
      self.errors[:cannot_create] << "more than five urls in a minute"
    end
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
