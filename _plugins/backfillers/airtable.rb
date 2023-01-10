# frozen_string_literal: true

require "airrecord"

Airrecord.api_key = ENV["AIRTABLE_API_KEY"]

class Saved < Airrecord::Table
  self.base_key = ENV["AIRTABLE_BASE_KEY"]
  self.table_name = "YouTube Saved"
end

module Jekyll
  class SavedGenerator < Generator
    safe true

    BASE_FOLDER = "_videos"

    def generate(_site)
      return

      Saved.all.each do |video|
        video_file = "#{BASE_FOLDER}/yt_#{video["ID"]}.md"

        puts video_file.to_s

        image_path = "assets/images/videos/yt_#{video["ID"]}.jpg"

        data = {
          "title"     => video["Title"].strip,
          "author"    => video["Owner"].strip,
          "thumbnail" => "/#{image_path}",
          "og_image"  => "/#{image_path}",
          "date"      => DateTime.parse(video["Created"]).strftime("%Y-%m-%d %H:%M:%S %z"),
        }

        yaml = YAML.dump(data)
        yaml << "---\n\n"
        yaml << "{% youtube #{video["ID"]} %}"

        image = URI.open("https://i.ytimg.com/vi/#{video["ID"]}/hqdefault.jpg")
        FileUtils.mkdir_p(File.dirname(image_path))
        File.write(image_path, image.read)
        FileUtils.mkdir_p(File.dirname(video_file))
        File.write(video_file, yaml)
      end
    end
  end
end
