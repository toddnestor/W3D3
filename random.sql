SELECT
  "shortened_urls".*
FROM
  "shortened_urls"
  INNER JOIN "visits"
    ON "visits"."url_id" = "shortened_urls"."id"
  INNER JOIN "tags"
    ON "shortened_urls"."id" = "tags"."url_id"
WHERE
  "tags"."topic_id" = $1
GROUP BY
  visits.url_id
ORDER BY
  COUNT(visits.id) DESC
