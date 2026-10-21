---
title: Claude Code Release Pulse
date: 2026-09-04
description: |
  I graphed 385 releases of Claude Code's changelog.
canonical_url: https://bonsai.io/blog/claude-code-pulse/
---

> **Cross-posted.** This post was first published on the [Bonsai blog](https://bonsai.io/blog/claude-code-pulse/).

I was checking out [Claude Code's changelog](https://code.claude.com/docs/en/changelog) because of this change:

> Added a diff panel that opens beside the conversation in fullscreen mode and shows your uncommitted changes as Claude edits; toggle it with `/diff`.

But then I started scrolling and checking the amount and the dates, and had the urge to graph this. And so I did. Every release on that page, from `0.2.21` on April 2nd 2025 to `2.1.260` on September 3rd 2026. That's 385 versions and 5,132 bullets. Then I inspected the data and classified their lines by the verb they start with:

<iframe id="ccp-pulse" src="/assets/images/posts/claude-code-pulse/pulse.html" title="Claude Code Release Pulse — interactive charts of the changelog" loading="lazy" scrolling="no" style="width:100%;height:1600px;border:0;display:block;overflow:hidden;"></iframe>

<script>
(function () {
  var f = document.getElementById('ccp-pulse');
  window.addEventListener('message', function (e) {
    if (f && e.source === f.contentWindow && e.data && e.data.type === 'ccp-pulse-height') {
      f.style.height = e.data.height + 'px';
    }
  });
})();
</script>

I think it tells a very interesting story about the Claude Code team. They are closed source, so this is our only visibility.

- The volume grew a lot. April 2025 was 56 bullets across 27 versions. August 2026 was 735 across 28. Same amount of releases, thirteen times the content.
- Their allocation is mostly fixes now, and it wasn't always. In July 2025, 41% of the bullets started with "added". By mid 2026 that's between 6% and 10%, while "fixed" hasn't gone under 56% since February.
- They ship on 258 days out of the eighteen months, and only 6 of those are Sundays. Saturdays get 27.
- They are very consistent, and that consistency is the part I keep looking at. The releases per month barely move while the content inside them goes up thirteen times. Claude Code is built with Claude Code, so a good chunk of this is agents doing the work and a human pressing the button.

Two things to keep in mind if you go poking at the graphs. April 2nd 2025 has 17 releases in one day, which is the changelog being seeded and not a real day of work. And the "Other" bucket isn't a category, it's my classifier giving up on bullets that don't start with added, fixed or improved. I'd love to say those are the human written ones, but I can't check that from out here.

What else do you think these graphs tell us?
