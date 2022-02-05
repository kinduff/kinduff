# frozen_string_literal: true

require "httparty"
require "yaml"
require "fileutils"

module Jekyll
  class WebmentionsGithubGenerator < Generator
    safe true

    BASE_FOLDER = "_comments"

    def generate(site)
      return
      site.collections["posts"].docs.reverse_each do |doc|
        url = "https://api.github.com/search/issues"
        response = HTTParty.get(url, {
          :headers => { "Content-Type" => "application/json" },
          :query   => {
            :q    => "\"#{doc["title"]}\" type:issue in:title repo:kinduff/kinduff",
            :sort => "created",
          },
        })

        issue_data = response.parsed_response["items"]&.first
        next unless issue_data

        issue_url = issue_data["comments_url"]

        issue_response = HTTParty.get(issue_url, {
          :headers => { "Content-Type" => "application/json" },
        })

        issue_response.parsed_response.each do |comment|
          webmention = {
            "uid"        => "tag:github.com,#{issue_data["number"]}:#{comment["id"]}",
            "published"  => comment["created_at"],
            "author"     => {
              "uid"    => "tag:github.com,#{issue_data["number"]}:#{comment["user"]["login"]}",
              "avatar" => comment["user"]["avatar_url"],
              "name"   => comment["user"]["login"],
              "url"    => comment["user"]["html_url"],
            },
            "source_url" => comment["html_url"],
            "target_url" => "https://kinduff.com#{doc.url}",
          }

          comment_file = "#{BASE_FOLDER}/gh-#{issue_data["number"]}/#{comment["id"]}.md"

          puts comment_file.to_s

          yaml = YAML.dump(webmention)
          yaml << "---\n\n"
          content = comment["body"]
          yaml << content if content

          FileUtils.mkdir_p(File.dirname(comment_file))
          File.write(comment_file, yaml)
        end
      end
    end
  end
end
