# frozen_string_literal: true

class LastFm < Jekyll::Generator
  safe true

  def generate(site)
    config = site.config['jekyll_last_fm']
    return unless config

    user = config['user']
    api_key = config['api_key']
    limit = config['limit']
    return unless user && api_key

    last_fm_url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{user}&api_key=#{api_key}&limit=#{limit}&format=json"
    last_fm_json = JSON.parse(URI.parse(last_fm_url).open.read)

    return unless last_fm_json['recenttracks']['track']

    site.data['last_fm'] = []
    last_fm_json['recenttracks']['track'].each do |track|
      site.data['last_fm'] << {
        'title' => track['name'],
        'url' => track['url'],
        'artist' => track['artist']['#text'],
        'album' => track['album']['#text'],
        'image' => track['image'][0]['#text']
      }
    end
  end
end
