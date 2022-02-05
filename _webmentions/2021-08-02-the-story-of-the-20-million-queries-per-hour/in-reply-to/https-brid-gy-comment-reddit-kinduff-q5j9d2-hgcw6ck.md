---
source: https://brid.gy/comment/reddit/kinduff/q5j9d2/hgcw6ck
target: "/2021/08/02/the-story-of-the-20-million-queries-per-hour/"
author:
  type: card
  name: ksh-code
  photo: https://webmention.io/avatar/www.redditstatic.com/b4be5d320718a5e62a32e756a628dbbae500c42f94fb47937b50c0adca151ed6.png
  url: https://reddit.com/user/ksh-code/
source_url: https://reddit.com/r/rails/comments/q5j9d2/the_story_of_the_20_million_queries_per_hour/hgcw6ck/
property: in-reply-to
published: '2021-10-12T14:29:02'
published_at: '2021-10-12T14:29:02'
received_at: '2022-01-26T22:35:32Z'
---

If you use dalli store < 3, you can use cache_nils option.

On the other hand, if you use rails version >= 6.1, you cannot use dalli store < 3 so you do not care about nil data stored.