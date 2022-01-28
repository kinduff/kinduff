# frozen_string_literal: true

module Jekyll
  class SocialImageGenerator < Generator
    safe true

    def generate(site)
      site.collections["posts"].docs.each do |doc|
        site.pages << create_page(site, site.collections["posts"], doc)
      end
    end

    private

    def create_page(site, collection, doc)
      Document.new(doc.path, :site => site, :collection => collection).tap do |new_doc|
        new_doc.read
        new_doc.data["layout"] = "social"
        new_doc.data["permalink"] = "#{doc.url}/social/"
      end
    end
  end
end
