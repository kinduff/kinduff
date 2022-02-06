---
title: An I18n coding adventure
date: 2022-02-07
description: >-
  This coding adventure explores how to fix a pain point behind the simple method I18n#t that we use on Ruby applications.
---

This coding adventure explores some of the logic behind the simple method `I18n#t` that we use on Ruby on Rails applications.

This adventure is the result of some frustration after carefully parsing hundreds of locale files in a big Rails application, and pushing hotfixes to production due to missing interpolations in a translated string.

The exact details of the hotfixes or exceptions in production are not relevant, but when you work with a lot of teams that change code and translation at the same time, you begin to wonder if there is a better way to avoid raising 500 errors in your server.

So let's start.

## The adventure

Given:

```yaml
en:
  foo: 'Hello %{place}'
```

Then calling:

```ruby
I18n.t('foo')
# => "Hello %{place}"
```

When interpolated:

```ruby
I18n.t('foo', place: 'world!')
# => "Hello world!"
```

With additional variables:

```ruby
I18n.t('foo', place: 'world!', time: '15:00')
# => "Hello world!"
```

With a variable except the one declared:

```ruby
I18n.t('foo', time: '15:00')
# => I18n::MissingInterpolationArgument
# (missing interpolation argument :place in "Hello %{place}"
# ({:time=>"15:00"} given))
```

Nil values work:

```ruby
I18n.t('foo', place: nil)
# => "Hello "
```

Also empty strings:

```ruby
I18n.t('foo', place: '')
# => "Hello "
```

This is a bad idea:

```ruby
args = { place: nil, time: '15:00' }
I18n.t('foo', args.compact)
```

This is a good one, but it doesn't work:

```ruby
I18n.t('foo', time: '15:00', default: 'Hello universe!')
# => I18n::MissingInterpolationArgument
# (missing interpolation argument :place in "Hello %{place}"
# ({:time=>"15:00"} given))
```

What if:

```ruby
module I18n
  def self.t(key, opts)
    super(key, **opts)
  rescue I18n::MissingInterpolationArgument
    opts[:default] || nil
  end
end
```

So:

```ruby
I18n.t('foo', time: '15:00', default: 'Hello universe!')
# => "Hello universe!"
```

But consider:

```ruby
I18n.t('foo', default: 'Hello universe!')
# => "Hello %{place}"
```

Instead of hacking our way into the class method, let's handle the exception in a better way.

Of course [there's an option for this](https://github.com/ruby-i18n/i18n/blob/5eeaad7fb35f9a30f654e3bdeb6933daa7fd421d/lib/i18n/config.rb#L95-L116):

```ruby
# lib/i18n/config.rb
#
# Sets the missing interpolation argument handler. It can be any
# object that responds to #call. The arguments that will be passed to #call
# are the same as for MissingInterpolationArgument initializer. Use +Proc.new+
# if you don't care about arity.
#
# == Example:
# You can supress raising an exception and return string instead:
#
#   I18n.config.missing_interpolation_argument_handler = Proc.new do |key|
#     "#{key} is missing"
#   end
def missing_interpolation_argument_handler=(exception_handler)
  @@missing_interpolation_argument_handler = exception_handler
end
```

So we can do this:

```ruby
# app/initializers/i18n.rb
#
I18n.config.missing_interpolation_argument_handler = Proc.new do |key|
  I18n.t('default_missing')
end
```

With this:

```ruby
en:
  foo: 'Hello %{place}'
  default_missing: 'missing key'
```

Let's see:

```ruby
I18n.t('foo', time: '15:00')
# => "Hello missing key"
```

I really wish the output would be just `missing key`.

Let's assume that this configuration option works for us, some nice stuff we can do. For example, send a notification to Honeybadger (or your preferred monitoring tool):

```ruby
# app/initializers/i18n.rb

handler = Proc.new do |missing_key, provided_hash, string|
  Honeybadger.notify('Missing interplation argument', content: {
    missing_key: missing_key,
    provided_hash: provided_hash,
    string: string
  })
  I18n.t('default_missing')
end

I18n.config.missing_interpolation_argument_handler = handler
```

That's nice. But I want to return any text, not the missing key replacement during the interpolation. Or the default text for what is worth:

```ruby
I18n.t('foo', time: '15:00', default: 'Hello world!')
# => "Hello world!"
```

We can see how it works in the `I18n#interpolate` method in [this file](https://github.com/ruby-i18n/i18n/blob/00fc8100135878af7b5cc05aa2213844dcbe4e1b/lib/i18n/interpolate/ruby.rb#L31). Specifically here:

```ruby
key = ($1 || $2 || match.tr("%{}", "")).to_sym
value = if values.key?(key)
          values[key]
        else
          config.missing_interpolation_argument_handler.call(key, values, string)
        end
value = value.call(values) if value.respond_to?(:call)
return $3 ? sprintf("%#{$3}", value) : value
```

Code can be a little bit cryptic but the important line is the following: `sprintf("%#{$3}", value).` This line takes care of the interpolation using `sprintf`.

```ruby
sprintf('Hello %{place}', { place: "world!" })
# => "Hello world!"
```

Consider the previous cases:

```ruby
sprintf('Hello %{place}', { time: '15:00' })
# `sprintf': key{place} not found (KeyError)

sprintf('Hello %{place}')
# `sprintf': one hash required (ArgumentError)
```

I18n is also a nice `sprintf` wrapper. It handles exceptions for us, including some weird ones Ruby has, e.g. [reserve keywords](https://github.com/ruby-i18n/i18n/blob/00fc8100135878af7b5cc05aa2213844dcbe4e1b/lib/i18n.rb#L19-L34). Besides of course a lot of other things.

Eyes on the prize, let's try to achieve our goal. Quick and dirty, like a PoC or that feature you rushed to release to production.

```ruby
module I18n
  class << self
    def t(key, opts)
      result = super(key, **opts)
      raise I18n::MissingInterpolationArgument if missing_interpolations?(result)
      result
    rescue I18n::MissingInterpolationArgument
      Honeybadger.notify(key, context: opts)
      opts[:default] || key # Fallback to key if no default is given
    end

    def missing_interpolations?(key)
      key.is_a?(String) &&
      key.match?(Regexp.union(I18n.config.interpolation_patterns))
    end
  end
end

```

So now given:

```ruby
en:
  foo: 'Hello %{place}'
```

Then calling:

```ruby
I18n.t('foo', place: 'world!')
# => "Hello world!"

I18n.t('foo', place: 'world!', time: '15:00')
# => "Hello world!"

I18n.t('foo', default: 'Hello universe!')
# => Honeybadger.notication
# => "Hello universe!"

I18n.t('foo', time: '15:00', default: 'Hello universe!')
# => Honeybadger.notication
# => "Hello universe!"

I18n.t('foo', time: '15:00')
# => Honeybadger.notication
# => "foo"
```

And that's the end of this adventure.

## A word of wisdom

Please don't use the monkey-patch in production, it's not ready at all. I know I will, but that's on me.
