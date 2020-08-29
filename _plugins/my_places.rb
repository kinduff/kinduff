require 'open-uri'
require 'ox'
require 'yaml'

module Jekyll
  class MyPlacesGenerator < Generator
    safe true

    def generate(site)
      return unless site.config['my_places']

      kml_source = site.config['my_places']['kml_source']
      kml_file = URI.open(kml_source).read
      xml = Ox.load(kml_file, mode: :hash)

      places_hash = []
      xml[:kml][1][:Document][:Folder].each do |folder|
        places_name = folder[:name]
        placemarks = folder[:Placemark]
        icon = site.config['my_places']['marker_icons'].find{|i| i["title"] == places_name }["marker_url"]
        placemarks.each do |placemark|
          place_name = placemark[:name]
          longitude, latitude = placemark[:Point][:coordinates].split(',').map(&:to_f)

          places_hash << {
            "title" => place_name,
            "location" => {
              "longitude" => longitude,
              "latitude" => latitude,
              "marker_icon" => icon
            }
          }
        end
      end

      File.write(File.join(site.source, "_data", "places.yml"), places_hash.to_yaml)
    end
  end
end
