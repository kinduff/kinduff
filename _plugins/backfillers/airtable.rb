require 'airrecord'

Airrecord.api_key = ENV['AIRTABLE_API_KEY']

class Saved < Airrecord::Table
  self.base_key = ENV['AIRTABLE_BASE_KEY']
  self.table_name = 'YouTube Saved'
end

module Jekyll
  class SavedGenerator < Generator
    safe true

    BASE_FOLDER = "_videos"

    def generate(site)
      return

      Saved.all.each do |video|
        video_file = "#{BASE_FOLDER}/yt_#{video["ID"]}.md"

        puts video_file.to_s

        data = {
          'title' => video["Title"].strip,
          'author' => video["Owner"].strip,
          'thumbnail' => "https://i.ytimg.com/vi/#{video["ID"]}/mqdefault.jpg",
          'date' => DateTime.parse(video["Created"]).strftime('%Y-%m-%d %H:%M:%S %z'),
        }

        yaml = YAML.dump(data)
        yaml << "---\n\n"
        yaml << "{% youtube #{video["ID"]} %}"

        FileUtils.mkdir_p(File.dirname(video_file))
        File.write(video_file, yaml)
      end
    end
  end
end
