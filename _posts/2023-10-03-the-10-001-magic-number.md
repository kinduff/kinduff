---
title: The 10_001 magic number
date: 2023-10-03 13:43 +0200
description: >-
  Unraveling the story behind a magic number in code
---

Read this line of code today:

```ruby
redirect_to(path, alert: "CSV is too big, please use maximum 10_000 lines per import")
&& return if File.open(file).readlines.size > 10_001
```

I spotted the `10_001` magic number and it grabbed my attention. I wondered why this number and not the one stated in the error message. It sure seems like a mistake. If you really want that constraint, then you would use `> 10_000`, otherwise the user will be allowed to upload `10_001` lines.

Wait a minute! That's taking the header into consideration. So if the system only allows `10_000` rows of data, it should also allow the header.

This is good UX for the user because this magic number should not be taken into consideration. I'm pretty sure there was a conversation about this.

- **(dev)** Oops, the server crashed.
- **(usr)** Hey Dev, the website isn't working.
- **(dev)** Yes, hold on a minute. Were you using the import feature?
- **(usr)** Yeah.
- **(dev)** Okay. For now, the server cannot tolerate processing more than `10_000` records; please split the files.
- **(usr)** Hey, there's an error when I try to upload the file.
- **(dev)** (Dev pushes a fix, adding the `10_001` magic number). Okay, try now.
- **(usr)** It works, thanks!

Behind the code, there are conversations. Either direct conversations about modifications that needed to be made and pastafarize the code—since it's on the edge of the conventions and abstractions—or hidden fixes to provide a better user experience. I think this is one of the latter.

This is why I love reading legacy code (not really, but bear with me) because behind every line of code, there's an echo of a conversation that happened via chat, video, or in person, and tells a story. The depth behind the simple `10_001` magic number.

PS: Please use comments instead of triggering me to write a blog post and daydream about why numbers tell stories.
