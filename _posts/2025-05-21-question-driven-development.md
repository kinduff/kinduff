---
title: Question Driven Development
date: 2025-05-21 19:31 -0600
description: |
  A reflection on the importance of asking the right questions in software development.
---

I have this memory from when I was a kid of asking the following question during a biology presentation about the human body and its parts: =="Why do we die when our blood stops moving?"==

Everybody laughed. I felt shame. But I also didn't get an answer from my mocking peers because they couldn't understand it either, but didn't want to accept it. Today, years later, I understand why but don't fully grasp it. I'm not a biologist or anything similar.

What my teacher said to me and the group after I asked that question is what I remembered a minute ago: =="There are no stupid questions, only stupid people who don't ask."== And she proceeded to explain why.

I like to ask questions before and after implementing a feature to make them complete and avoid having to implement those when something goes wrong. We usually do this when coding by using our brains and interpreting and predicting how the data will flow in a script, a method, or collection of classes:

=="When this string is compared and is exactly what I'm looking for, I will call this method that returns if its valid according to these other things [...]"==

So let's talk about that. How asking questions and documenting them can make your feature complete.

And yes, I just tied a personal story to an engineering article on how the idea of asking questions can be transposed across multiple areas of a feature implementation. Sue me!

The first thing to pay attention to when asking a question is ==to know to whom or what we are asking the question==. The idea of just throwing an idea out of the blue seems preposterous.

For example, let's play pretend and take the following task from our backlog:

> **Move webhook processing to a background job**
>
> In our application route, we are executing and waiting inline for our service to resolve to respond to the incoming webhook. We want is to move the processing to a background job and respond to the webhook immediately with a 204.

And here is part of the code we care about for now. If you don't know Ruby on Rails or Ruby, I'm really sorry. You should, its really nice.

```ruby
class WebhooksController < ApplicationController
  def receive
    event_params = params[:event] # get params
    SweetLittleService.new(event_params).call # call service
    head 200 # give response
  end
end
```

I can think of a couple of questions already by reading this description and seeing the code.

For example, to the **Product Owner/Manager** we can ask:
1. What happens if the background job fails?
2. Do we need to track the webhook processing status?
3. What's the expected volume of webhooks?

To the **System/Architecture**:
1. What happens if we lose the job before processing?
2. Should the job be idempotent?
3. What's our error handling strategy?

To the **Implementation**:
1. Why do we want to process in the background?
2. How much time does our service take to execute?
3. Why return a 204 HTTP code and not 200?

To **Ourselves**:
1. Why do I keep working on software engineering?
2. How much wood could a woodchuck chuck if a woodchuck could chuck wood?
3. Did I just lost [The Game](https://en.wikipedia.org/wiki/The_Game_(mind_game))?

With these questions in mind, we could potentially modify our controller and create our background job like this. And please, this is just an example!

```ruby
class WebhooksController < ApplicationController
  def receive
    event_params = params[:event]

    # Create a job with retries and error handling
    WebhookProcessingJob.perform_later(
      event_params,
      webhook_id: SecureRandom.uuid, # for idempotency
      received_at: Time.current
    )

    head 204 # respond immediately
  end
end

class WebhookProcessingJob < ApplicationJob
  queue_as :webhooks
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(event_params, webhook_id:, received_at:)
    # Check if we already processed this webhook
    return if WebhookLog.exists?(webhook_id: webhook_id, status: 'completed')

    WebhookLog.create!(
      webhook_id: webhook_id,
      status: 'processing',
      received_at: received_at,
      event_params: event_params
    )

    begin
      SweetLittleService.new(event_params).call
      WebhookLog.find_by(webhook_id: webhook_id).update!(status: 'completed')
    rescue => e
      WebhookLog.find_by(webhook_id: webhook_id).update!(
        status: 'failed',
        error_message: e.message
      )
      raise # re-raise for retry logic
    end
  end
end
```

And then we can ask more questions to the **Implementation**:

1. What if the database is down when the job runs?
2. What if we receive malformed webhook data?
3. What if the same webhook is sent multiple times?
4. What if we need to replay failed webhooks?

==Each question reveals a potential edge case that could break the feature or making the implementation break out of the scope==, successfully achieving one of those eternal PRs with changes across 40 files.

But these questions are not only to know what we want to build, how, and their edge cases. They can also be used as an aid for our future selves or our peers in the form of code documentation. For example:

```ruby
# WebhookProcessingJob
#
# Handles webhook processing in the background to avoid blocking the HTTP response.
#
# Key decisions made:
# - Uses unique webhook_id for idempotency (handles duplicate webhooks)
# - Logs processing status for debugging and monitoring
# - Retries failed jobs up to 3 times with exponential backoff
# - Preserves original received_at timestamp for audit purposes
class WebhookProcessingJob < ApplicationJob
  # ...
end
```

The best engineers I know have developed a habit of asking questions at every stage and to the stage itself (remember, to whom we are asking):

- To **Planning**: What are we actually trying to solve here?
- To **Design**: What could go wrong with this approach?
- To **Implementation**: What assumptions am I making?
- To **Review**: What scenarios haven't we tested?
- To **Deployment**: What will we do if this breaks?

Sometimes the questions reveal uncomfortable truths about our original plan. Maybe the "simple" background job migration actually requires database migrations, monitoring setup, and error handling workflows. Maybe it's not as straightforward as we thought.

But that's okay. ==It's better to discover complexity early than to be surprised by it in production==.

But there should be a balance here. ==Not every question needs to be answered with code==. Some questions are answered with "we'll handle that when it becomes a problem" or "that's out of scope for this iteration."

==The key is to ask the questions==, document the decisions, and make trade-offs rather than accidentally ignoring important scenarios.

## Closing thoughts

That biology question I asked as a kid wasn't stupid, it was fundamental. Understanding how blood circulation works is crucial to understanding human life.

Similarly, the questions we ask about our code aren't stupid, they're fundamental to building robust systems. The difference between a junior and senior engineer often isn't technical knowledge, it's the quality and depth of questions they ask.

So next time you're implementing a feature, channel your inner curious kid. Ask the obvious questions. Ask the uncomfortable questions. Ask the "what if" questions.

Your future self (and your on-call rotation) will thank you.
