---
image: https://dimg.kinduff.com/JIRA Opener, issue parser.jpeg
title: JIRA Opener, issue parser
date: 2016-04-13
description: Web tool that helps you out to parse and open bulk issues from JIRA.
lang: en_US
---

I’ve been working with a client that uses JIRA to manage business and
development needs. It is widely integrated with the process of the company and I use it everyday for managing.

It is pretty cool in some areas, but my god, sometimes it’s a pain to actually
work with it — don’t judge me though, I think JIRA it’s a great tool and makes
sense to me to use it in some projects.

The thing is that sometimes issues come from e-mails or Slack messages with JIRA references (issue/ticket numbers) and I need to copy and paste the IDs and
search or create JIRA urls with this, in order to continue with my development work.

That’s why I created this small tool called "Jira Opener" over the weekend. The logo is a Heinz can with the Atlassian logo on it — basically it is me trying to make a pun.

This simple tool allows you to paste a text from an e-mail or whatever and it will _magically_ extract the JIRA issues and build clickable URLs with them for you to have a better life.

If you press Ctrl (or CMD (you’re welcome Apple)) + Enter, it will open them all in your browser.

The domain is configurable and it will concat the issue number at the end. Not sure if this is the right approach but it works well for me and my coworkers.

Hosted [right here](http://kinduff.com/jira-opener).

Repo right there -> [here](https://github.com/kinduff/jira-opener).

![](https://cdn-images-1.medium.com/max/800/1*xTOeQmgrlNeSUEQjSS-XPQ.png)
