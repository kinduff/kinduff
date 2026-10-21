---
title: "Active Search, Meet Bonsai"
date: 2026-09-25
description: |
  Running Rails' new search framework on Bonsai.
canonical_url: https://bonsai.io/blog/active-search-ruby-on-rails-bonsai/
---

> **Cross-posted.** This post was first published on the [Bonsai blog](https://bonsai.io/blog/active-search-ruby-on-rails-bonsai/).

[Ruby on Rails](https://rubyonrails.org) has a search framework of its own now. At [Rails World 2026](https://rubyonrails.org/world), Donal McBreen from [37signals](https://37signals.com), the company behind [Basecamp](https://basecamp.com) and Rails itself, introduced [Active Search](https://github.com/basecamp/rails-active_search). It gives you one chainable, [Active Record](https://guides.rubyonrails.org/active_record_basics.html) style interface for full-text search across [OpenSearch](https://opensearch.org), [Elasticsearch](https://www.elastic.co/elasticsearch), Solr, Meilisearch, Typesense and friends, as well as the full-text search built into PostgreSQL, MySQL and SQLite.

If you've written search in Rails before, you know the drill: pick a gem, learn its DSL, marry it forever. Active Search changes that. Start on your database today, move to a managed search cluster when your app outgrows it, and your models and controllers stay the same. It's alpha software ([`0.1.0` on RubyGems](https://rubygems.org/gems/rails-active_search) as I write this), but it already runs against OpenSearch, which means it runs against Bonsai.

## Active Search vs Searchkick and Chewy

[Searchkick](https://bonsai.io/docs/connecting/ruby-on-rails-searchkick/) and [Chewy](https://bonsai.io/docs/connecting/ruby-on-rails-chewy/) are built for Elasticsearch and OpenSearch, and expose a lot of what those engines can do (we [compared the Ruby gems](https://bonsai.io/blog/comparison-of-elasticsearch-ruby-gems/) a while back). Active Search is a common interface instead, the way Active Record is for databases, so the same `Article.search("rails")` works on SQLite in development and OpenSearch in production. The trade-off: no aggregations, nested documents or autocomplete yet. If you need those today, Searchkick is still a great fit.

## Step 1: Add Active Search to your Rails app

Active Search doesn't bundle a search client. Bonsai clusters run OpenSearch, so bring [`opensearch-ruby`](https://github.com/opensearch-project/opensearch-ruby):

```ruby
# Gemfile
gem "rails-active_search"
gem "opensearch-ruby"
```

```bash
bundle install
bin/rails active_search:install
```

> **Running Elasticsearch instead of OpenSearch?** Use `adapter: elasticsearch` with the official client pinned to 7.13. Starting with 7.14, [the gem refuses to talk to open-source Elasticsearch 7.x](https://bonsai.io/docs/connecting/ruby-on-rails-searchkick/):
>
> ```ruby
> gem "elasticsearch", "7.13.3"
> ```

## Step 2: Connect Active Search to your Bonsai cluster

Grab your cluster URL from the [Access](https://bonsai.io/docs/features/credential-management/) section of your cluster dashboard. [Heroku users](https://bonsai.io/docs/heroku/add-bonsai-to-your-heroku-app/) already have it in `BONSAI_URL`.

```yaml
# config/search.yml
development:
  adapter: sqlite

production:
  adapter: opensearch
  hosts:
    - <%= ENV["BONSAI_URL"] %>
```

The client reads the host, port and credentials straight out of the URL (our [Active Search docs](https://bonsai.io/docs/connecting/ruby-on-rails-active-search/) cover the full setup). Development runs on SQLite, production runs on Bonsai, and your app doesn't know the difference.

## Step 3: Define a search index and connect your model

```ruby
# config/search.rb
ActiveSearch.define_index(:articles) do
  text :title
  text :body
  string :status
end
```

```ruby
# app/models/article.rb
class Article < ApplicationRecord
  has_search
end
```

`text` fields are searched, the rest are for filtering and sorting. `has_search` adds callbacks that reindex a record on every save and remove it on destroy, through [Active Job](https://guides.rubyonrails.org/active_job_basics.html).

## Step 4: Create the index and load your data

```bash
bin/rails active_search:index:create INDEX=articles
```

The callbacks only fire on new writes, so batch your existing records in from a console:

```ruby
ActiveSearch.index(:articles).batch(max_size: 500) do |batch|
  Article.find_each { |article| batch.add(article) }
end
```

## Step 5: Search from your Rails controller

```ruby
# app/controllers/articles_controller.rb
def index
  @page = Article.search(params[:q])
    .filter(status: "published")
    .page(params[:page], per_page: 20)
end
```

It chains like the Active Record queries you already write, and pagination is built in. Loop over `@page.results` in your view and each result is the record itself.

## See what your Rails search is doing in the Bonsai dashboard

Active Search writes the queries for you. That's the whole point, but it's also why it's worth having somewhere to see them land.

### Documents: did the load actually work?

Run `bin/rails active_search:status COUNT=1`, then compare it with the Usage panel on your cluster's Overview:

![Usage panel showing document, data and shard counts](/assets/images/posts/active-search/usage-component.png)

If your database says 5,000 articles and Bonsai says 5K docs, you're done. If not, you know before your users do.

### Performance: your traffic, at a glance

![Performance heat map](/assets/images/posts/active-search/performance-heatmap.png)

Each column in the [Overview](https://bonsai.io/docs/features/cluster-overview/) heat map is a slice of time, each row a bucket of request duration, and hotter colors mean more requests. A cool, tight band at the bottom? Happy cluster. Heat creeping upward right after a deploy? You just found your slow query, and you know exactly when it started.

### Query Logs: what your users are really asking

![Query Logs panel on the cluster overview](/assets/images/posts/active-search/query-logs-dashboard.jpg)

[Query Logs](https://bonsai.io/docs/features/query-logs/) ranks the search terms your users type by volume, with duration and hit count for each. High volume with low hits is a relevancy problem, and zero-hit queries are the first thing to fix. To tell Bonsai exactly what the user typed, add it to the request with `native`:

```ruby
Article.search(params[:q]).native { |request|
  request.merge(ext: { bonsai: { user_query: params[:q] } })
}.page(params[:page])
```

### The Console: talk to your cluster directly

![Bonsai Console running the Active Search query](/assets/images/posts/active-search/bonsai-console.png)

Want to see what Active Search is sending? `Article.search("hotwire").to_native_query` returns the request body. Paste it into the [Console](https://bonsai.io/docs/features/console/) as a `POST` to `/articles/_search` and tweak it until the results look right. No curl, no credentials on your clipboard.

## Why Active Search and Bonsai work well together

Active Search makes the engine swappable. Bonsai makes the engine visible. Together you get Rails-native search code and a cluster you can actually see into, without running a single node yourself.

Spin up a free [Sandbox cluster](https://app.bonsai.io/signup?utm_source=bonsai-static&utm_campaign=%2Fblog%2Factive-search-ruby-on-rails-bonsai%2F), add the gem, and watch your first queries light up the heat map. The [Active Search README](https://github.com/basecamp/rails-active_search#readme) covers everything this post skipped, and we'd love to hear how you're using it at <support@bonsai.io>.
