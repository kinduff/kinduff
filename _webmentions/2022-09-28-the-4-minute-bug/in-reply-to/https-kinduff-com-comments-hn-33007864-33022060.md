---
source: https://kinduff.com/comments/hn-33007864/33022060/
target: /2022/09/28/the-4-minute-bug/
author:
  type: card
  name: pachico
  photo: ""
  url: https://news.ycombinator.com/user?id=pachico
source_url: https://news.ycombinator.com/item?id=33022060
property: in-reply-to
published: 2022-09-29T17:29:43+02:00
published_at: 2022-09-29T17:29:43+02:00
received_at: 2022-09-29T17:30:25Z
---

It looks to me like a bad architected solution…
If you have a background job to update data, there is no need to do any TTL.
If we’re speaking about currency exchange, you might prefer to store a transactional history of exchanges, together with the current one, and populate a fast read model too (Redis) with a failover against the oltp version…
Maybe it’s just me.