---
source: https://brid.gy/comment/reddit/kinduff/q5j9d2/hg6puxg
target: "/2021/08/02/the-story-of-the-20-million-queries-per-hour/"
author:
  type: card
  name: tibbon
  photo: https://webmention.io/avatar/www.redditstatic.com/478bd5acc62985807dde82938219b3925bd1419387336f65010e7b969390991c.png
  url: https://reddit.com/user/tibbon/
source_url: https://reddit.com/r/rails/comments/q5j9d2/the_story_of_the_20_million_queries_per_hour/hg6puxg/
property: in-reply-to
published: '2021-10-11T03:15:29'
published_at: '2021-10-11T03:15:29'
received_at: '2022-01-26T22:35:27Z'
---

I love a null object pattern as much as the next person, but isn’t this a lot more overhead to serialize and deserialize a more full featured object than just an empty string, zero or false Boolean? And more over the wire to to redis?

Although maybe a benchmark would show no real difference