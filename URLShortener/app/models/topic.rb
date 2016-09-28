class Topic < ActiveRecord::Base
  validates :name, presence: true

  has_many :tags,
    primary_key: :id,
    foreign_key: :topic_id,
    class_name: :Tag

  has_many :urls,
    through: :tags,
    source: :url


  def most_popular_links
    self.urls.joins(:visits).group('shortened_urls.id').order('COUNT(visits.id) DESC')
  end
end
