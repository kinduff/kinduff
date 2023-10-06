# frozen_string_literal: true

require "httparty"
require "yaml"
require "fileutils"

module Jekyll
  class WebmentionsGenerator < Generator
    safe true

    BASE_FOLDER = "_webmentions"

    def generate(site)
      return
      site.collections["posts"].docs.reverse_each do |doc|
        next if doc.data["external"]

        url = "https://webmention.io/api/mentions.jf2?per-page=99999&sort-by=published&target=https://kinduff.com#{doc.url}"
        response = HTTParty.get(url, {
          headers: {"Content-Type" => "application/json"}
        })

        next if response.parsed_response["children"].nil?

        response.parsed_response["children"].each do |child|
          webmention = {
            "source" => child["wm-source"],
            "target" => child["wm-target"].gsub("https://kinduff.com", ""),
            "author" => child["author"],
            "source_url" => child["url"],
            "property" => child["wm-property"],
            "published" => child["published"],
            "published_at" => child["published"],
            "received_at" => child["wm-received"]
          }
          yaml = YAML.dump(webmention)
          folder_name = Jekyll::Utils.slugify(webmention["target"])
          path = "#{BASE_FOLDER}/#{folder_name}/#{webmention["property"]}"
          filename = Jekyll::Utils.slugify(webmention["source"])
          puts "#{folder_name}/#{filename}"
          yaml << "---\n\n"
          content = child.dig("content", "text")
          yaml << content.strip if content

          FileUtils.mkdir_p(path)
          File.write("#{path}/#{filename}.md", yaml)
        end
      end
    end
  end
end
