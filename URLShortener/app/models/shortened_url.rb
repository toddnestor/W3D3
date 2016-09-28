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

  def self.random_code(n=8)
    code = SecureRandom::urlsafe_base64[0..n]
    return self.random_code(n) if ShortenedUrl.find_by(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end
end
