# frozen_string_literal: true

require "httparty"
require "yaml"
require "fileutils"
require "cgi"

module Jekyll
  class WebmentionsHackernewsGenerator < Generator
    safe true

    BASE_FOLDER = "_comments"

    def generate(_site)
      return
      post_ids = [
        29_306_410,
        29_801_240,
      ]

      post_ids.each do |post_id|
        url = "https://hacker-news.firebaseio.com/v0/item/#{post_id}.json"
        response = HTTParty.get(url, {
          :headers => { "Content-Type" => "application/json" },
        })

        next unless response.code == 200

        response.parsed_response["kids"].each do |comment_id|
          url = "https://hacker-news.firebaseio.com/v0/item/#{comment_id}.json"
          child_response = HTTParty.get(url, {
            :headers => { "Content-Type" => "application/json" },
          })

          next unless child_response.code == 200

          comment = child_response.parsed_response

          webmention = {
            "uid"        => "tag:news.ycombinator.com,#{post_id}:#{comment_id}",
            "published"  => Time.at(comment["time"]),
            "author"     => {
              "uid"  => "tag:news.ycombinator.com,#{post_id}:#{comment["by"]}",
              "name" => comment["by"],
              "url"  => "https://news.ycombinator.com/user?id=#{comment["by"]}",
            },
            "source_url" => "https://news.ycombinator.com/item?id=#{comment_id}",
            "target_url" => response.parsed_response["url"],
          }

          comment_file = "#{BASE_FOLDER}/hn-#{post_id}/#{comment_id}.md"

          puts comment_file.to_s

          yaml = YAML.dump(webmention)
          yaml << "---\n\n"
          content = comment["text"]
          yaml << strip_html(CGI.unescapeHTML(content).gsub("<p>", "\n\n")) if content

          FileUtils.mkdir_p(File.dirname(comment_file))
          File.write(comment_file, yaml)
        end
      end
    end
  end
end
