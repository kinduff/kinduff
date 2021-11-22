---
title: The Debug Diary
date: 2021-11-22
description: >-
  During a debug session I wrote a Debug Diary. What is that? How is it useful?
---

I recently had to debug a performance issue for my current employer. I was motivated to do it since I had little time to code during that particular week and wanted to feel the rush again.

Instead of notes, I took what I call a ==Debug Diary==.

The objectives are:

- ==To tell a story==, doesn't have to be structured but it has to be chronological.
- ==To share== with other developers how you debug, in case there is feedback or someone wants to learn how you do it.
- ==To document the process== of finding an issue or a bug, which is very valuable for future actions.

To write it, I recommend the following:

- ==Add time titles==. This can be tedious at first, but there is great value in it.
- ==Keep it simple==, there's no need to lose too much time writing what you are debugging while debugging.
- ==Format later==. You can use a shortcut to take quick screenshots and paste them into the document. You can also copy and paste code blocks or logs.
- ==Keep your document open== with the window split or in your second screen.

For example, this is an extract of my latest Debug Diary:

---

### Debug Diary: Performance issue with sign-up

#### 17:32
Starting a debugging session to find out the issue with the sign-up during a load test.

I'm using the `load_test.jmx` JMeter file provided by the Infrastructure team to debug locally. Had to modify local variables to point to my local environment.

I started using 6 threads for Puma, but the concurrency mixed some results. I'm using 1 thread only.

#### 17:35
I'm able to reproduce. During the test execution I'm able to see a pause in the logs here:

```
Starting signup for ICHSNH7R_19@bbbbb.com at 3163.915322852
User Exists? (0.8ms) SELECT 1 AS one FROM `users` WHERE `users`.`email` = 'ichsnh7r_19@bbbbb.com' LIMIT 1
↳ app/controllers/sign_up_controller.rb:94:in `sign_up'

--- big pause here ---

↳ app/controllers/sign_up_controller.rb:95:in `sign_up'
```

I added some debug information to confirm a theory. I confirm my theory, the following line is causing the issues:

```ruby
@user.validate
```

#### 17:45
Removing the following validations to start:

```ruby
validates :display_name, presence: true
validates :email, format: URI::MailTo::EMAIL_REGEXP, mx_records: true
validates :permalink, length: { maximum: 30 }
```

Continue...

---

You get the idea.

When I was done with the diary, I posted the issue and how to fix it. In this case, it was an easy fix, but it will be pretty common to have more actions so other team members can contribute.

The feedback I received about this was positive. Seems like the investigation and the format helped to understand the thought process, the time it took, and how I reached the solution.

What do you think? Would you write a Debug Diary in the future?
