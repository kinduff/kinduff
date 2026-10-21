---
title: The Pink Elephant in Your Prompt
date: 2026-10-15
description: |
  Telling an agent to ignore your code still puts that code in charge.
canonical_url: https://bonsai.io/blog/pink-elephant-in-your-prompt/
---

> **Cross-posted.** This post was first published on the [Bonsai blog](https://bonsai.io/blog/pink-elephant-in-your-prompt/).

I've been playing with this idea in my head that we can get better results if we blind our agent to certain things.

You know the drill. You already have something and you want a fresh take on it, so you paste the old one in and write "don't base it on this". But to disregard the existing result, the agent needs to know about the existing result, which defeats the purpose of the ask. It's the old pink elephant problem: tell someone not to think of a pink elephant, and now that's all they can think about.

I wanted proof, at least for agents, so I ran 720 trials against Claude Haiku 5.5 and Claude Sonnet 5.5.

## The experiment

I asked for the same thing every time: a Python `RateLimiter` class with an `allow(key)` method. There are about five standard ways to build one, so it's easy to count what the model picked. With no existing code in the prompt, both models go for the same one, a sliding window log, 88% of the time. That's its usual answer.

Then I put an existing `throttle.py` in front of the task and changed one sentence at a time. Sometimes the existing code was a weak fixed window counter. Sometimes it was the model's own usual answer. The question every time: did it still give its usual answer?

## "Don't" makes the old code the reference point

<iframe class="bya-chart" src="/assets/images/posts/pink-elephant/charts.html#dont" title="Shown a weak existing file, how often Claude still gave its usual answer" loading="lazy" scrolling="no" style="width:100%;height:330px;border:0;display:block;overflow:hidden;"></iframe>

Showing the weak file and asking for something new barely changed anything, 75% to 88% of runs still gave the usual answer. Adding "don't base it on this" dropped that to 25%. Most of those runs switched to a token bucket, an algorithm that never showed up when the models had no code to look at.

None of them copied the old code. They went looking for whatever looked least like it. The old file decided the answer, just in reverse.

## Show it its own first choice and it walks away

This is the case that worried me, because it's the common one: you ask for a fresh take on something you're already happy with. The closest stand-in I had: make the existing file the model's own usual answer.

<iframe class="bya-chart" src="/assets/images/posts/pink-elephant/charts.html#good" title="Shown its own usual answer as existing code, how often Claude kept it" loading="lazy" scrolling="no" style="width:100%;height:330px;border:0;display:block;overflow:hidden;"></iframe>

Just putting the file in the prompt, with the same plain task, dropped the usual answer to 37%. "Write a new one" took it to 13%, and "don't" to 5%. Sonnet picked a token bucket in all 30 runs.

My guess, which I didn't test, is that when you show a model working code and ask for the same thing, it assumes you want something else. Which is a reasonable thing to assume when a person asks you.

## Blind doesn't mean original

This one surprised me. My plan was to remove the old solution and get novel ideas. What I got was the model's usual answer, over and over. Haiku picked the exact same algorithm in 30 out of 30 blind runs.

So I asked it to "consider three substantially different rate limiting algorithms" first. All 60 runs listed the same three:

<iframe class="bya-chart" src="/assets/images/posts/pink-elephant/charts.html#options" title="Algorithms Claude listed when asked to consider three different ones" loading="lazy" scrolling="no" style="width:100%;height:380px;border:0;display:block;overflow:hidden;"></iframe>

Asking for options gets you the textbook options. Anything outside the textbook probably has to come from outside the prompt: a different framing, a different model, or a person with a weird idea.

## Blind first, constrain second

So what about the opposite order? Generate first, then apply the real constraints. Both models had to write a drop-in replacement for the existing class, same name and same methods.

<iframe class="bya-chart" src="/assets/images/posts/pink-elephant/charts.html#upgrade" title="How often Claude patched up the old fixed window instead of replacing it" loading="lazy" scrolling="no" style="width:100%;height:400px;border:0;display:block;overflow:hidden;"></iframe>

Starting from one of their blind designs, 60 out of 60 kept the blind idea and adapted it to fit. Starting from the old code, Haiku mostly upgraded the old code: its most common pick, 19 of 30, was a sliding window counter, which is a fixed window with a patch on top. Sonnet's picks were spread out, so I can't say the same for it.

## What didn't work

I expected agents to anchor on code they find on their own while exploring a repo. They didn't, at least here.

<iframe class="bya-chart" src="/assets/images/posts/pink-elephant/charts.html#agent" title="Agents with the old file sitting in the repo" loading="lazy" scrolling="no" style="width:100%;height:380px;border:0;display:block;overflow:hidden;"></iframe>

Haiku opened the old file in 29 of 30 runs and wrote its usual answer every time. Sonnet never even looked. But I planted the weak file and told the agent exactly where to write, so this test was too easy to pass. A fair version is the next experiment.

## What I do now

- When I want options, I take the existing solution out of the context. Describing it and asking the agent to ignore it does the opposite of what the sentence says.
- I get variety from outside the model: a different framing, a different model, or seeds from people.
- I apply the constraints, the interface, the AWS account, the existing data, as a separate step on top of those options.

Context still matters. An answer that ignores your constraints is useless. What changes is the order: come up with options with the old solution out of the room, then narrow down with everything you know.

## Are we doing this to ourselves?

This whole experiment felt familiar. If you're building a product, or pivoting one, the product you already have is always in the room. Nobody decides to only make incremental changes. The existing thing just becomes the frame for every idea.

So are our solutions biased because we keep telling our own LLM brains "let's do something new with this"?

Look at the prompts again. Every planning session starts with the product on the table. That's the "nothing, just the task" bar, where the prompt only asked for a rate limiter and the model still moved off its usual answer. Then we say "let's do something new with this", or "let's not just iterate on what we have". Those are the "write a new one" and "don't" prompts, almost word for word, and they made the answer react to the existing code instead of starting from the problem. A pivot is the same prompt at company scale: the whole point is to move away from what you have, which keeps it at the center of every conversation. And when the first requirement is "it has to fit what we already have", Haiku mostly patched up the old thing.

People aren't language models, and nothing here measures people. But if our heads work anything like this, the fix looks the same. Start from the problem with the product out of the room. Bring in ideas from people outside the team, because a team that just sets the product aside will still come up with the obvious answers. Only then check what fits. If we constrain too fast, we lose the good stuff, and with it the possibility to outgrow ourselves.

## How I ran it

- 720 runs through headless Claude Code in bare mode (`claude -p --bare`), 30 per prompt and model, with no settings, hooks, skills, MCP servers, `CLAUDE.md` or organization instructions.
- Each answer labeled its own algorithm in a docstring line, which I checked against the code with regexes (719 of 720 matched).
- I measured whether the answer changed, not whether it got better or worse. A token bucket is a fine rate limiter.
- One task, two models, default temperature. Big gaps like 88% against 25% hold up. I wouldn't read anything into a few percentage points.
- About $7.60 in total, as reported by the CLI.

## Related research

- [Anchoring Bias in Large Language Models](https://arxiv.org/abs/2412.06593) (Lou, 2024): telling GPT-4 models to ignore an anchor in the prompt is "not sufficient".
- [Suppressing Pink Elephants with Direct Principle Feedback](https://arxiv.org/abs/2402.07896) (Castricato et al., 2024): getting a model to avoid a topic on request took fine-tuning, prompting alone did worse.
- Anthropic's [prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices): "Tell Claude what to do instead of what not to do."

Have you seen this with your own agents? I'm especially curious if anyone has a reliable way to get options that aren't the textbook three.

*Thanks to [Luis](https://bonsai.io/authors/luis-cesar/) and [Bradford](https://bonsai.io/authors/bradford-fults/) for pushing my creativity during work hours.*

<script>
(function () {
  window.addEventListener('message', function (e) {
    if (!e.data || e.data.type !== 'bya-chart-height') return;
    document.querySelectorAll('iframe.bya-chart').forEach(function (f) {
      if (e.source === f.contentWindow) f.style.height = e.data.height + 'px';
    });
  });
})();
</script>
