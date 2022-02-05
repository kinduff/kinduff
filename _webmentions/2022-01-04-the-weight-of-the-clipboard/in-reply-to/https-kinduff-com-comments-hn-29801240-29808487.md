---
source: https://kinduff.com/comments/hn-29801240/29808487
target: "/2022/01/04/the-weight-of-the-clipboard/"
author:
  type: card
  name: CyberShadow
  photo: ''
  url: https://news.ycombinator.com/user?id=CyberShadow
source_url: https://news.ycombinator.com/item?id=29808487
property: in-reply-to
published: '2022-01-05T14:16:34+01:00'
published_at: '2022-01-05T14:16:34+01:00'
received_at: '2022-02-05T17:52:13Z'
---

I’m working on a clipboard manager, because I’m not happy with any of the ones currently available. Here are my design goals:

The system should be able to efficiently store, manipulate, and search an unlimited number of clipboard entries with reasonable performance.


The software should be cross-platform, and should have implementations for major desktop platforms (Windows, X11, Wayland, macOS).


Non-text data (images) and rich text (e.g. HTML) should be supported.


Clipboard history can be shared across instances using a network connection.


Instances may temporarily go offline, and sync up with other instances once a connection is re-established.


All functionality should continue to be available when offline (other than sync).


Deletions must be propagated across instances.


Deleted clips must not be trivially recoverable.


Deleted clips must be deleted everywhere, including any copies in OS clipboards.


Sync should be incremental (and otherwise generally efficient).


When connected, actions should propagate across instances in real time (instantly, as opposed to polling, and with no unnecessary roundtrips).


Relaying should be supported (in a A B C scheme, A should be able to see C’s actions).


Network topology cycles should not result in a feedback loop.


It should be safe and easy to simply copy the database file to another host, “pre-seeding” the clipboard history.


Support “portable installs” (carrying the software, configuration, and database on portable storage).


It should be easy to write interoperable implementations of bridges/clients in most programming languages.

Non-GUI functionality should be separated (or separatable) from GUI functionality, so that a GUI toolkit doesn’t need to be loaded at all times.
Any suggestions?