namespace :urls do
  desc "Prune old urls from non-premium users"
  task prune: :environment do

    #users[3].submitted_urls.left_joins(:visits).where("visits.created_at > ?", 30.minutes.ago).where("visits.id IS NULL") #this is close

    time = 30.minutes.ago
    sql = <<-SQL
      SELECT
        DISTINCT shortened_urls.*
      FROM
        shortened_urls
      LEFT JOIN visits
        ON visits.url_id = shortened_urls.id
      WHERE
        shortened_urls.created_at  < '#{time}' AND
        shortened_urls.user_id NOT IN (
          SELECT
            id
          FROM
            users
          WHERE
            premium = true
        )
      GROUP BY
        shortened_urls.id
      HAVING
        MAX(visits.created_at)  < '#{time}' OR COUNT(visits.id) < 1;
    SQL

    urls = ShortenedUrl.find_by_sql(sql)
    urls.each {|url| url.destroy}
  end
end
