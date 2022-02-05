---
source: https://kinduff.com/comments/hn-29306410/29317917
target: "/2021/11/22/the-debug-diary/"
author:
  type: card
  name: iandinwoodie
  photo: ''
  url: https://news.ycombinator.com/user?id=iandinwoodie
source_url: https://news.ycombinator.com/item?id=29317917
property: in-reply-to
published: '2021-11-23T15:05:39+01:00'
published_at: '2021-11-23T15:05:39+01:00'
received_at: '2022-02-05T17:51:55Z'
---

I also log my debugging process, but usually I’m less verbose with the explanations and more verbose about the specific actions I’m taking. For example, instead of a note saying “starting a debugging session to find out the issue with the sign-up during a load test” I’ll provide the full command I used. Why? So that the process is reproducible in the event that I need to walk back a few steps or hand off the debugging to another team. I’ll also include environment information such as my current machine, PATH, and commit hash.